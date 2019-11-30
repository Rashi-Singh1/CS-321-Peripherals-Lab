/*
  Take two inputs from analog pins
*/

void setup() {
  pinMode(2, OUTPUT);
  pinMode(LED_BUILTIN,OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // read the input on analog pin 0:
  int value1 = analogRead(A0);
  int value2 = analogRead(A5);
  int sum = value1+value2;
  
  analogWrite(2, map(sum, 0, 1023, 0, 255));
  analogWrite(LED_BUILTIN, map(sum, 0, 1023, 0, 255));
  
  // print out the value you read:
  Serial.println((float)sum*(5.0/1023.0));;
  
  delay(200);        // delay in between reads for stability
}
