#include <ArduinoJson.h>

String message = "";
bool messageReady = false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  while(Serial.available()){
    message = Serial.readString();
    messageReady = true;
  }
    if(messageReady){
      DynamicJsonDocument doc(1024);
      DeserializationError error = deserializeJson(doc,message);

      if(error){
        Serial.println(F("deserializeJson() failed: "));
        Serial.println(error.c_str());
        messageReady = false;
        return;
      }
      if(doc["type"] == "request"){
        doc["type"] = "response";
        doc["distance"] = 300;
        doc["gas"] = 400;
        serializeJson(doc,Serial);
      }
      messageReady = false;
    }
}
