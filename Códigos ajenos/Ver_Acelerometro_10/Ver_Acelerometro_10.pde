/**
 *  Ver Acelerometro-10   -  Para  PROCESSING - NO sirve para ARDUINO
 *  Es una variante del Ver Gyro-10 
 * Visualizar datos recibidos del ACELEROMETRO  ADXL330
 *  Combiene consultar el Programa VerHirizonte_01    
 * 
 *
 * Desarrollado por TUTO2002   -   tuto2002@gmail.com
 * Software de libre distribucion
 */

import processing.serial.*;
Serial miPuerta;  // 

PFont miTipoL;

float escalaVelo = 0.25; // Para escalar en Vumetros  los datos  calculados

float Kvelocidad = 0.055;  // Para derivarar Inclinacion > Velocidad    - Ver calculo con Velocidades



// al pasarlos a la subrutinA Horizonte los transformo en Enteros
int angX = 0 ;
int angY = 0;

int angXanterior = 0;
int angYanterior = 0;

// Factor Conversion - Grados a Radianes (2*PI/360) = 0,01745
float factorAngulo = 0.0174;  
// Para convertir el angulo recibido (-1500 a 150) en grados
float Kangulo = .45;
// Coordenadas para Horizonte Artificial
int XA;
int YA;
int XB;
int YB;

// Al Derivar los considero FLOAT , para no perder los valores de velocidades bajas
float velocidadX ;   //   Profundidad -  PITCH
float velocidadY ;   //   Alerones    -  TILT

int maximoVX = 0;  
int maximoVY = 0;
int minimoVX = 0;
int minimoVY = 0;

boolean primeravez = true;  // Dar tiempo a Arduino para  "despertarse" en Primer Ciclo

byte empezar= 0x45;  // ASCII - E, dec: 69,  hex 45 - Orden a Arduino de "Empezar" a enviar datos

long empiezaT;   //Para comprobar lo que tarda el ciclo

void setup() {
  size(1220, 700);

  // Lista toda las Puertas Serie Disponibles
  println(Serial.list());
  // En mi PC la puerta Serie es la COM4  por lo tanto abro la Serial.list()[1].
  // Si tienes dudas prueba con otras
  miPuerta = new Serial(this, Serial.list()[1], 38400);

  // El Tipo de Letra (font) debe estar en la carpeta "Data" dentro del Sketch
  // Se "genera" mediante TOOLS
  miTipoL = loadFont("Impact-48.vlw");

}

void draw() {

  if (primeravez){
    delay(2000);     //  Si no damos tiempoa Arduino para "despertarse" se pierden datos enviados

    miPuerta.write(empezar);  // Envio una E
    delay(10); 
    angXanterior = int(leeDatoSerie()* Kangulo) ; // 
    angYanterior =  int(leeDatoSerie() * Kangulo);
    primeravez = false;

  }
  //    Para DEPURAR  y Comprobar que no se acumulan datos en el Buffer sin leer
  ///  println (miPuerta.available());

  // Para comprobar lo que tarda el Ciclo
  ///  println ( millis() - empiezaT);  // Tarda unos 30 milisegundos
  ///   empiezaT = millis();  

  angX = int( leeDatoSerie()* Kangulo);  // 
  angY =  int( leeDatoSerie()* Kangulo);  // //// El SIGNO es Para Ajustar Sentido de Giro  


    // DERIVAMOS    Velocidad = (Angulo Actual - Angulo Anterior)/ Tiempo
  // Se supone que el tiempo entre lecturas es constante 
  // El coeficiente -Kvelocidad- (calculado a OJO) representa el Tiempo y el factor de conversion de lecturas a velocidad angular

  // Tarda unos 30 milisegundos en un ciclo   y 90º son aprox 150
  // por lo tanto una velocidad de 90º/sg   serian 150 / (1000/30)
  // y  90º/sg = 150/(1000/30)/ Kvelocidad
  //  Kvelocidad = 0,05

  velocidadX = (angX - angXanterior)/ Kvelocidad ;  
  velocidadY = (angY - angYanterior)/ Kvelocidad ;  


  if (velocidadX > maximoVX){
    maximoVX = int(velocidadX);
  }
  if (velocidadY > maximoVY){
    maximoVY = int(velocidadY);
  }
  if (velocidadX < minimoVX){
    minimoVX = int(velocidadX);
  }
  if (velocidadY < minimoVY){
    minimoVY = int(velocidadY);
  }

  background (204);
  textFont(miTipoL, 30);
  textAlign (CENTER);
  fill(0);
  text ( " Visualizar ACELEROMETRO  ADXL330 " , width/2 , 40);

  text( " Eje X - Profundidad - PITCH", 200, 85);
  text( " Eje Y - Alerones - TILT", 1000, 85);

  textFont(miTipoL, 20);
  fill(80);       // GRIS
  text ( "Angulo X           º          Angulo Y         º " ,600 , 650); //  y Borra los datos anteriores
  text( " Min:           Velocidad             Max:", 200, 650);
  text( " Min:           Velocidad             Max:", 1000, 650);


  fill(159,0,0);                 // Rojo
  text ( minimoVX, 125  ,650 );
  text ( minimoVY, 925 ,650 );

  fill(0);                   // Negro
  text ( angX ,550 , 650); 
  text ( angY ,730 , 650); 
  text (int(velocidadX) , 280 , 650);  // 
  text (int(velocidadY) ,  1080, 650); 

  fill(0,0,159);                 // Azul
  text ( maximoVX, 380 ,650 );
  text ( maximoVY, 1180 ,650 );

  // Para NO Salirme
  angX = constrain (angX,  -44, 44);
  angY  = constrain (angY, - 85, 85);

  // envio datos a la subrutina 
  horizonte (angX ,angY );

  // Vumetros

  rectMode(CORNERS);
  stroke(0);
  strokeWeight(2);
  fill(255);                 // Blanco

  rect(160, 150, 240,550);
  rect(960, 150, 1040,550);

  // Divisiones
  line (160,350,240,350);  // 
  line (960,350,1040,350);  // 

  noStroke();
  if (velocidadX > 0){
    fill (0,0,159);                 // Azul
  }
  else{
    fill (159,0,0);                 // Rojo
  }

  rect(160, 350- velocidadX*escalaVelo, 240,350);   


  if (velocidadY > 0){
    fill (0,0,159);                 // Azul
  }
  else{
    fill (159,0,0);                 // Rojo
  }

  rect(960, 350- velocidadY*escalaVelo, 1040,350);


  // Maximos 
  stroke (0,0,159);                 // Azul

  line (242, 350- maximoVX*escalaVelo, 252, 350-maximoVX*escalaVelo);
  line (1042, 350- maximoVY*escalaVelo, 1052, 350-maximoVY*escalaVelo);
  //  Minimos
  stroke(159,0,0);                 // Rojo
  line (242, 350- minimoVX*escalaVelo, 252, 350-minimoVX*escalaVelo);
  line (1042, 350 - minimoVY*escalaVelo, 1052, 350-minimoVY*escalaVelo);

  // Dejo los valores como anteriores
  angXanterior = angX;
  angYanterior = angY;



}

