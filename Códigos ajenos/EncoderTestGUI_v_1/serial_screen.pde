import processing.serial.*;

Serial myPort;

void setupSerial()
{
  // List all the available serial ports:
  println(Serial.list());
  // I know that the port 7 in the serial list on my pc
  // is always my  Arduino or Wiring module, so I open Serial.list()[7].
  // Open whatever port is the one you're using.
  String portName = Serial.list()[7];
  myPort = new Serial(this, portName, 19200);
  myPort.clear();
  // don't generate a serialEvent() until you get a newline (\n) byte:
  myPort.bufferUntil('\n');
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  
  //Dont update the controls when dragged and released event are active..
  if(!dragged && !released && !pressed){
   
    // if it's not empty:
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      
      if(skip > 5){
      
        if(split(inString, ",").length >= 5){  //The nr off expected values
        
          // convert to an array of floats:
          float[] temp = float(split(inString, ","));
          
          //Create temp variabels for each graph
          float[] f_sensors = new float[2];
          float[] f_updateRate = new float[1];
          float[] f_motorOffsets = new float[2];
          
          //Getting the values for the sensors control if any
          if(temp.length >= 2){
            f_sensors[0] = temp[0];
            f_sensors[1] = temp[1];
            sensors.setValues(f_sensors);
          }
          
          //Getting values for the updateRate control if any
          if(temp.length >= 3){
            f_updateRate[0] = temp[2];
            updateRate.setValues(f_updateRate);
          }
          
          //Getting values for the motorOffseta control if any
          if(temp.length >= 5){
            f_motorOffsets[0] = temp[3];
            f_motorOffsets[1] = temp[4];            
            motorOffsets.setValues(f_motorOffsets);
          }
        }
      }else{
        skip++;
      }
    }
  }
}


/*
  Sets the scrren size
*/
void setupScreen(int type){
  switch(type){
    case 0:
      size(1024,580);
      break;
    case 2:
      size(1024,768);
      break;
    case 4:
      size(1280,720);
      break;
    case 6:
      size(1280,1024);
      break;
    case 8:
      size(1366,768);
      break;
    case 10:
      size(1920,1080);
      break;
    default:
      size(1024,580);
  }
  
  // set inital background:
  background(0);
  // turn on antialiasing:
  smooth();
}

