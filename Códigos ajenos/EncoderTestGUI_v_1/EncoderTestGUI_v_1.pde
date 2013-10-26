/*
  Encoder test GUI v1 beta
  
  Description:
  This is a sketch for getting and receiving information from a 
  balancing bot and also to control it..
  
  Version log:

  Instructions:
  Dont forget to change the com port to the one on your computer
  in the setupSerial function in the serial_screen tab.
  
  Reads values throw serial communication from a arduino
  the message from the arduino should be like below.
  
  | count_R, count_L, updateRate, motorOffsetL, motorOffsetR \n |
*/

controlManager controls;

graph sensors;

numericUpDown updateRate;
numericUpDown motorOffsets;

int skip = 0; //Skip the first five messages from the Arduino

boolean dragged = false;
boolean released = false;
boolean pressed = false;

void setup(){
  //Set the size and rendering mode
  // 0:  1024 x 580
  // 2:  1024 x 768
  // 4:  1280 x 720
  // 6:  1280 x 1024 
  // 8:  1366 x 768
  // 10: 1920 x 1080
  setupScreen(0);
  
  // A graph showing the acc. values
  sensors = new graph(10, 10, ((width)-20), (height-120), -7900, 7900, "Encoders");     //Create a new graph
  sensors.labels[0] = "count_R";                                              //Sets the label for the values
  sensors.labels[1] = "count_L";
  sensors.update();                                                         //Shows the graph with the new settings
  
  updateRate = new numericUpDown(10, (height-100), (width/2)-20, 90, 1, "Update rate of GUI");       //Creats a new numericUpDoen
  updateRate.labels[0] = "updateRate";
  updateRate.inc[0] = 1;            
  updateRate.param_name[0] = 'u';                                           //Sets the parameter name for the value to be sent to the bot                    
  updateRate.update(); 
  
  motorOffsets = new numericUpDown((width/2), (height-100), (width/2)-10, 90, 2, "Motor offsets");
  motorOffsets.labels[0] = "motorOffsetL";
  motorOffsets.labels[1] = "motorOffsetR";
  motorOffsets.inc[0] = 0.002;
  motorOffsets.inc[1] = 0.002;
  motorOffsets.param_name[0] = 'l';
  motorOffsets.param_name[1] = 'r';
  motorOffsets.update();
  
  
  controls = new controlManager();          //Create a new Control manager
  controls.graphs.add(sensors);             //Add the graph sensors
  controls.numericUpDowns.add(updateRate);  //Add the numericUpDown updateRate
  controls.numericUpDowns.add(motorOffsets);//Add the numericUpDown motorOffsets
    
  setupSerial();  //Setting up the serial communication
}


void draw(){
  
}

void mouseDragged(){
  dragged = true;
  controls.MouseDragged();     //Send the mouseDragged event to the control manager
  dragged = false;
}

void mousePressed(){
  pressed = true;
  controls.MousePressed();
  pressed = false;
} 

void mouseReleased() {
  released = true;
  controls.MouseReleased();    //Send the mouseReleased event to the control manager
  released = false;
}



