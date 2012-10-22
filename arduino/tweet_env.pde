// Serial out CdS(Light) and LM35DZ(Temperature)

#define LED_PIN 13
#define CDS_PIN 0
#define LM35_PIN 1
#define LM35_VOL 5 // 5V
boolean led_stat = false;

void setup(){
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
  digitalWrite(LED_PIN, led_stat);
}

void loop(){
  Serial.print("light:");
  Serial.println(get_light());
  led_blink();
  delay(2000);
  Serial.print("temp:");
  Serial.println(get_temp());
  led_blink();
  delay(2000);
}

void led_blink(){
  digitalWrite(LED_PIN, led_stat = !led_stat);
}

int get_light(){
  return analogRead(CDS_PIN);
}

double get_temp(){
  return (double)analogRead(LM35_PIN)*100*LM35_VOL/1024;
}
