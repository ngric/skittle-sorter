
#include <Wire.h>
#include "Adafruit_TCS34725.h"
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"
#include <Servo.h>

// Pins
const int encoderPin = 2;
const int servo1Pin = 4;
const int servo2Pin = 5;
const int servo3Pin = 6;
const int servo4Pin = 7;
const int vibrationPin = 9;

// Trap-door servos
Servo door[4];

// Motor Shield
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
Adafruit_DCMotor *myMotor = AFMS.getMotor(1);

// Global
volatile int count = 0;
int lastCount = -1;
unsigned long queue = 0UL;
const int CHANGE_DELAY = 100 ;

// Servo
const int OPEN = 60;
const int CLOSED = 100;

// Example code for the Adafruit TCS34725 breakout library applied to Skittle colour classification.
// This example uses RGB vectors for classification.  It also converts the RGB vector to a HSB colourspace, 
// which is likely more robust for this classification, but does not implement the HSB classification.
// (If you change to HSB, you will likely only need hue and saturation, and not brightness). 

// More information:
// Breakout board: https://www.adafruit.com/product/1334
// Library: https://github.com/adafruit/Adafruit_TCS34725
// Installation instructions: https://learn.adafruit.com/adafruit-all-about-arduino-libraries-install-use/how-to-install-a-library

   
// Initialise TCS24725 with specific int time and gain values 
// Note: 2-4 millisecond integration (sampling) times mean we can sample at about 250-500Hz
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_24MS, TCS34725_GAIN_1X);

/*
 * Global colour sensing variables
 */

#define NUM_COLORS  6

// Skittle colours to indices
#define COL_RED     0
#define COL_GREEN   1
#define COL_ORANGE  2
#define COL_YELLOW  3
#define COL_PURPLE  4
#define COL_NOTHING 5

// Names for colours
#define COLNAME_RED     "RED"
#define COLNAME_GREEN   "GREEN"
#define COLNAME_ORANGE  "ORANGE"
#define COLNAME_YELLOW  "YELLOW"
#define COLNAME_PURPLE  "PURPLE"
#define COLNAME_NOTHING "NOTHING"

// RGB channels in the array
#define CHANNEL_R   0
#define CHANNEL_G   1
#define CHANNEL_B   2

// Training colours (populate these manually, but these vectors must be of unit length (i.e. length 1))
float trainingColors[3][NUM_COLORS];    // 3(rgb) x NUM_COLORS.

// Last read colour
float rNorm = 0.0f;
float gNorm = 0.0f;
float bNorm = 0.0f;
float hue = 0.0f;
float saturation = 0.0f;
float brightness = 0.0f;

// Last classified class
int lastClass = -1;
float lastCosine = 0;

/*
 * Colour sensing
 */
void initializeTrainingColors() {
  // Skittle: red
  trainingColors[CHANNEL_R][COL_RED] = 0.828;
  trainingColors[CHANNEL_G][COL_RED] = 0.415;
  trainingColors[CHANNEL_B][COL_RED] = 0.374;

  // Skittle: green
  trainingColors[CHANNEL_R][COL_GREEN] = 0.537;
  trainingColors[CHANNEL_G][COL_GREEN] = 0.762;
  trainingColors[CHANNEL_B][COL_GREEN] = 0.360;

  // Skittle: orange
  trainingColors[CHANNEL_R][COL_ORANGE] = 0.921;
  trainingColors[CHANNEL_G][COL_ORANGE] = 0.326;
  trainingColors[CHANNEL_B][COL_ORANGE] = 0.210;

  // Skittle: yellow
  trainingColors[CHANNEL_R][COL_YELLOW] = 0.690;
  trainingColors[CHANNEL_G][COL_YELLOW] = 0.659;
  trainingColors[CHANNEL_B][COL_YELLOW] = 0.296;

  // Skittle: purple
  trainingColors[CHANNEL_R][COL_PURPLE] = 0.8586;
  trainingColors[CHANNEL_G][COL_PURPLE] = 0.3487;
  trainingColors[CHANNEL_B][COL_PURPLE] = 0.3758;

  // Nothing
  trainingColors[CHANNEL_R][COL_NOTHING] = 0.6729;
  trainingColors[CHANNEL_G][COL_NOTHING] = 0.5633;
  trainingColors[CHANNEL_B][COL_NOTHING] = 0.4794;
}


void getNormalizedColor() {
  uint16_t r, g, b, c, colorTemp, lux;  
  tcs.getRawData(&r, &g, &b, &c);
  Serial.print("RAW: ");
  Serial.print(" R: "); Serial.print(r);
  Serial.print(" G: "); Serial.print(g);
  Serial.print(" B: "); Serial.println(b);
  Serial.println();

  float lenVec = sqrt((float)r*(float)r + (float)g*(float)g + (float)b*(float)b);

  // Note: the Arduino only has 2k of RAM, so rNorm/gNorm/bNorm are global variables. 
  rNorm = (float)r/lenVec;
  gNorm = (float)g/lenVec;
  bNorm = (float)b/lenVec;

  // Also convert to HSB:
  RGBtoHSV(rNorm, gNorm, bNorm, &hue, &saturation, &brightness);
}


