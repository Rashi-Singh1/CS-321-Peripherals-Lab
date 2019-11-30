/*
 * 
 * All the resources for this project: https://www.hackster.io/Aritro
 * Modified by Aritro Mukherjee
 * 
 * 
 */
 
#include <SPI.h>
#include <MFRC522.h>

#include <Key.h>
#include <Keypad.h>
 
#define SS_PIN 43
#define RST_PIN 42
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.

const byte rows = 4; //four rows
const byte cols = 4; //four columns
const byte numSlots = 7;

char keys[rows][cols] = {
  {'1','2', '3','2'},
  {'4','5', '6','5'},
  {'7','8' ,'9','8'},
  {'*','0', '#','0'}
};
byte rowPins[rows] = {2, 3, 4, 5}; //connect to the row pinouts of the keypad
byte colPins[cols] = {6, 7,8, 9}; //connect to the column pinouts of the keypad
Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, rows, cols );

String slot[numSlots];
int i; 
void setup() 
{
  Serial.begin(9600);   // Initiate a serial communication
  SPI.begin();      // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522
  Serial.println("Approximate your card to the reader...");
  Serial.println();
  for(i=0 ; i<numSlots ; i+=1) slot[i] = "";
}
void loop() 
{
  // Look for new cards
  if ( ! mfrc522.PICC_IsNewCardPresent()) 
  {
    return;
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) 
  {
    return;
  }
  //Show UID on serial monitor
  Serial.print("UID tag :");
  String content= "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++) 
  {
     Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
     Serial.print(mfrc522.uid.uidByte[i], HEX);
     content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
     content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  Serial.println();
  Serial.print("Message : ");
  content.toUpperCase();
  int presentAt = checkifalreadyissued(content);
  if(presentAt == numSlots)
  {
    //check if any slot free;
    int freeslot = checkfreeSlot();
    if(freeslot == numSlots)
    {
      Serial.println("Sorry, no free slot");
    }
    else
    {
      //issue free slot
      Serial.println("You are alloted slot number:");
      Serial.println(freeslot+1);
      slot[freeslot] = content.substring(1);
    }
    
  }
  else
  {
    //print alloted slot
    Serial.println("You card UID :");
    Serial.println(content.substring(1));
    Serial.println("You are issued slot number :");
    Serial.println(presentAt+1);
    
    //ask if want to withdraw
    Serial.println("Press * to withdraw item, # to cancel");
    char key = getkeypadinput();
    while(key != '*' && key != '#')
    {
      Serial.println("Press * or # only");
      key = getkeypadinput();
    }
    if(key == '*')
    {
      //withdraw
      slot[presentAt] = "";
    }
  }
  delay(5000);
//  if (content.substring(1) == "A6 89 36 F9") //change here the UID of the card/cards that you want to give access
//  {
//    Serial.println("Authorized access");
//    Serial.println();
//    delay(3000);
//  }
// 
// else   {
//    Serial.println(" Access denied");
//    Serial.println();
//    delay(3000);
//  }
} 


int checkifalreadyissued(String content)
{
  for(i = 0; i < numSlots; i+=1)
  {
    if(content.substring(1) == slot[i])
      return i;
  }
  return numSlots;
}

char getkeypadinput()
{
  char key = keypad.getKey();
  delay(100);
  while(key == NO_KEY)
  {
    key = keypad.getKey();
    delay(100);
  }
  return key;
}

int checkfreeSlot()
{
  for(i = 0 ; i < numSlots; i+=1)
  {
    if(slot[i] == "")
      return i;
  }
  return numSlots;
}
