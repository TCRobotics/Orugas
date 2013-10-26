import processing.serial.*;

Serial myport;

void setupSerial()
{
  // List all the available serial ports:
  println(Serial.list());
  // I know that the port 7 in the serial list on my pc
  // is always my  Arduino or Wiring module, so I open Serial.list()[7].
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myport = new Serial(this, portName, 9600);
  myport.clear();
  // don't generate a serialEvent() until you get a newline (\n) byte:
  myport.bufferUntil('\n');
}

void serialEvent (Serial myport) {
  // get the ASCII string:
  inString = myport.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      if(skip > 5){
      
        if(split(inString, ",").length == 6){  //The nr off expected values
        
          // convert to an array of floats:
          float[] temp = float(split(inString, ","));
          float f = temp[0];
          anguloX = temp[1];
          anguloY = temp[2];
          distancia = temp[3];
          luminosidad = temp[4];
          temperatura = temp[5];            
          if(f== 1 ){
            println("Recibi: "+ anguloX + "," + anguloY +","+distancia + "," +luminosidad +","+ temperatura );
          }
          
          if(f== 2 ){
            println("[Orugas dice]>"+inString);  
          }
          if(f!=2 && f!=1){
            print("!!!!!!!!!!!!!!!!!!!!   DATO CON FORMATO INCORRECTO   !!!!!!!!!!!!!!!!!!!!  ");  
            println("Recibi: "+inString);
          }  
        }
        else{
          println("Recibi de Orugas: "+inString);
        }
      }
      else{skip++;}

    }

}

void enviaVel(){
    if (vel<10) myport.write('0');
    if (vel==100){
      myport.write("99");
    }
    else {
      myport.write(str(vel));
    }  
}  
  
