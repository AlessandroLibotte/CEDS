#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <EEPROM.h>

//Setup mode functions and variables initialization

bool _SETUP;

const char *APssid = "CEDS-CORE";
const char *APpassword = "5432167890";

const char* NET_SSID = "SSID";
const char* NET_PASS = "PASS";
const char* DEV_NAME = "NAME";

const char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html><head>
  <title>CEDS-Core Setup</title>
  <meta name="CEDS-Core Setup" content="width=device-width, initial-scale=1">
  </head><body>
  <h1>CEDS-Core Setup</h1>
  <form action="/get">
    Local Network SSID: <input type="text" name="SSID">
    <br>
    Local Network Password: <input type="text" name="PASS">
    <br>
    Device name on the Local Network: <input type="text" name="NAME">
    <br>
    <input type="submit" value="Submit">
  </form>
</body></html>)rawliteral";

void handleRoot(AsyncWebServerRequest *request) {
  request->send(200, "text/html", index_html);
}

void notFound(AsyncWebServerRequest *request) {
  request->send(404, "text/plain", "Not found");
}

int eeprom_write(String var, int eeADDR) {
  
  for( int i = 0; i < var.length(); i++)
    EEPROM.write(eeADDR + i, var[i]);
  eeADDR += var.length();
  EEPROM.write(eeADDR, '/');
  eeADDR ++;

  return eeADDR;

}

void setup_mode() {

  AsyncWebServer  APserver(80);

  Serial.println("Entering setup mode");
  Serial.println();
  Serial.print("Configuring access point... ");
  
  WiFi.softAP(APssid);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);

  APserver.on("/", HTTP_GET, handleRoot);

  APserver.on("/get", HTTP_GET, [] (AsyncWebServerRequest *request) {

    String values[3];
    //String inputParam;

    int params = request->params();
    for(int i=0;i<params;i++){
      AsyncWebParameter* p = request->getParam(i);
      Serial.println(p->value());
      values[i] = p->value();
    }

    Serial.println("Recived Network information:");

    Serial.println("SSID: " + values[0] + " Password: " + values[1] + " CORE name on the network: " + values[2]);
    request->send(200, "text/html", "The CEDS-DOM will connect to the network " + values[0] + " with password " + values[1] + " and to the core " + values[2] + " upon restart <br><a href=\"/\">Change settings</a>");

    int eeADDR = 0;
    EEPROM.write(eeADDR, 0);
    eeADDR ++;
    
    eeADDR = eeprom_write(values[0], eeADDR);

    eeADDR = eeprom_write(values[1], eeADDR);

    eeADDR = eeprom_write(values[2], eeADDR);
    
    EEPROM.commit();
    
  });

  APserver.onNotFound(notFound);
  APserver.begin();

  Serial.println("HTTP server started");

}

//end of setup mode variables and functions initialzzation



//standard mode variables and functions initialization

WiFiClient TCPclient;

IPAddress coreIP;

String hostName;

String eeprom_read(int addr) {

  String var;
  while(true) {
    if (char(EEPROM.read(addr)) == '/') break;
    else {
      var += char(EEPROM.read(addr));
      addr ++;
    }
  }

  return var;

}

void standard_mode() {
  
  Serial.print("Entering standard mode");

  int eeADDR = 1;
  String ssid = eeprom_read(eeADDR);

  eeADDR += ssid.length() + 1;
  
  String password = eeprom_read(eeADDR);

  eeADDR += password.length() + 1;

  hostName = eeprom_read(eeADDR);

  WiFi.hostname(hostName);
  
  WiFi.begin(ssid, password);
  Serial.println();
  //Wait for connection
  Serial.print("Connecting to " + ssid);
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("Connected to "); Serial.println(ssid);
  Serial.print("DOM IP Address: "); Serial.println(WiFi.localIP());

  char* coreName = "CEDS-Core";

  WiFi.hostByName(coreName, coreIP);

  Serial.println();
  Serial.println("Establishing TCP connection to CEDS-Core[" + coreIP.toString() + "] on port: 65432");

  while (!TCPclient.connect(coreIP , 65432)){
    int t = 0;  
    Serial.print("Connection attempt ");
    Serial.println(t);
    delay(2500);
    if (t == 5) {
      Serial.println("Connection Timeout!");
      TCPclient.stop();
      while(true){}
    }
    t++;
  }

  Serial.println("Connection to CEDS-Core succesfull");

}

//end of standard mode variables and functions initialization



void setup() {
  
  Serial.begin(115200);

  delay(5000);

  //reading the _SETUP variable from EEPROM 
  EEPROM.begin(512);
  //EEPROM.write(0,1);
  //EEPROM.commit();
  int addr = 0;
  _SETUP = EEPROM.read(addr);
  addr ++;
  Serial.println(_SETUP);
  
  //setup mode
  if (_SETUP == 1)
  {
    setup_mode();
  }
  else 
  {
    standard_mode(); 
  }
  
}

//ESP PINS
//GPIO 0 - INPUT fisical switch
//GPIO 2 - OUTPUT relay

void loop() {

  TCPclient.print(hostName);
  
  while (TCPclient.connected() || TCPclient.available())
  {
    if (TCPclient.available())
    {
      String line = TCPclient.readStringUntil('\n');
      Serial.println(line);
    }
  }

}