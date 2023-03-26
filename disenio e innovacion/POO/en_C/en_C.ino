//ref: https://wokwi.com/projects/355703634162296833
//https://wokwi.com/projects/355738832629538817
#define LED_1_PIN 10
#define LED_2_PIN 9
#define LED_3_PIN 8
#define LED_4_PIN 7

#define BUTTON_PIN 5

class Motor {
  private:
    int type;
  public :
    Motor(int type) {
      this->type = type;
    }
};

class Servo: public Motor {
  public:
    int percentage;

    void setPercentage(int p) {
      percentage = p;
    }

    void move() {
      
      return 0;
    }
};


class Led {
  private:
    byte pin;
  public:
    Led(byte pin) {
      // El operador "->" se utiliza como una forma corta 
      // para de-referenciar un puntero.
      // En este caso sirve para distinguir entre el 'pin'
      // atributo de la clase y el 'pin' de la variable
      // local creada por el parámetro
      this->pin = pin;
      //(*this).pin = pin;
      //this.pin = pin;
      init();
    }

    void init() {
      pinMode(pin, OUTPUT);
      // Procuren evitar repetir código
      // En vez de llamar a digitalWrite(pin, LOW)
      // mejor llamar la función off()
      off();
    }

    void on() {
      digitalWrite(pin, HIGH);
    }

    void off() {
      digitalWrite(pin, LOW);
    }
};

class Button {
  private:
    byte pin;
    byte state;
    byte lastReading;
    unsigned long lastDebounceTime = 0;
    unsigned long debounceDelay = 50;

  public:
    Button(byte pin) {
      this->pin = pin;
      lastReading = LOW;
      init();
    }

    void init() {
      pinMode(pin, INPUT);
      update();
    }

    void update() {
      // De una vez implementar un anti-rebote en la clase 
      // para ya no tener que regresar a ver este código
      byte newReading = digitalRead(pin);
      
      if (newReading != lastReading) {
        lastDebounceTime = millis();
      }

      if (millis() - lastDebounceTime > debounceDelay) {
        state = newReading;
      }

      lastReading = newReading;
    }

    byte getState() {
      update();
      return state;
    }

    bool isPressed() {
      return (getState() == HIGH);
    }
};

// Instanciamos los objetos de forma global para tener acceso a ellos
// desde cualquier función (como setup y loop)

//nombreClase nombreObjetoNuevo(atributos)
Led led1(LED_1_PIN);
Led led2(LED_2_PIN);
Led led3(LED_3_PIN);
Led led4(LED_4_PIN);
Button button1(BUTTON_PIN);

void setup() {
  Serial.begin(115200);
  Serial.println("hello world");
 }

void loop() {
  if (button1.isPressed()) {
    led1.on();
    led2.off();
    led3.on();
    led4.off();
  }
  else {
    led1.off();
    led2.on();
    led3.off();
    led4.on();
  }
}
