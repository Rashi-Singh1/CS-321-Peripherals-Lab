char recStr[10] = "";

void setup()
{
  Serial.begin(115200);
  Serial1.begin(115200);
}

void loop()
{
  byte n = Serial1.available();
  if (n != 0)
  {
    Serial1.readBytesUntil('>', recStr, 10);
    int x = atoi(recStr + 1);
    if (x == 12345)
    {
      char recStr[10] = "";      
      Serial.println("Received 1234 from Node; now sending - Arduino - to Node...!");
      Serial1.write("Arduino");
    }
  }
  delay(1000);
}