int getColorClass() {
  float distances[NUM_COLORS] = {0.0f};

  // Step 1: Compute the cosine similarity between the query vector and all the training colours. 
  for (int i=0; i<NUM_COLORS; i++) {
    // For normalized (unit length) vectors, the cosine similarity is the same as the dot product of the two vectors.
    float cosineSimilarity = rNorm*trainingColors[CHANNEL_R][i] + gNorm*trainingColors[CHANNEL_G][i] + bNorm*trainingColors[CHANNEL_B][i];
    distances[i] = cosineSimilarity;

    // DEBUG: Output cosines
    //Serial.print("   C"); Serial.print(i); Serial.print(": "); Serial.println(cosineSimilarity, 3);
  }

  // Step 2: Find the vector with the highest cosine (meaning, the closest to the training color)
  float maxVal = distances[0];
  int maxIdx = 0;
  for (int i=0; i<NUM_COLORS; i++) {
    if (distances[i] > maxVal) {
      maxVal = distances[i];
      maxIdx = i;
    }
  }

  // Step 3: Return the index of the minimum color
  lastCosine = maxVal;
  lastClass = maxIdx;
  return maxIdx;
}


// Convert from colour index to colour name.
void printColourName(int colIdx) {
  switch (colIdx) {
    case COL_RED:
      Serial.print(COLNAME_RED);
      break;
    case COL_GREEN:
      Serial.print(COLNAME_GREEN);
      break;
    case COL_ORANGE:
      Serial.print(COLNAME_ORANGE);
      break;
    case COL_YELLOW:
      Serial.print(COLNAME_YELLOW);
      break;
    case COL_PURPLE:
      Serial.print(COLNAME_PURPLE);
      break;
    case COL_NOTHING:
      Serial.print(COLNAME_NOTHING);
      break;
    default:
      Serial.print("ERROR");
      break;
  }
}

// RGB to HSV.  From https://www.cs.rit.edu/~ncs/color/t_convert.html . 
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {  
  float minVal = min(min(r, g), b);
  float maxVal = max(max(r, g), b);
  *v = maxVal;       // v
  float delta = maxVal - minVal;
  if( maxVal != 0 )
    *s = delta / maxVal;   // s
  else {
    // r = g = b = 0    // s = 0, v is undefined
    *s = 0;
    *h = -1;
    return;
  }
  if( r == maxVal )
    *h = ( g - b ) / delta;   // between yellow & magenta
  else if( g == maxVal )
    *h = 2 + ( b - r ) / delta; // between cyan & yellow
  else
    *h = 4 + ( r - g ) / delta; // between magenta & cyan
  *h *= 60;       // degrees
  if( *h < 0 )
    *h += 360;
}

/*
 * Main Arduino functions
 */
 
void setup(void) {
  Serial.begin(115200);

  // Populate array of training colours for classification. 
  initializeTrainingColors();
  
  if (tcs.begin()) {
    Serial.println("Found sensor");
  } else {
    Serial.println("No TCS34725 found ... check your connections");
    while (1);
  }
  
  // Now we're ready to get readings!

    pinMode(encoderPin, INPUT);
    attachInterrupt(digitalPinToInterrupt(encoderPin), encoderStep, FALLING);

    AFMS.begin();
    myMotor->setSpeed(60);
    myMotor->run(FORWARD);
    delay(CHANGE_DELAY);

    door[0].attach(servo1Pin);
    door[1].attach(servo2Pin);
    door[2].attach(servo3Pin);
    door[3].attach(servo4Pin);

    pinMode(vibrationPin, OUTPUT);
    analogWrite(vibrationPin, 255);

    door[0].write(OPEN);
    door[1].write(OPEN);
    door[2].write(OPEN);
    door[3].write(OPEN);
}

void loop(void) {
    // Step 1: Get normalized colour vector
    getNormalizedColor();
    int colClass = getColorClass();   

    #ifdef DEBUG
    delay(24);
    // Step 2: Output colour
    Serial.print("R: "); Serial.print(rNorm, 3); Serial.print("  ");
    Serial.print("G: "); Serial.print(gNorm, 3); Serial.print("  ");
    Serial.print("B: "); Serial.print(bNorm, 3); Serial.print("  ");  
    Serial.print("H: "); Serial.print(hue, 3); Serial.print("  ");
    Serial.print("S: "); Serial.print(saturation, 3); Serial.print("  ");
    Serial.print("B: "); Serial.print(brightness, 3); Serial.print("  ");
     
    printColourName(colClass);  
    Serial.print(" (cos: "); Serial.print(lastCosine); Serial.print(") ");
    Serial.println("");
    #endif

    enqueue(colClass);

    if (count == lastCount) {
        Serial.print("Last: "); Serial.print(lastCount); Serial.print("Count: "); Serial.println(count); 
        unjam();
    } else {
        lastCount = count;
    }

    if ( count > 125) {
      count = 0;
      queue = (queue >> 4) & 0x7FFFF;
      Serial.print("Queue: "); Serial.println(queue, BIN);
      readQueue();
    }
}

void unjam() {
    int tmp = count;
    myMotor->run(BACKWARD);
    delay(CHANGE_DELAY);
    myMotor->run(FORWARD);
    delay(CHANGE_DELAY);
    noInterrupts();
    count = tmp;
    lastCount = count -1;
    interrupts();
}

void enqueue(int colClass) {
    if (colClass == 0) { //red
        bitSet(queue, 8);
    } else if (colClass == 1) { //green
        bitSet(queue, 13);
    } else if (colClass == 2) { //orange
        bitSet(queue, 18);
    } else if (colClass == 3) { //yellow
        bitSet(queue, 23);
    }
}

void readQueue(){
    for (int i = 0; i < 4; i++) {
        if (bitRead(queue, i)) {
            door[i].write(OPEN);
        } else {
            door[i].write(CLOSED);
        }
    }
}

void encoderStep() {
    count++;
}
