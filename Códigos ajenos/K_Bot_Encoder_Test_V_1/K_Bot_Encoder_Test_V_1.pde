// KasBot Encoder test V1  -  Main module       basic version, angles in Quids, 10 bit ADC
/*
  Description:
  The KasBot Encoder test Vx is made for checking that the encoder signal workes and
  to tune the diffrenses from your motors..
  
  This code is aimed for the Encoder test GUI v1.0
  
  Version log:
  
  v1.0  -
  
*/

#define   InA_R          6                      // INA right motor pin 
#define   InB_R          7                      // INB right motor pin
#define   PWM_R          10                     // PWM right motor pin
#define   InA_L          8                      // INA left motor pin
#define   InB_L          9                      // INB left motor pin
#define   PWM_L          11                     // PWM left motor pin
#define encodPinA_R      3                      // encoder A pin left motor
#define encodPinB_R      5                      // encoder B pin right motor
#define encodPinA_L      2                      // encoder A pin left motor
#define encodPinB_L      12                     // encoder B pin right motor

#define LOOPTIME         100                    // PID loop time
#define FORWARD          1                      // direction of rotation
#define BACKWARD         2                      // direction of rotation

#define DELAY_TIME       5000                   //Time to delay after motion
#define RUN_TIME         2000                   //Time to run motor

int speeds[] = {50, 100, 200, 255};
int speedIndex = 0;

int STD_LOOP_TIME  =  9;             

int lastLoopTime = STD_LOOP_TIME;
int lastLoopUsefulTime = STD_LOOP_TIME;
unsigned long loopStartTime = 0;

unsigned long delayStart = 0;

long count_R = 0;                                 // rotation counter right motor
long count_L = 0;                                 // rotation counter left motor

boolean frwMotion = true;                         // motor moves

void setup() {
  pinMode(InA_R, OUTPUT);
  pinMode(InB_R, OUTPUT);
  pinMode(PWM_R, OUTPUT);
  pinMode(InA_L, OUTPUT);
  pinMode(InB_L, OUTPUT);
  pinMode(PWM_L, OUTPUT);
  
  pinMode(encodPinA_R, INPUT);
  pinMode(encodPinB_R, INPUT);
  digitalWrite(encodPinA_R, HIGH);                      // turn on pullup resistor
  digitalWrite(encodPinB_R, HIGH);
  attachInterrupt(1, rencoder_R, FALLING);
  
  pinMode(encodPinA_L, INPUT);
  pinMode(encodPinB_L, INPUT);
  digitalWrite(encodPinA_L, HIGH);                      // turn on pullup resistor
  digitalWrite(encodPinB_L, HIGH);
  attachInterrupt(0, rencoder_L, FALLING);
  
  Serial.begin(19200);
}

void loop() {
// ********* Simple motor test for serial monitor ***********************

  //motorDebugForSerialMonitor();
  
// *********************** Motor drive **********************************
  //Turns motors on for RUN_TIME and then off for DELAY_TIME 
  if((millis() - delayStart) <= RUN_TIME){
    if(frwMotion){
      Drive_Motor(speeds[speedIndex]);
    }else{
      Drive_Motor((speeds[speedIndex] * (-1)));
    }
  }else if((millis() - delayStart) > RUN_TIME){
    Drive_Motor(0);
  }
  
  if((millis() - delayStart) >= (RUN_TIME + DELAY_TIME)){
    delayStart = millis();
    if(frwMotion){
      frwMotion = false;
    }else{
      speedIndex++;
      frwMotion = true;  
    }  
    clearCounts(); 
    if(speedIndex >= 3) speedIndex=0;
  }
  
 // *********************** print Debug info *****************************
  serialIn_GUI();       //Processing information from a pc
  serialOut_GUI();	//Sending information to pc for debug
  
 // *********************** loop timing control **************************
  lastLoopUsefulTime = millis()-loopStartTime;
  if(lastLoopUsefulTime<STD_LOOP_TIME)         delay(STD_LOOP_TIME-lastLoopUsefulTime);
  lastLoopTime = millis() - loopStartTime;
  loopStartTime = millis();
  
}

void clearCounts(){
  count_L = 0;
  count_R = 0;
}

void motorDebugForSerialMonitor()
{
  Drive_Motor(255);
  delay(2000);
  Drive_Motor(0);
  delay(500);
  Serial.print(count_L,DEC);
  Serial.print(" : ");
  Serial.println(count_R,DEC);
  clearCounts();
  delay(4500);
  
  Drive_Motor(-255);
  delay(2000);
  Drive_Motor(0);
  delay(500);
  Serial.print(count_L,DEC);
  Serial.print(" : ");
  Serial.println(count_R,DEC);
  clearCounts();
  delay(4500);
  
  Drive_Motor(150);
  delay(2000);
  Drive_Motor(0);
  delay(500);
  Serial.print(count_L,DEC);
  Serial.print(" : ");
  Serial.println(count_R,DEC);
  clearCounts();
  delay(4500);
  
  Drive_Motor(-150);
  delay(2000);
  Drive_Motor(0);
  delay(500);
  Serial.print(count_L,DEC);
  Serial.print(" : ");
  Serial.println(count_R,DEC);
  clearCounts();
  delay(4500);
  
  Drive_Motor(50);
  delay(2000);
  Drive_Motor(0);
  delay(500);
  Serial.print(count_L,DEC);
  Serial.print(" : ");
  Serial.println(count_R,DEC);
  clearCounts();
  delay(4500);
  
  Drive_Motor(-50);
  delay(2000);
  Drive_Motor(0);
  delay(2000);
  Serial.print(count_L,DEC);
  Serial.print(" : ");
  Serial.println(count_R,DEC);
  clearCounts();
  delay(4500);
  
  while(true){delay(100);} 
}