/////      SUBRUTINAS

void horizonte (int anguloX, int anguloY){

  rectMode(CORNERS);
  stroke(0);
  strokeWeight(1);
  fill(51,204,204);                 // Azul Claro

  rect(400, 150, 800,550);

  int cotaY = int(200*tan(anguloY *factorAngulo));
  int cotaX = int(200*tan(anguloX *factorAngulo));



  YA= 350-cotaX+cotaY;
  YB= 350-cotaX-cotaY;


  // Inclinaciones NORMALES ( Sin salir bandas laterales)
  if (YA >= 150 & YA <550) {
    XA = 400;
  }

  if (YB >= 150 & YB <550) {
    XB = 800;
  }

  // Para evitar DISION por CERO
  if (cotaY==0){
    cotaY=1;
  }
  // Si se salen por arriba o abajo
  if (YA > 550) {
    XA = 600 - 200*(200-abs(cotaX))/cotaY;
    YA = 550;
    /////////// println( "Excep 1 ");
  }

  if (YA < 150) {
    XA = 600 - 200*(200-cotaX)/abs(cotaY);
    YA = 150;
    ///////////////  println( "Excep 2 ");
  }
  if (YB > 550) {
    XB = 600 + 200*(200 +cotaX)/abs(cotaY);
    YB = 550;
    /////////// println( "Excep 3 ");
  }

  if (YB < 150) {
    XB = 600 + 200*(200-cotaX)/abs(cotaY);
    YB = 150;
    ///////////  println( "Excep 4 ");
  }

  strokeWeight(2);
  fill( 153,51,0);
  beginShape();
  vertex(XA, YA);
  if (YA==150){
    vertex(400-1,150-1);
  }
  vertex(400-1,550+1);
  vertex(800+1,550+1);
  if (YB==150){
    vertex(800+1,150-1);
  }
  vertex(XB,YB);

  endShape(CLOSE);
  stroke(152,0,0);
  strokeWeight(1);


  // EJES
  line (400,350,800,350);  // Eje Horizontal 
  line (600,150,600,550);  // Eje Vertical
  // Marcas Inclinacion en Profundidad
  int anguloMarca = 40;
  textFont(miTipoL, 12);
  textAlign(LEFT);
  fill(204,255,0);

  for (int n =0 ; n <4; n++){

    int marcaX = int(200*tan((anguloMarca-n*10) *factorAngulo));
    line (601,350 - marcaX, 610, 350- marcaX);   // Superiores
    line (601,350 + marcaX , 610, 350+ marcaX);   // Inferiores = Angulos X Negativos
    text ( (anguloMarca-n*10), 620, 350+6- marcaX); 
    text ( -(anguloMarca-n*10), 620, 350+6+ marcaX); 
  }

  strokeWeight(4);
  noFill ();  
  ellipse ( 600,350, 392,392); // Contorno


  // RECORTAR Sobrantes
  stroke(204);    // Color del Fondo
  strokeWeight(10);
  ellipseMode(CENTER);

  for  (int i=1;  i < 170; i=i+10){
    ellipse ( 600,350, 403+i,403+i);
  }


}

int leeDatoSerie(){                      //////   LEER DATOS SERIE

  while (miPuerta.available()<4) {  // Espero a tener en el Buffer de entrada al menos CUATRO BYTES
  }             
  //
  int primero = miPuerta.read();   // Byte Izquierda
  int segundo =  miPuerta.read();
  int tercero =  miPuerta.read();
  int cuarto =  miPuerta.read();

  int enteroRecibido  = ((primero & 0xff) << 24 | (segundo & 0xff)<< 16  |(tercero & 0xff)<< 8 | (cuarto &0xff));
  return (enteroRecibido);

}  // Final  Subrutina LEEDATOS SERIE

























