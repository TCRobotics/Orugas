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

// Factor Conversion - Grados a Radianes (2*PI/360) = 0,01745
float factorAngulo = 0.0174;
// Coordenadas para Horizonte Artificial
int XA;
int YA;
int XB;
int YB;

void horizonte (int x, int y, int anguloX, int anguloY){
  pushMatrix();   
  translate(x-200,y-70); 
  scale(0.5);
  rectMode(CORNERS);
  stroke(0);
  strokeWeight(1);
//  fill(51,204,204);                 // Azul Claro
    fill(108, 156, 255);  
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
  fill(208, 119, 0);
  //fill( 153,51,0);
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
  stroke(0,0,0);
  strokeWeight(1);


  // EJES
  line (400,350,800,350);  // Eje Horizontal 
  line (600,150,600,550);  // Eje Vertical
  // Marcas Inclinacion en Profundidad
  int anguloMarca = 40;

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
  stroke(0);    // Color del Fondo
  strokeWeight(10);
  ellipseMode(CENTER);

  for  (int i=1;  i < 170; i=i+10){
    ellipse ( 600,350, 403+i,403+i);
  }

    popMatrix();
}



