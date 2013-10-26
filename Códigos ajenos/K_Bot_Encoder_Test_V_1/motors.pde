// KasBot V1  -  Motors module

float motorOffsetR = 1;
float motorOffsetL = 1;
boolean forward = true;

int Drive_Motor(int torque)  {
  if (torque > 0)  { 
    // drive motors forward
    digitalWrite(InA_R, LOW); 
    digitalWrite(InB_R, HIGH);
    digitalWrite(InA_L, LOW);                       
    digitalWrite(InB_L, HIGH);        
    forward = true;    
  }else if(torque < 0) {     // drive motors backward
    digitalWrite(InB_R, LOW);
    digitalWrite(InA_R, HIGH);                       
    digitalWrite(InB_L, LOW);
    digitalWrite(InA_L, HIGH);                      
    torque = abs(torque);
    forward = false;
  }else{
    if(forward){
      digitalWrite(InA_R, HIGH);                       
      digitalWrite(InB_R, LOW);
      digitalWrite(InA_L, HIGH);                      
      digitalWrite(InB_L, LOW); 
    }else{
      digitalWrite(InA_R, LOW);                       
      digitalWrite(InB_R, HIGH);
      digitalWrite(InA_L, LOW);                      
      digitalWrite(InB_L, HIGH); 
    }
  }
  //if(torque>5) map(torque,0,255,30,255);
    analogWrite(PWM_R,torque * motorOffsetR);
    analogWrite(PWM_L,torque * motorOffsetL); 
    Serial.println(torque,DEC);
}

void motors_stop(){
  digitalWrite(InA_R, LOW);                       
  digitalWrite(InB_R, LOW);
  digitalWrite(InA_L, LOW);                      
  digitalWrite(InB_L, LOW);
  
  analogWrite(PWM_R,0);
  analogWrite(PWM_L,0); 
}

void rencoder_R()  {                                  // pulse and direction, direct port reading to save cycles
  if (PIND & 0b00100000)    count_R++;                // if(digitalRead(encodPinB_R)==HIGH)   count_r ++;
  else                      count_R--;                // if (digitalRead(encodPinB_R)==LOW)   count_r --;
}

void rencoder_L()  {                                  // pulse and direction, direct port reading to save cycles
  if (PINB & 0b00010000)    count_L--;                // if(digitalRead(encodPinB_L)==HIGH)   count_r ++;
  else                      count_L++;                // if (digitalRead(encodPinB_L)==LOW)   count_r --;
}

