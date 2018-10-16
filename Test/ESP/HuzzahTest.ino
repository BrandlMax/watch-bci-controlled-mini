void setup() {
  pinMode(0, OUTPUT);
  Serial.begin(115200);
  Serial.println("Started");
}
 
void loop() {
  digitalWrite(0, HIGH);
  delay(1000);
  Serial.println("Ping");
  digitalWrite(0, LOW);
  delay(1000);
  Serial.println("Pong");
}
