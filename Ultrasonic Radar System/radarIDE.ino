#include <Firmata.h>
#include <Servo.h>

Servo servo;

const int trigPIN = 9;
const int echoPIN = 10;
const int servoPIN = 11;
const int buzzerPIN = 7;
const int laserPIN = 4;
int servoAngle = 0;
int distance;
int direction = 1;
bool buzzer = 0;

void setup() {
  Serial.begin(9600);
  Firmata.begin(9600);
  servo.attach(servoPIN);
  pinMode(trigPIN, OUTPUT);
  pinMode(echoPIN, INPUT);
  pinMode(buzzerPIN, OUTPUT);
  pinMode(laserPIN, OUTPUT);
  digitalWrite(buzzerPIN, buzzer);
  servo.write(servoAngle);
}

void loop() {
  servo.write(servoAngle);
  getDistance();


  Firmata.sendAnalog(0, (int) distance);
  Firmata.sendAnalog(1, servoAngle);

  
  Serial.println(servoAngle);
  Serial.println(" ,");
  Serial.println(distance);

  if (distance == 0) buzzer = 0;
  else if (distance < 20) buzzer = 1;
  else buzzer = 0;
  digitalWrite(buzzerPIN, buzzer);
  digitalWrite(laserPIN, buzzer);

  delay(20);

  servoAngle += direction;
  if (servoAngle == 180) direction = -1;
  if (servoAngle == 0) direction = 1;
}

void getDistance() {
  digitalWrite(trigPIN, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPIN, LOW);

  distance = pulseIn(echoPIN, HIGH) * 0.034 / 2;
}