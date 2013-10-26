#define   LINE_END              10   // \n
#define   SPLIT                 58   // :

int updateRate=10;
int skipOut=0;

void serialOut_GUI() {  
  
  if(skipOut++>=updateRate) {                                                        
    skipOut = 0;
    //Encoder count
    Serial.print(count_R, DEC);       Serial.print(",");
    Serial.print(count_L, DEC);       Serial.print(",");
    
    Serial.print(updateRate, DEC);    Serial.print(",");
    
    Serial.print(motorOffsetL, DEC);  Serial.print(",");
    Serial.print(motorOffsetR, DEC);  Serial.print("\n");
  }
}

union u_tag {
  byte b[4];
  float fval;
} u;

int skipIn=0;

void serialIn_GUI(){
  
  if(skipIn++>=updateRate) {                                                        
    skipIn = 0;
    byte id;
    
    if(Serial.available() > 0)
    {               
      char param = Serial.read(); 
      //Serial.println("Have bytes");
      delay(10);
      byte inByte[Serial.available()];
      if(Serial.read() == SPLIT){
        if(Serial.available() >= 4){
          u.b[3] = Serial.read(); 
          u.b[2] = Serial.read(); 
          u.b[1] = Serial.read(); 
          u.b[0] = Serial.read(); 
          Serial.flush();
          
          switch (param) {
            case 'p':
              //Kp = int(u.fval);
              break;
            case 'i':
              //Ki = int(u.fval);
              break;
            case 'd':
              //Kd = int(u.fval);
              break;
            case 'k':
              //K = u.fval;
              break;
            case 's':
              //setPoint = int(u.fval);
              break;
            case 'u':
              updateRate = int(u.fval);
              break;
            case 'l':
              motorOffsetL = u.fval;
              break;
            case 'r':
              motorOffsetR = u.fval;
              break;
          }
        }
      }
      
    }
  }
}


