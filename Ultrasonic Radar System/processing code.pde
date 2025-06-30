import cc.arduino.*;
import processing.serial.*;

Arduino arduino;
int servoAngle = 0;
int distance = 0;
int maxDistance = 50;

int buttonX = -width / 2 + 60;
int buttonY = 50;
int buttonW = 200;
int buttonH = 50;
boolean buttonPressed = false;
PrintWriter output;




void setup() {
  size(1280, 720);
  //arduino = new Arduino(this, "COM8", 9600);
  output = createWriter("radar.txt");
}

void draw() {
  
  //distance = arduino.analogRead(0);
  if (distance > maxDistance) distance = maxDistance;
  //if (distance != 0) servoAngle = arduino.analogRead(1);
  println("Distance: " + distance + " cm");
  println("Servo Angle: " + servoAngle);
  if (distance != maxDistance && distance != 0){
    output.println(hour() + ":" + minute() + ":" + second() + "  -  " + distance + ", " + servoAngle);
    output.flush();
  }
  fill(0, 5);
  rect(0, 0, width, height);
  drawLINE();
  drawRADAR();
  
  drawOBJECT();
  drawTEXT();
  
  
  fill(200);
  rect(buttonX, buttonY, buttonW, buttonH);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Initiate Object Search", buttonX + buttonW / 2, buttonY + buttonH / 2);
  textAlign(LEFT, BOTTOM);
  
}

void drawRADAR(){
   pushMatrix();
   translate(width / 2, height * 0.94);
   noFill();
   strokeWeight(2);
   stroke(0, 128, 0);
   for (int i = 0; i < 6; i++){
     arc(0, 0, width * (0.94 - 0.188 * i), width * (0.94 - 0.188 * i), PI, 2 * PI);
   }
   for (int i = 0; i < 7; i++){
     line(0, 0, -width * 0.47 * cos(radians(30 * i)), -width * 0.47 * sin(radians(30 * i)));
   }
   popMatrix();
}


void drawLINE(){

  pushMatrix();
  translate(width/2, height * 0.94);
  noFill();
  strokeWeight(2);
  stroke(0, 120, 0);
  line(0, 0, width * 0.47 * cos(radians(servoAngle)), -width * 0.47 * sin(radians(servoAngle)));
  popMatrix();
}

void drawOBJECT(){
  pushMatrix();
  translate(width/2,height*0.94);
  noFill();
  
  stroke(255, 0,0);
  if (distance != maxDistance && distance != 0){
    if (buttonPressed){
      strokeWeight(10);
      line(distance * 600 * cos(radians(servoAngle)) / maxDistance, -distance * 600 * sin(radians(servoAngle)) / maxDistance, distance * 600 * cos(radians(servoAngle)) / maxDistance, -distance * 600 * sin(radians(servoAngle)) / maxDistance);
    }
    else{
      strokeWeight(4);
      line(distance * 600 * cos(radians(servoAngle)) / maxDistance, -distance * 600 * sin(radians(servoAngle)) / maxDistance, width*0.47*cos(radians(servoAngle)), -width*0.47*sin(radians(servoAngle)));
    }
  }
  strokeWeight(2);
  popMatrix();
}


void drawTEXT(){
  pushMatrix();
  
  fill(0, 0, 0);
  noStroke();
  rect(0, height * 0.94, width, height);
  rect(0, -width / 2, width, height * 0.94);
  
  translate(width/2, height * 0.94);
  
  fill(255, 255, 0);
  textSize(40);
  if (distance == maxDistance && distance != 0){
    text("No Object Detected", - width * 0.47, 0.06 * height);
  }
  else{
    text("Polar: (" + distance + ", " + servoAngle + ")", - width * 0.47, 0.06 * height);
    text("Distance: " + distance + " cm, Angle: " + servoAngle + "°", width * (0.94 - 0.188 * 4.5), 0.06 * height);
  }
  

  
  textSize(40);
  text(hour() + ":" + minute() + ":" + second(), width * 0.47 - 120, -width / 2);
  text("Sonic Seekers", -width / 2 + 10, -width / 2);
  textSize(20);
  for (int i = 1; i < 6; i++){
    text(i * maxDistance / 5 + " cm", 0.188 * i * width / 2 - 52, -2.5);
  }
  textAlign(CENTER, CENTER);
  for (int i = 0; i < 7; i++){
  text(30 * i + "°", (width + 40)*0.47*cos(radians(30 * i)), -(width + 40)*0.47*sin(radians(30 * i)));
  }
  textAlign(LEFT, BOTTOM);
  
  popMatrix();
  
}


void mousePressed() {
  if (mouseX > buttonX && mouseX < buttonX + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH) {
    buttonPressed = !buttonPressed;
  }
}
