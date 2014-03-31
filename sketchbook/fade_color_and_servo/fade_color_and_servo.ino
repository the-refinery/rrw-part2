#include <Servo.h> 

const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;
const int servoPin = 3;

const int bufferSize = 4;

const int fadeStepInterval = 2;

int red = 0;
int green = 0;
int blue = 0;

int prevRed = red;
int prevGreen = green;
int prevBlue = blue;

Servo myservo;

void setup()
{
  // initialize the serial communication:
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  
  myservo.attach(servoPin);
  myservo.write(0);
}

void loop() {
  char buffer[bufferSize];
  byte color[3];
  
  // check if data has been sent from the computer:
  if (Serial.available()) {
     Serial.readBytes(buffer, bufferSize);
  
     color[0] = byte(buffer[0]);
     color[1] = byte(buffer[1]);
     color[2] = byte(buffer[2]);
     
     crossFade(color);
     
     if (buffer[3] > 0)
     {
       runServo();
     }
  }  
}

int calculateStep(int prevValue, int endValue) {
  int step = endValue - prevValue; // What's the overall gap?
  if (step) {                      // If its non-zero, 
    step = 1020/step;              //   divide by 1020
  } 
  return step;
}

int calculateVal(int step, int val, int i) {

  if ((step) && i % step == 0) { // If step is non-zero and its time to change a value,
    if (step > 0) {              //   increment the value if step is positive...
      val += 1;           
    } 
    else if (step < 0) {         //   ...or decrement it if step is negative
      val -= 1;
    } 
  }
  // Defensive driving: make sure val stays in the range 0-255
  if (val > 255) {
    val = 255;
  } 
  else if (val < 0) {
    val = 0;
  }
  return val;
}

void crossFade(byte color[3]) {
  int stepR = calculateStep(prevRed, color[0]);
  int stepG = calculateStep(prevGreen, color[1]); 
  int stepB = calculateStep(prevBlue, color[2]);
  
  for (int i = 0; i <= 1020; i++) {
    red = calculateVal(stepR, red, i);
    green = calculateVal(stepG, green, i);
    blue = calculateVal(stepB, blue, i);

    analogWrite(redPin, red);   // Write current values to LED pins
    analogWrite(greenPin, green);      
    analogWrite(bluePin, blue); 

    delay(fadeStepInterval); // Pause for 'wait' milliseconds before resuming the loop
  }
  
  // Update current values for next loop
  prevRed = red; 
  prevGreen = green; 
  prevBlue = blue;
}

void runServo()
{
  int i;
  
  for (i=0; i < 3; i++)
  {
    myservo.write(45);
    delay(300);
     
    myservo.write(135);
    delay(300);
  }
  
  myservo.write(0);
}
