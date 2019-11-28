#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

const int encoderPin = 2;

Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
Adafruit_DCMotor *myMotor = AFMS.getMotor(1);

volatile int count = 0;
uint8_t dir = FORWARD;

void setup() {
    Serial.begin(9600);

    pinMode(encoderPin, INPUT);
    attachInterrupt(digitalPinToInterrupt(encoderPin), encoderStep, FALLING);

    AFMS.begin();
    myMotor->setSpeed(150);
    myMotor->run(dir);
}

void loop() {
    if (count > 250) {
        count = 0;
        reverse();
    }
    Serial.println(count);
}

void reverse() {
    dir = (dir == FORWARD) ? BACKWARD : FORWARD;
    myMotor->run(dir);
}

void encoderStep() {
    count++;
}
