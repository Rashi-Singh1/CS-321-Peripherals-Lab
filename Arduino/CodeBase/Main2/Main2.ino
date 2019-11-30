#include <Stepper.h>
#include <Servo.h> 
#include <Key.h>
#include <Keypad.h>
//RFID libraries
#include <SPI.h>
#include <MFRC522.h>


//RFID pins
#define SS_PIN 43
#define RST_PIN 42
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.

const byte rows = 4; //four rows
const byte cols = 4; //four columns
const byte numSlots = 8;

// Declare the Servo pin 
int servoPin = 53; 
int outerServoPin = 10;
int lockpin = 11;

//buzzer pin
const int buzzerpin = 12;

// Create a servo object 
Servo Servo1; 
Servo OuterDoor;
Servo lock;

//slot object
String slot[numSlots];
int i;


// defines pins numbers
const int trigPin = 33;
const int echoPin = 32;


const int trigPin2 = 30;
const int echoPin2 = 31;

// defines variables
long duration;
int distance;

long duration2;
int distance2;

char keys[rows][cols] = {
  {'1','2', '3','2'},
  {'4','5', '6','5'},
  {'7','8' ,'9','8'},
  {'*','0', '#','0'}
};
byte rowPins[rows] = {2, 3, 4, 5}; //connect to the row pinouts of the keypad
byte colPins[cols] = {6, 7,8, 9}; //connect to the column pinouts of the keypad
Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, rows, cols );

const int stepsPerRevolution = 128;  // change this to fit the number of steps per revolution
// for your myStepper

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 22, 24, 23, 25);

char keyIn;
int startPos;
int pos;

void setup() {
pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
pinMode(echoPin, INPUT); // Sets the echoPin as an Input


pinMode(trigPin2, OUTPUT); // Sets the trigPin as an Output
pinMode(echoPin2, INPUT); // Sets the echoPin as an Input
pinMode(buzzerpin, OUTPUT);

  //setup rfid
  SPI.begin();      // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522
  for(i=0 ; i<numSlots ; i+=1) slot[i] = "";
  
  // set the speed at 60 rpm:
  myStepper.setSpeed(60);

  startPos = 5; //hardcode start pos. To be solved later (using rotary encoder)
  Servo1.attach(servoPin);  // We need to attach the servo to the used pin number
  OuterDoor.attach(outerServoPin);
  lock.attach(lockpin);
  //Servo1.write(140);
  
  // initialize the serial port:
  Serial.begin(9600);

  lock.write(30);
  
  //myStepper.step(200);
  setStart();
}

void loop() {
  int a = cal1();
  Serial.println("ping1 : ");
  Serial.println(a);

  delay(1000);
  
  int b = cal2();
  Serial.println("ping2 : ");
  Serial.println(b);
  
  delay(1000);

  Serial.println("Please scan your card");
  Serial.println();

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

  String content = getUID();
  String welcomeMessage = "Hi, " + content.substring(1);
  Serial.println(welcomeMessage);
  int presentAt = checkifalreadyissued(content);
  if(presentAt != numSlots)
  {
    if(presentAt%2==0)
    {
      //key issued against card
      //ask if wants to return key
      issuedKeyProcudure(presentAt);
      Serial.println();
    }
  
    else
    {
      //slot issued against card      
      //ask if want to retrieve deposited items
      issuedSlotProcedure(presentAt);
      Serial.println();
    }
  }

  else
  {
    //nothing issued against card
    //ask if wants to issue key or deposit item
    Serial.println("Press '*' to issue key or '#' to deposit items");
    Serial.println("Press any other key to cancel");
    Serial.println(); 

    char key = getkeypadinput();
  
    if(key == '*')
    {
      //ask for key number
      Serial.println("Enter key number [1-4]");
      char keyNum = getkeypadinput();
      while((int)keyNum<'1' || (int)keyNum>'4')
      {
        Serial.println();
        Serial.println("Error! Enter key number between 1 and 4 (intclusive)");
        keyNum = getkeypadinput();
      }
  
        //check if key already alloted
        //else bring in correct key and assign slot to UID
        int presentAt = ((int)(keyNum-'0'))*2 - 2;
        
        if(slot[presentAt] != "")
        {
          String errormessage = "Key is already assigned to " + slot[presentAt];
          Serial.println(errormessage);
          Serial.println();
        }
        else
        {
          Serial.println("You have requested key : ");
          Serial.println(keyNum);
          Serial.println("present at slot : ");
          Serial.println(presentAt +1);
          slot[presentAt] = content.substring(1);
          char key = presentAt +1+'0';
          movetoslot(key);
        }
    }
  }
//    if(key == '#')
//    {
//      int freeslot = checkfreeSlot();
//      if(freeslot == numSlots)
//      {
//        Serial.println("Sorry, no free slot");
//      }
//       else
//      {
//        //issue free slot
//        Serial.println("You are alloted slot number:");
//        int slotNum = freeslot+1/2;
//        Serial.println(freeslot + 1);
//        Serial.println();
//        slot[freeslot] = content.substring(1);
//        //add code to move stepper and servos
//        char key = '1' + freeslot;
//        //bring out correct slot
//        movetoslot(key);
//      }
//    }
//  }
//  delay(1000);
  
}

int cal1()
{
  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  
  // Calculating the distance
  distance= duration*0.034/2;

  Serial.println("distance : ");
  Serial.println(distance);
  return distance;
}

int cal2()
{
  // Clears the trigPin
  digitalWrite(trigPin2, LOW);
  delayMicroseconds(2);
  
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);
  
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration2 = pulseIn(echoPin2, HIGH);
  
  // Calculating the distance
  distance2= duration2 * 0.034 / 2;
  
  Serial.println("distance2 : ");
  Serial.println(distance2);
  return distance2;
}


