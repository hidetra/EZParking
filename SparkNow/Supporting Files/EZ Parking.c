//
//  EZ Parking.c
//  FirebaseAuth
//
//  Created by Toan Tran on 12/6/19.
//

#include "EZ Parking.h"
#define echoPin1 2 // Echo Pin for sonar 1
#define trigPin1 3 // Trigger Pin for sonar 1
#define echoPin2 4 // Echo Pin for sonar 2
#define trigPin2 5 // Trigger Pin for sonar 2
#define echoPin3 6 // Echo Pin for sonar 3
#define trigPin3 7 // Trigger Pin for sonar 3
#define echoPin4 8 // Echo Pin for sonar 4
#define trigPin4 9 // Trigger Pin for sonar 4
#define echoPin5 10 // Echo Pin for sonar 5
#define trigPin5 11 // Trigger Pin for sonar 5
#define echoPin6 12 // Echo Pin for sonar 6
#define trigPin6 13 // Trigger Pin for sonar 6


long  duration1, distance1; // Duration used to calculate distance
long  duration2, distance2;
long  duration3, distance3;
long  duration4, distance4;
long  duration5, distance5;
long  duration6, distance6;

int North, South;

void setup() {
  Serial.begin (9600); // initiate serial communication to raspberry pi
  pinMode(trigPin1, OUTPUT); // trigger pin as output
  pinMode(echoPin1, INPUT);  // echo pin as input
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);
  pinMode(trigPin3, OUTPUT);
  pinMode(echoPin3, INPUT);
  pinMode(trigPin4, OUTPUT);
  pinMode(echoPin4, INPUT);
  pinMode(trigPin5, OUTPUT);
  pinMode(echoPin5, INPUT);
  pinMode(trigPin6, OUTPUT);
  pinMode(echoPin6, INPUT);
    }

    void loop() {
      digitalWrite(trigPin1, LOW);
      delayMicroseconds(2);
      digitalWrite(trigPin1, HIGH);
      delayMicroseconds(10);
      digitalWrite(trigPin1, LOW);

     // pulseIn( ) function determines a pulse width in time
     // duration of pulse is proportional to distance of obstacle
        duration1 = pulseIn(echoPin1, HIGH);

        digitalWrite(trigPin2, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin2, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin2, LOW);
        duration2 = pulseIn(echoPin2, HIGH);

        digitalWrite(trigPin3, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin3, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin3, LOW);
        duration3 = pulseIn(echoPin3, HIGH);

        digitalWrite(trigPin4, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin4, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin4, LOW);
        duration4 = pulseIn(echoPin4, HIGH);

        digitalWrite(trigPin5, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin5, HIGH);
        duration5 = pulseIn(echoPin5, HIGH);

        digitalWrite(trigPin6, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin6, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin6, LOW);
        duration6 = pulseIn(echoPin6, HIGH);

        //  distance = (high level timevelocity of sound (340M/S) / 2,
        //  in centimeter = uS/58
        distance1 = duration1/58.2;
        if(distance1<10)
          distance1 = 1;
        else distance1 = 0;


        distance2 = duration2/58.2;
        if(distance2<10)
          distance2 = 1;
        else distance2 = 0;

        distance3 = duration3/58.2;
        if(distance3<10)
          distance3 = 1;
        else distance3 = 0;

        distance4 = duration4/58.2;
        if(distance4<10)
          distance4 = 1;
        else distance4 = 0;

        distance5 = duration5/58.2;
        if(distance5<10)
          distance5 = 1;
        else distance5 = 0;

        distance6 = duration6/58.2;
        if(distance6<10)
          distance6 = 1;
        else distance6 = 0;

        // add the result from all sensor to count total cars
North = (3 - (distance1 + distance2 + distance3));
South = (3 - (distance4 + distance5 + distance6));

Serial.println(North);
Serial.println(South);
Serial.println(distance1);
Serial.println(distance2);
Serial.println(distance3);
Serial.println(distance4);
Serial.println(distance5);
Serial.println(distance6);
delay(5000);
}
