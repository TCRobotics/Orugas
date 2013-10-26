//import processing.video.*;
//Capture cam;

//wiimote
import lll.wrj4P5.*;
import lll.Loc.*;
Wrj4P5 wii;
//

float anguloPan = 90;
float anguloTilt = 90;

float anguloX=90;
float anguloY=90;

float wii_x_angle;                                          //Wiimote X angle (Units are in percent realtive to mg)
float wii_y_angle;                                          //Wiimote Y angle (Units are in percent realtive to mg)

float distancia=0;
float luminosidad=0;
float temperatura=0;
String inString;
int vel=20;
Loc stick;
int stickx=90;
int sticky=90;


int x = 0;
int Y = 0;
int z = 0;

int i =0;

boolean rejilla = false;
boolean pressed = false;
boolean laser_on=false;
boolean light_on=false;
boolean nunchu = false;
PFont font;
int espaciado = 50;

Button BotonAvance;
Button BotonRetroceso;
Button BotonIzquierda;
Button BotonDerecha;
Button BotonPanDerecha;
Button BotonPanIzquierda;
Button BotonTiltArriba;
Button BotonTiltAbajo;

int skip = 0; //Skip the first five messages from the Arduino

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(650,700); //tamaño ventana
  //Wiimote
  wii=new Wrj4P5(this);
  wii.connect();
  //
  setupSerial();
  myport.write('H');
  textFont(loadFont("AgencyFB-Reg-24.vlw"), 22);
  
  BotonAvance = new Button(180, 525, 50, color(50), color(100), color(150));
  BotonRetroceso = new Button(180, 625, 50, color(50), color(100), color(150));
  BotonIzquierda = new Button(130, 575, 50, color(50), color(100), color(150));
  BotonDerecha = new Button(230, 575, 50, color(50), color(100), color(150));
  
  BotonPanDerecha = new Button(380, 575, 50, color(50), color(100), color(150));
  BotonPanIzquierda = new Button(480, 575, 50, color(50), color(100), color(150));
  BotonTiltArriba = new Button(430, 525, 50, color(50), color(100), color(150));
  BotonTiltAbajo = new Button(430, 625, 50, color(50), color(100), color(150));
  
  frameRate(10);

  //Camara///////////////////////////////////////////////////////////////////////
  //String[] devices = Capture.list();
  //println(devices);
  // Change devices[0] to the proper index for your camera.
  //cam = new Capture(this, width, height);
  //cam = new Capture(this, 640, 480, devices[5]);
  // Opens the settings page for this capture device.
  //cam.settings();
  //////////////////////////////////////////////////////////////////////////////
  myport.write('c');
  smooth();//Mejora el dibujo
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  background(0);
  
  //if (cam.available() == true) {
    //cam.read();
    //image(cam, 5, 5);
    //pushMatrix();
    //translate(cam.width, 0);
    //scale(-1, 1);
    
    //popMatrix();
  //}
  
  panTilt(350, 200, int(anguloPan), int(anguloTilt));  
  horizonte (50,0,int(anguloX), int(anguloY));
  //mouse();

  text("Dato recibido:", 50, 450);
  text("Estado:", 50, 470);
  if (inString != null){
    text(inString, 200, 450);

    text("Orugas Conectado", 200, 470);
    
    inString = null;}
     
  stroke(200);   
  text("Pitch:", 50, 250);
  text("Roll:", 175, 250);
  text(int(anguloY), 110, 250);
  text(int(anguloX), 225, 250);
  text("º", 150, 250);
  text("º", 260, 250);  
  
  text("Distancia:", 350, 250);
  text(int(distancia), 445, 250);
  text("cm", 470, 250);
  
  text("Luminosidad:", 350, 320);
  text("Temperatura:", 350, 340);
  
  text("Velocidad:", 350, 360);
  text(vel, 480, 360);
  text("%", 500, 360);
  
  text("W", 198, 560);
  text("S", 200, 660);
  text("A", 150, 610);
  text("D", 251, 610);
  
  text("O", 450, 560);
  text("L", 450, 660);
  text("K", 400, 610);
  text("Ñ", 500, 610);

  text(int(luminosidad), 480, 320);
  text(int(temperatura), 480, 340);
  

  text("%", 500, 320);
  text("ºC", 500, 340);
  
  /*
  float anglex =(180-(-(atan2(wii.rimokon.sensed.y , wii.rimokon.sensed.x ) * 180 / PI)));
  float angley = 180-(atan2(wii.rimokon.sensed.z , wii.rimokon.sensed.y ) * 180 / PI);
  if (anglex<0)anglex=0;
  if(anglex>180)anglex=180;
  if (angley<0)angley=0;
  if(angley>180)angley=180;      
  text(str(int(anglex)), 100, 300);
  text(str(int(angley)), 100, 330);
  */    
      
 
  // Rejilla para situar controles/////////////
  if (rejilla) {
    for (int i=0; i<width; i+=espaciado) {
      for (int j=0; j<height; j+=espaciado) {
        fill(255, 100);
        text(i+"  "+j, i, j);
        stroke(255, 25);
        noFill();
        rect(i, j, espaciado, espaciado);
      }
    }
  }
  ////////////////////////////////////////////
  
  
  stroke(255);
  
  BotonAvance.update();
  BotonAvance.display();
  
  BotonRetroceso.update();
  BotonRetroceso.display();
  
  BotonIzquierda.update();
  BotonIzquierda.display();
  
  BotonDerecha.update();
  BotonDerecha.display();

  BotonPanDerecha.update();
  BotonPanDerecha.display();
  
  BotonPanIzquierda.update();
  BotonPanIzquierda.display();
  
  BotonTiltArriba.update();
  BotonTiltArriba.display();
  
  BotonTiltAbajo.update();
  BotonTiltAbajo.display();

  if (BotonAvance.pressed == true) {
    myport.write('A');
    if (vel<10) myport.write('0');
    myport.write(str(vel));
  } 
  
  else if (BotonRetroceso.pressed == true) {
    myport.write('R');
    if (vel<10) myport.write('0');
    myport.write(str(vel));
  } 
  
  else if (BotonIzquierda.pressed == true) {
    myport.write('I');
    if (vel<10) myport.write('0');
    myport.write(str(vel));
  } 
  
  else if (BotonDerecha.pressed == true) {
    myport.write('D');
    if (vel<10) myport.write('0');
    myport.write(str(vel));
  } 
  
  else if (BotonPanDerecha.pressed == true) {
    myport.write('P');
    if (anguloPan > 0) anguloPan -= 5;
  } 
  
  else if (BotonPanIzquierda.pressed == true) {
    myport.write('p');
    if (anguloPan < 180) anguloPan += 5;
  } 
  
  else if (BotonTiltArriba.pressed == true) {
    myport.write('T');
    if (anguloTilt > 0) anguloTilt -= 5;
  } 
  else if (BotonTiltAbajo.pressed == true) {
    myport.write('t');
    if (anguloTilt < 180) anguloTilt += 5;
  } 
  
  else {   
    //if(anglex<10){myport.write("x00"); myport.write(str(anglex)); }
    //if(anglex>9 & anglex<100){myport.write("x0"); myport.write(str(anglex));}
    //if(anglex>99 & anglex<181){myport.write("x"); myport.write(str(anglex));}
    if(nunchu==true){
      i++;
      if(i>2){
        i=0;
        stick=wii.rimokon.nunchaku.stick;
        stickx=int(map((stick.x*1000),-1100,1100,180,0));
        if(stickx>=0 & stickx<10){myport.write('x');myport.write("00"); myport.write(str(stickx)); }
        if(stickx>9 & stickx<100){myport.write('x');myport.write("0"); myport.write(str(stickx));}
        if(stickx>99 & stickx<181){myport.write('x'); myport.write(str(stickx));}
        sticky=int(map((stick.y*1000),-1100,1000,170,0));
        if(sticky>=0 & sticky<10){myport.write('y');myport.write("00"); myport.write(str(sticky)); }
        if(sticky>9 & sticky<100){myport.write('y');myport.write("0"); myport.write(str(sticky));}
        if(sticky>99 & sticky<181){myport.write('y'); myport.write(str(sticky));}
        //println("Z from #"+rid+" &"+evt.getStick()+stickx);  
      }
    }
    myport.write('m');

   
  }

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int leeSerie(int posiciones){
  delay(250);
  int in = 0;
  int bytein=0;
  if(myport.available() > 0){
    print("Recibido:");
    for (int i=0;i<posiciones;i++){
      in*=10;
      bytein=myport.readChar();
      print(char(bytein));
      in +=bytein- '0';
    }
    myport.clear();
    println(".");
  }
  else{
  println("EL ROBOT NO RESPONDE!!");
  myport.clear();
  }
  return in;
} 