void setStart()
{
  int dist;
  closeOuterDoor();
  moveInnerdoorUp();
  dist = cal1();
  Serial.println("setStart dis : ");
  Serial.println(dist);
  delay(500);
  Serial.println("Going in setStart");




  int a = cal1();
  Serial.println("ping1 : ");
  Serial.println(a);

  delay(1000);
  
  int b = cal2();
  Serial.println("ping2 : ");
  Serial.println(b);
  
  delay(1000);

  
  while(dist>6)
  {
    Serial.println("should be moving rn");
    myStepper.step(256);

    int a = cal1();
    Serial.println("ping1 : ");
    Serial.println(a);
  
    delay(1000);
    
    int b = cal2();
    Serial.println("ping2 : ");
    Serial.println(b);
    
    delay(1000);
  
    dist = cal1();
    delay(500);
  }
  moveInnerdoorDown();
  
}

void movetoslot(char key)
{
      moveInnerdoorUp();
      delay(500);
      rotateStepper(key);
      delay(500);
      moveInnerdoorDown();
      lockOpen();
      delay(500);
      openOuterDoor();
      Serial.println("Outer door open");
      delay(1000);
      Serial.println("start waiting");
      //checkhand();
      Serial.println(" waiting over");
      //delay(5000);
      delay(500);
      closeOuterDoor();
      delay(500);
      lockClose();
      Serial.println("Outer door closed");
}

String getUID()
{
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

  content.toUpperCase();
  return content;
}

void lockOpen()
{
  lock.write(120);
}

void lockClose()
{
  lock.write(30);
}

void moveInnerdoorUp()
{
   for(pos = 140; pos<=240;pos +=1)
   {
      Servo1.write(pos);
      delay(7);
   }
   delay(1000); 
}

void moveInnerdoorDown()
{
  for(pos = 240; pos>=140;pos -=1)
   {
      Servo1.write(pos);
      delay(7);
   }
   delay(1000);
}

void closeOuterDoor()
{
  OuterDoor.write(0);
}

void openOuterDoor()
{
  OuterDoor.write(90);
}


//bool checkhand()
//{
//  int dist1, dist2, dist3;
//  dist1 = cal2();
//  Serial.println(dist1);
//  delay(1000);
//  dist2 = cal2();
//  delay(1000);
//  dist3 = cal2();
//  delay(1000);
//  while(dist1<100)
//  {
//    Serial.println("dist1");
//    Serial.println(dist1);
//    
//    Serial.println("dist2");
//    Serial.println(dist2);
//    
//    Serial.println("dist3");
//    Serial.println(dist3);
//    dist1=dist2;
//    dist2=dist3;
//    dist3 = cal2();
//    dist1 = cal2();
//    delay(1000);
//  }
//}

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
  if(startPos % 2 == 1)
  {
    int cur = startPos - 1;
    for(int i = 1 ;i <= 3;i+=2)
    {
      if(slot[(cur + i + 8 )% 8] == "")
      {
        return (cur + i + 8 )% 8;
      }
      if(slot[(cur - i + 8 )% 8] == "")
      {
        return (cur - i + 8 )% 8;
      }
    }
  }
  else{
    int cur = startPos - 1;
    for(int i = 0 ;i <= 2;i++)
    {
      if(slot[(cur + 2*i + 8 )% 8] == "")
      {
        return (cur + 2*i + 8 )% 8;
      }
      if(i!=0 && slot[(cur - 2*i + 8 )% 8] == "")
      {
        return (cur - 2*i + 8 )% 8;
      }
    }
  }
}


void issuedKeyProcudure(int presentAt)
{
    char keyNumber = (presentAt)/2 + 1 + '0';
    String message = String("Key number ") + String(keyNumber) + String(" was issued to you, present at slot number : ");
    char slotnumber = presentAt + 1 + '0';  
    Serial.println(message);
    Serial.println(slotnumber);
    Serial.println("If you wish to return key press *, else press any other key..");
    char key = getkeypadinput();
     if(key == '*')
    {
    //bring appropriate slot
      slot[presentAt] = "";
      char key = presentAt +1 +'0';
      movetoslot(key);
    }
}

void issuedSlotProcedure(int presentAt)
{
    int slotNumber = presentAt/2;
      String message = "Your items are deposited in slot " + presentAt + 1;
      Serial.println(message);
      Serial.println("If you wish to retrieve items press *, else press any other key..");
      char key = getkeypadinput();
       if(key == '*')
      {
      //bring appropriate slot
      slot[presentAt] = "";
      char key = presentAt +1+'0';
      movetoslot(key);
      }
}

void buzzerOn()
{
   digitalWrite(buzzerpin, HIGH);
  delay(1000);
  digitalWrite(buzzerpin, LOW);
  delay(1000);
}
void buzzerOff()
{
  digitalWrite(buzzerpin, LOW);
  delay(10);
}

void rotateStepper(char key)
{
  if (key != NO_KEY){
    Serial.println("startPos is ");
    Serial.println(startPos);
    int nextPos = (int)(key - '0');
    Serial.println("nextPos is ");
    Serial.println(nextPos);
    int stepsNeeded = (nextPos - startPos + 8)%8;
    
    Serial.println("StepsNeeded is ");
    Serial.println(stepsNeeded);
    if(stepsNeeded <=4 ) {
      myStepper.step(128*(stepsNeeded));
      myStepper.step(128*(stepsNeeded));
    }
    else{
      myStepper.step(128*(stepsNeeded-8)); 
      myStepper.step(128*(stepsNeeded-8));
      Serial.println("Actual StepsNeeded is ");
      Serial.println(stepsNeeded-8);
    }
    startPos = nextPos;
  }
}
