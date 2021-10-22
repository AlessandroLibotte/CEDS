import time

from LedDriverEmu import *
from DevicesDriver import Devices
from datetime import datetime
import mysql.connector
import pyowm


class Core:

    def __init__(self):

        # self.Devices = Devices()

        self.Driver = Driver()

        self.now = datetime.now()

        self.CoreDb = mysql.connector.connect(
            host="127.0.0.1",
            user="core",
            password="bAsY8kR5",
            database="Core"
        )
        self.dbCursor = self.CoreDb.cursor()

        self.owm = pyowm.OWM('ac2af8d27f4337595f96c5ed4ac09e70')

        self.mgr = self.owm.weather_manager()

        self.temp = 0
        self.temp_unit = ""
        self.status = ""

        self.detailed_status = ''

        self.checkSums = [
            0,  # light_checksum
            0,  # weather_checksum
            0,  # game_checksum
            0,  # settings_checksum
            0,  # devices_checksum
        ]

        self.led_enable = False
        self.rgb = ()
        self.brightness = 0
        self.mode = ""

        self.gameEnable = 0
        self.game = ''

        return

    def db_check_changes(self):

        tables = [
            "light",
            "games",
            "settings",
            "weather"
        ]

        queryTemplate = "CHECKSUM TABLE "

        apply = ()

        for table in tables:

            queryComplete = queryTemplate + table

            self.dbCursor.execute(queryComplete)

            myresult = self.dbCursor.fetchall()

            if myresult[0][1] != self.checkSums[tables.index(table)]:
                self.checkSums[tables.index(table)] = myresult[0][1]
                self.CoreDb.commit()
                apply += (tables.index(table)+1,)
            else:
                self.CoreDb.commit()

        return apply

    def apply_changes(self, tables):

        def apply_settings_changes():

            self.dbCursor.execute("SELECT * FROM settings")

            myresult = self.dbCursor.fetchall()

            self.brightness = myresult[0][0]/1000

            # self.Driver.pixels.brightness = self.brightness
            # self.Driver.pixels.show()

            return

        def apply_light_changes():

            self.dbCursor.execute("SELECT * FROM light")

            myresult = self.dbCursor.fetchall()

            self.mode = myresult[0][3]

            if self.mode == 'Static':
                self.led_enable = int(myresult[0][0])
                if not self.led_enable:
                    self.Driver.pixels = self.Driver.cls()
                    self.Driver.display_main_menu(3, self.now.hour, self.now.minute, self.temp, self.temp_unit,
                                                  self.status)
                hex = myresult[0][1]
                self.brightness = int(myresult[0][2])
                self.rgb = tuple(int(hex[i:i + 2], 16) for i in (0, 2, 4))
            else:
                self.led_enable = int(myresult[0][0])
                self.brightness = int(myresult[0][2])
                self.colors = []
                for row in myresult:
                    self.colors.append(tuple(int(row[1][i:i + 2], 16) for i in (0, 2, 4)))

            self.CoreDb.commit()

            return

        def apply_weather_changes():

            # self.dbCursor.execute("SELECT * FROM weather")

            myresult = [['Rome', 'C']]

            obs = self.mgr.weather_at_place(myresult[0][0])

            w = obs.weather

            self.temp_unit = myresult[0][1]

            if self.temp_unit == 'C':
                self.temp = w.temperature('celsius')['temp']
            elif self.temp_unit == 'F':
                self.temp = w.temperature('fahrenheit')['temp']

            self.status = w.status

            # self.CoreDb.commit()

            return

        def apply_game_changes():
            self.dbCursor.execute("SELECT * FROM games")

            myresult = self.dbCursor.fetchall()

            if myresult[0][0] == 1:
                self.gameEnable = 1
                self.game = myresult[0][1]
            else:
                self.gameEnable = 0

            self.CoreDb.commit()

            return

        upd = 0

        sort_table = {
            1: apply_light_changes,
            2: apply_game_changes,
            3: apply_settings_changes,
            4: apply_weather_changes
        }

        for table in tables:

            sort_table[table]()
            if table != 3:
                upd = 1

        return upd

    def window(self):

        self.apply_changes((4,))
        self.Driver.display_main_menu(3, self.now.hour, self.now.minute, self.temp, self.temp_unit, self.status)

        while True:

            now = datetime.now()

            if not self.led_enable:

                if now.hour != self.now.hour:
                    #  Update weather every hour
                    self.apply_changes((4,))
                    self.Driver.display_main_menu(2, 0, 0, self.temp, self.temp_unit, self.status)

                if now.minute != self.now.minute:
                    #  Update Clock every minute
                    self.now = now
                    self.Driver.display_main_menu(1, self.now.hour, self.now.minute, 0, '', '')

            if self.apply_changes(self.db_check_changes()):

                #  Check for database changes and apply them

                print("[CORE] Updating matrix")

                if self.gameEnable == 1:
                    # game = GameDriver(self.game)
                    # game.game_cycle()
                    pass
                else:
                    if not self.led_enable:
                        print("[CORE] Updating main menu")
                        self.Driver.display_main_menu(2, 0, 0, self.temp, self.temp_unit, self.status)
                    else:
                        self.Driver.display_led(self.mode, self.rgb, self.brightness)

        return


core = Core()

core.window()
