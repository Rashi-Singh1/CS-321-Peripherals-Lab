//
//#include <dht.h>
//dht DHT;
//int temp,humi;
//#define DHT11_PIN A0
String str;
int value;
void setup(){
 Serial.begin(115200);
 Serial1.begin(115200);
 value=0;
 delay(2000);
}
void loop()
{
//  DHT.read11(DHT11_PIN);
//  humi=DHT.humidity;
//  temp=DHT.temperature;
  ++value;
  Serial.print("Value: ");
  Serial.print(value);
  str ="Value: "+String(value);
  Serial1.println(str);
  delay(3000);
}
