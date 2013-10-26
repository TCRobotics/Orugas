void keyPressed(){
switch(key) {
  case '.': 
    vel++;
    if (vel>100) vel=100;
  break;
  case ',': 
    vel--;
    if (vel<0) vel=0;
  break;  
  case 'w': 
    myport.write('A');
    enviaVel();
  break; 
  case 's':
    myport.write('R');
    enviaVel();
  break; 
  case 'd':
    myport.write('D');
    enviaVel();   
  break; 
  case 'a': 
    myport.write('I');
    enviaVel();
   break; 
  case 'k':
    myport.write('P');
    if (anguloPan > 0) anguloPan -= 5;
  break; 
  case 'ñ':
    myport.write('p');
    if (anguloPan < 180) anguloPan += 5;
  break; 
  case 'o':
    myport.write('T');
    if (anguloTilt > 0) anguloTilt -= 5;
  break; 
  case 'l':
    myport.write('t');
    if (anguloTilt < 180) anguloTilt += 5;
  break; 
  case 'h':
    myport.write('H');
  break; 
  case '1':
    myport.write('L');
  break;
  case '2':
    myport.write('l');
  break;   
    case '3':
    myport.write('F');
  break; 
    case '4':
    myport.write('f');
  break; 
  case 'c':
    myport.write('c');
    anguloPan=90;
    anguloTilt=90;
  break; 
  default:
  myport.write('m');
  }  
 println("Se ha presionado: " + key); 

}

void keyReleased(){
    myport.write('S');  
}  
