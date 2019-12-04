#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"
#include <Servo.h>

// Pins
const int encoderPin = 2;
const int servo1Pin = 4;
const int servo2Pin = 5;
const int servo3Pin = 6;
const int servo4Pin = 7;

// Trap-door servos
Servo door[4];

// Motor Shield
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
Adafruit_DCMotor *myMotor = AFMS.getMotor(1);

// Global
volatile int count = 0;
uint8_t dir = FORWARD;

// Servo
const int OPEN = 10;
const int CLOSED = 170;
int curOpen = 1;

void setup() {
    //Serial.begin(9600);

    pinMode(encoderPin, INPUT);
    attachInterrupt(digitalPinToInterrupt(encoderPin), encoderStep, FALLING);

    AFMS.begin();
    myMotor->setSpeed(100);
    myMotor->run(dir);

    door[0].attach(servo1Pin);
    door[1].attach(servo2Pin);
    door[2].attach(servo3Pin);
    door[3].attach(servo4Pin);

    door[0].write(OPEN);
    door[1].write(OPEN);
    door[2].write(OPEN);
    door[3].write(OPEN);
}

void loop() {
//    if (count < 250) {
//        door[0].write(OPEN);
//        door[1].write(OPEN);
//        door[2].write(OPEN);
//        door[3].write(OPEN);
//    } else if (count < 500) {
//        door[0].write(CLOSED);
//        door[1].write(CLOSED);
//        door[2].write(CLOSED);
//        door[3].write(CLOSED);
//    } else {
//        count = 0;
//        reverse();
//    }
    if (count > 250) {
        count = 0;
        //reverse();
        nextDoor();
    }
    Serial.println(count);
}

void nextDoor() {
    //Serial.print("Closing ");
    //Serial.println(curOpen);
    door[curOpen].write(CLOSED);

    curOpen = (curOpen + 1) % 4;
    //Serial.print("Opening ");
    //Serial.println(curOpen);
    door[curOpen].write(OPEN);
}

void reverse() {
    dir = (dir == FORWARD) ? BACKWARD : FORWARD;
    myMotor->run(dir);
}

void encoderStep() {
    count++;
}
