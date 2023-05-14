/*
  Author:   Cris_Pat
  Date:     26/04/2023   <-- Latam format
  Update:   26/04/2023

  Description:
  This code uses a TB6600 driver stepper to produce a continuous rotation. 
  For mor details: https://wiki.dfrobot.com/TB6600_Stepper_Motor_Driver_SKU__DRI0043
                   https://www.youtube.com/watch?v=PZbc-IgfDa8
                   http://electropro.pe/image/data/imgProductos/196.%20Driver%20de%20Motor%20Paso%20a%20Paso/HY-DIV268N-5A.pdf
*/

const int dirPin = 2;
const int stepPin = 3;

const int dirPin2 = 4;
const int stepPin2 = 5;

int stepDelay;
void setup() {
  // Declarar los pines como salida
  pinMode(dirPin, OUTPUT);
  pinMode(stepPin, OUTPUT);
  pinMode(dirPin2, OUTPUT);
  pinMode(stepPin2, OUTPUT);
}
void loop() {
  //Activar una dirección y fijar la velocidad con stepDelay
  digitalWrite(dirPin, HIGH);
  digitalWrite(dirPin2, HIGH);
  stepDelay = 3;
  // Giramos 200 pulsos para hacer una vuelta completa
  for (int x = 0; x < 200; x++) {
    digitalWrite(stepPin, HIGH);
    digitalWrite(stepPin2, HIGH);
    delay(stepDelay);
    digitalWrite(stepPin, LOW);
    digitalWrite(stepPin2, LOW);
    delay(stepDelay);
  }
  delay(1);
  /*
  delay(1000);
  //Cambiamos la dirección y aumentamos la velocidad
  digitalWrite(dirPin, LOW);
  stepDelay = 3;
  // Giramos 200 pulsos para hacer una vueltas completa
  for (int x = 0; x < 200; x++) {
    digitalWrite(stepPin, HIGH);
    delay(stepDelay);
    digitalWrite(stepPin, LOW);
    delay(stepDelay);
  }
  delay(1000);
  */
}
