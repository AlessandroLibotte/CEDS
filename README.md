# CEDS
Centralized Entertainment and Domotics System



This project aims to be the encounter of entertainment and domotics all in one centralized system. 
Featuring: 
  a mobile application to interact with the system (CEDS-App)
  a central unit equipped with a RspberryPi4B and 16x32 RGB LED screen (CEDS-Core)
  proprietary PCBs to integrate with the home enviroment (CEDS-Dom)



CEDS-Core

  The main code is written in python and is executed on the RspberryPi4B of the Core alongsides a MySQL database.

  It is divided in three main files:
    Core.py
    LedDriver.py
    DevicesDriver.py

  Core.py

   This file checks for changes on the the database and triggers screen updates.

  LedDriver.py

   This file handles the 16x32 RGB LED screen and draws pictures and numbers when an update is triggered.
   It also has a class that functions as a game grahics driver.
