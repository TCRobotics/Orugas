/**
 * AEnviaAcele01F    -  FILTRADO Para ARDUINO - 
 *  Es una variante del programa AEnviaGyro_04 en el que ahora "leeo" el ACELEROMETRO  ADXL330
 *  Voy a utilizar el MEGA
 *  OJO la version 17 de Arduino tiene un fallo con los Pines Analogicos 8 a 15 del MEGA
 * Utilizar la version 18
 * 
 * Envia  datos ACELEROMETRO a  Processing  
 *
 * Desarrollado por TUTO2002   -   tuto2002@gmail.com
 * Software de libre distribucion
 */
// Nota: 001 DEFINES  Ver http://sites.google.com/site/mikuadricoptero/home/6---notas-programacion/6-01-notas-001-a-xxxx
#define BAUD 38400     //    Puede ser 9600 - 14400 - 28800 - 38400
#define MUESTRASCALIBRARACELE  30   //Para calcular la MEDIA del CALIBRADO
#define NUMFILT 5      // Numero de elementos que vamos a filtrar

// Estoy utilizando el segundo grupo de Pines Analogicos MEGA
// Podeis cambiar  a 0 - 5 en DUEMIL
#define PINACELEX 11  // para conectar Eje X del Acelerometro
#define PINACELEY 12  // para conectar Eje Y del Acelerometro


char ordenEmpezar = 69 ; // ASCII - E, dec: 69, 
char orden ;  // La recibida del PC


int valorMedioAceleX = 0;
int valorMedioAceleY = 0;

int inclinaX;    // 

int inclinaY;    // 


// Para desglosar LONG's
//  En Processing los enteros negativos ocupan 4 Bytes <> un long en Arduino
union long_union {
  byte unionByte[4];
  long unionLong;
}  
resultado;

// Para FILTRAR 
int numfilt =  NUMFILT;      // Numero de elementos que vamos a filtrar
int anteriorX [NUMFILT];
int anteriorY [NUMFILT];


void setup() {
  Serial.begin(BAUD);  
  analogReference(EXTERNAL);

  // Para CALIBRAR pongalo horizontal y NO LO MUEVA
  // Calibramos Acelerometro
  valorMedioAceleX = calibrarAcele(PINACELEX);
  valorMedioAceleY = calibrarAcele(PINACELEY);



  while ( orden != ordenEmpezar){
    if (Serial.available() > 0) { // Esperamos a recibir 1 Byte con la ORDEN de EMPEZAR
      orden = Serial.read();
    }
    else {
      delay(50);
    }

  }


}
// Ahora podemos empezar a MOVERLO

void loop() {


  inclinaX = analogRead (PINACELEX)- valorMedioAceleX ;   // Son los angulos en "Valores Sensor"
  inclinaX  = filtradoX (inclinaX ) ;

  delay(5); // Para evitar erores de lectura Arduino consecutivas a Pines Contiguos

  inclinaY = analogRead (PINACELEY)- valorMedioAceleY ;   // Son las velocidades en valores Sensor
  inclinaY  = filtradoY (inclinaY ) ;


  //  En Processing los enteros negativos ocupan 4 Bytes <> un long en Arduino
  envioSerie (long(inclinaX));

  envioSerie (long(inclinaY));

  delay(26);    //  Para aproximarlo al ciclo de la Radio y ESC  y NO SATURARr Processing


}   
// ******************** Subrutinas  ****************/
// CALIBRAR
int calibrarAcele (int analogPin){
  for (int n = 0; n < 5 ; n++){  // Lecturas de calentamiento Estos valores se ignoran
    int leido=analogRead(analogPin);
    delay(10);
  }
  // Leemos el Acelerometro MUESTRASCALIBRARACELE veces  y calculanos el valor medio
  unsigned long valorAcumuladoGiro = 0; // Para Calcular en la Calibraci�n. 
  int valorMedio=0;  // 

  for (int i = 0; i < MUESTRASCALIBRARACELE; i++){
    //  Acumulamos las lecturas
    valorAcumuladoGiro = valorAcumuladoGiro+analogRead(analogPin);
    delay(5);   // 
  }  

  valorMedio= valorAcumuladoGiro / MUESTRASCALIBRARACELE;  // 
  return valorMedio;
}

void envioSerie(long dato){

  resultado.unionLong = dato ;



  // Ojo NO llevan separadores NI Retorno de carro  // No es legible 


  Serial.print(resultado.unionByte[3], BYTE);     // MSB  Byte Mas Significativo
  Serial.print(resultado.unionByte[2], BYTE);   
  Serial.print(resultado.unionByte[1], BYTE);   
  Serial.print(resultado.unionByte[0], BYTE);  

}

//   SUBRUTINA FILTRADO X - Moviendo los elementos
int filtradoX (int dato){

  int acumulaF = 0;   // Como son pocos elementos puedo utilizar ENTERO (  -32,768 to 32,767 )
  for (int n=0; n < (numfilt-1) ; n++){
    anteriorX [n] = anteriorX [n+1];
    acumulaF = acumulaF+ anteriorX[n];  // y al mismo tiempo los voy sumando
  }
  // añado el nuevo valor y lo sumo
  anteriorX [numfilt-1]=dato;

  acumulaF = acumulaF+ anteriorX[numfilt-1];

  int resultado = acumulaF/numfilt;

  return resultado;


}

int filtradoY (int dato){

  int acumulaF = 0;   // Como son pocos elementos puedo utilizar ENTERO (  -32,768 to 32,767 )
  for (int n=0; n < (numfilt-1) ; n++){
    anteriorY [n] = anteriorY [n+1];
    acumulaF = acumulaF+ anteriorY[n];  // y al mismo tiempo los voy sumando
  }
  // añado el nuevo valor y lo sumo
  anteriorY [numfilt-1]=dato;

  acumulaF = acumulaF+ anteriorY[numfilt-1];

  int resultado = acumulaF/numfilt;

  return resultado;



}






