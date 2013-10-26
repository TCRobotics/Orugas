/*
 * WiiChuckDemo -- 
 *
 * 2008 Tod E. Kurt, http://thingm.com/
 *
 */

#include <Wire.h>
#include "nunchuck_funcs.h"
#include <Servo.h> 

int loop_cnt=0;

byte accx,accy,accz,joyx,joyy,zbut,cbut;
int ledPin = 13;
Servo servoX;
Servo servoY;
float angleX = 0;
float angleY = 0;
int loopCount = 0;
int avgCount = 0;

void setup()
{
    Serial.begin(19200);
    nunchuck_setpowerpins();
    nunchuck_init(); // send the initilization handshake
    servoX.attach(9);
    servoY.attach(10);
    Serial.println("WiiChuckDemo ready\n");
}

void loop()
{
    if( loop_cnt > 10 ) { // every 100 msecs get new data
        loop_cnt = 0;

        nunchuck_get_data();

        accx  = nunchuck_accelx(); // ranges from approx 70 - 182
        accy  = nunchuck_accely(); // ranges from approx 65 - 173
        accz  = nunchuck_accelz();
        joyx  = nunchuck_joyx();
        joyy  = nunchuck_joyy();
        zbut  = nunchuck_zbutton();
        cbut  = nunchuck_cbutton(); 
        
        nunchuck_print_data();    
        /*
        Serial.print("accx: "); Serial.print((byte)joyx,DEC);
        Serial.print("\taccy: "); Serial.print((byte)joyy,DEC);
        Serial.print("\tzbut: "); Serial.print((byte)zbut,DEC);
        Serial.print("\tcbut: "); Serial.println((byte)cbut,DEC);
   */
        angleX += map(joyx, 0, 255, 180, 0);
        angleY += map(joyy, 0, 255, 0, 180);
        if(avgCount  >=5 & zbut==1)
        {
          servoX.write(angleX/5);
          servoY.write(angleY/5);
          angleX = 0;
          angleY = 0;
          avgCount = 0;
        }
        avgCount++;
    }
    loop_cnt++;
    delay(1);
}

