	
void buttonPressed(RimokonEvent evt, int rid) {
   if (evt.wasPressed(RimokonEvent.TWO)) println("2");
   if (evt.wasPressed(RimokonEvent.ONE)) println("1");
   if (evt.wasPressed(RimokonEvent.B)){
    if (laser_on==false){myport.write('L'); laser_on=true;}
    else{myport.write('l'); laser_on=false;}
  }
   if (evt.wasPressed(RimokonEvent.A)){
    if (light_on==false){myport.write('F'); light_on=true;}
    else{myport.write('f'); light_on=false;}
  }
   if (evt.wasPressed(RimokonEvent.MINUS)){
    vel=vel-10;
    if (vel<0) {vel=0; wii.rimokon.vibrateFor(100);}
  }
   if (evt.wasPressed(RimokonEvent.HOME)){
    myport.write('c');
    anguloPan=90;
    anguloTilt=90;
    myport.write('l');
    myport.write('f');
    vel=20;
  }
   if (evt.wasPressed(RimokonEvent.LEFT)) {
    myport.write('I');
    enviaVel();
  } 
   if (evt.wasPressed(RimokonEvent.RIGHT)) {
    myport.write('D');
    enviaVel();
  } 
   if (evt.wasPressed(RimokonEvent.DOWN)){
    myport.write('R');
    enviaVel();
  }  
   if (evt.wasPressed(RimokonEvent.UP)) {
    myport.write('A');
    enviaVel();
  } 
   if (evt.wasPressed(RimokonEvent.PLUS)){
    vel=vel+10;
    if (vel>100) {vel=100; wii.rimokon.vibrateFor(100);}
  }
}


void buttonReleased(RimokonEvent evt, int rid) {
    myport.write('S');
}  


void nunchakuPressed(NunchakuEvent evt, int rid) {
  if (evt.wasPressed(evt.Z)) {
    nunchu=true;
  }
  if (evt.wasPressed(evt.C)) {
    //println("Z from #"+rid+" &"+evt.getStick());
  }
}


void nunchakuReleased(NunchakuEvent evt, int rid) {
  nunchu=false;
}   

void kurakonPressed(KurakonEvent evt, int rid) {
  if (evt.wasPressed(evt.A)) {
    vel=vel+10;
    if (vel>100) vel=100;
  }
  if (evt.wasPressed(evt.B)) {
    vel=vel-10;
    if (vel<0) vel=0;
  }
  if (evt.wasPressed(evt.DPAD_DOWN)) {
    myport.write('R');
    enviaVel();
  }  
  if (evt.wasPressed(evt.DPAD_UP)) {
    myport.write('A');
    enviaVel();
  }  
  if (evt.wasPressed(evt.DPAD_LEFT)) {
    myport.write('I');
    enviaVel();
  }  
  if (evt.wasPressed(evt.DPAD_RIGHT)) {
    myport.write('D');
    enviaVel();
  }      
  if (evt.wasPressed(evt.MINUS)){ 
    vel=vel-1;
    if (vel<0) vel=0;
  }  
  if (evt.wasPressed(evt.PLUS)){ 
    vel=vel+1;
    if (vel>100) vel=100;
  }
  if (evt.wasPressed(evt.HOME)){
    myport.write('c');
    anguloPan=90;
    anguloTilt=90;
    myport.write('l');
    myport.write('f');
    vel=20;
  }
  if (evt.wasPressed(evt.LEFT_TRIGGER)) {

  }
  
  if (evt.wasPressed(evt.RIGHT_TRIGGER)) {

  }
  if (evt.wasPressed(evt.LEFT_Z)) {
    if (laser_on==false){myport.write('L'); laser_on=true;}
    else{myport.write('l'); laser_on=false;}
  }
  if (evt.wasPressed(evt.RIGHT_Z)) {
    if (light_on==false){myport.write('F'); light_on=true;}
    else{myport.write('f'); light_on=false;}
  }
  if (evt.wasPressed(evt.X)) {
    vel=100;
  }
  if (evt.wasPressed(evt.Y)) {
    vel=1;
  }
}
void kurakonReleased(KurakonEvent evt, int rid) { 
    myport.write('S');
}  
