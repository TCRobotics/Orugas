/*

 
float bx=322;
float by=242;
int bs = 20;
boolean bover = false;
boolean locked = false;
float bdifx = 0.0; 
float bdify = 0.0; 

void mouse() 
{ 

  // Test if the cursor is over the box 
  if (mouseX > bx-bs && mouseX < bx+bs && 
      mouseY > by-bs && mouseY < by+bs) {
    bover = true;  
    if(!locked) { 
      stroke(200); 
      fill(200);
    } 
  } else {
    stroke(100);
    fill(100);
    bover = false;
  }
  
  // Draw the box
  ellipse(bx, by, bs, bs);
}*/

void mousePressed() {
  pressed = true;
  BotonAvance.press();
  BotonRetroceso.press();
  BotonIzquierda.press();
  BotonDerecha.press();
  BotonPanDerecha.press();
  BotonPanIzquierda.press();
  BotonTiltArriba.press();
  BotonTiltAbajo.press();
/*    if(bover) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }
  bdifx = mouseX-bx; 
  bdify = mouseY-by; */
}

void mouseDragged() {
/*if (mouseX > 0 && mouseX < 645 && 
      mouseY > 0 && mouseY < 485) {
  if(locked) {
    bx = mouseX-bdifx; 
    by = mouseY-bdify;
    anguloPan=map(bx,0,645,0,180); 
    anguloTilt=map(by,0,645,0,180);
  }
 }*/
}

void mouseReleased() {
  BotonAvance.release();
  BotonRetroceso.release();
  BotonIzquierda.release();
  BotonDerecha.release();
  BotonPanDerecha.release();
  BotonPanIzquierda.release();
  BotonTiltArriba.release();
  BotonTiltAbajo.release();
  pressed = false;
  myport.write('S'); 
/*  locked = false;
      myport.write('P');
    delay(100);
    if(anguloPan>99) {myport.write('0');}
    myport.write(int(anguloPan)); */
}
