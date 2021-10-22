import board
import neopixel
from cv2 import cv2
import numpy
from Tetris import Tetris
from Wolfram import *
import time
import socket
import threading
import mysql.connector


class GameDriver:

    def __init__(self, game):

        self.Driver = Driver()

        self.game = game

        self.colors = (
            (0, 0, 0),
            (255, 0, 255),
            (255, 0, 0),
            (29, 255, 145),
            (0, 255, 255),
            (0, 0, 255),
            (255, 166, 45),
            (0, 255, 0)
        )

        self.t = 0.1
        self.start = time.time()
        self.stop = 0
        self.elapsed = 0

        self.enable = 1

        self.checksum = 0

        if game == "Tetris":

            self.tetris = Tetris()

            self.input = self.Input(self)

            self.fast = 0

            self.quit = 0

            self.k = 16

    class Input(object):

        def __init__(self, outer):
            self.outer = outer
            self.IP = '192.168.1.9'
            self.PORT = 65432
            self.ADDR = (self.IP, self.PORT)

            self.HEADER = 64
            self.FORMAT = 'utf-8'
            self.DISCONNECT_MSG = "!DISCONNECT"

            self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server.bind(self.ADDR)

            self.clients = []

            print(f"[SERVER] Starting on ip: {self.IP}")
            self.master_thread = threading.Thread(target=self.start)
            self.master_thread.start()

        def start(self):
            self.server.listen()

            while True:
                conn, addr = self.server.accept()
                thread = threading.Thread(target=self.handle_client, args=(conn, addr))
                print(f"[SERVER] New connection. Active connections: {threading.activeCount()}")
                thread.start()

        def handle_client(self, conn, addr):
            print(f"[SERVER] {addr[0]} CONNECTED")

            self.clients.append([addr[0], conn])

            connected = True
            while connected:

                msg_length = conn.recv(self.HEADER)
                msg_length = int(msg_length)
                msg = conn.recv(msg_length).decode(self.FORMAT)

                if self.outer.game == "Tetris":
                    if msg == "up":
                        self.outer.tetris.rotate()
                    if msg == "down":
                        self.outer.fast = not self.outer.fast
                    if msg == "right":
                        self.outer.tetris.move(1)
                    if msg == "left":
                        self.outer.tetris.move(0)

                if msg == self.DISCONNECT_MSG:
                    self.clients.remove([addr[0], conn])
                    connected = False
                    print(f"[SERVER] {addr[0]} Disconnected")
                    conn.close()
                    self.outer.quit = 1
                    continue

                print(f"[{addr[0]}] {msg}")

    def dbChecker(self):

        Db = mysql.connector.connect(
            host="127.0.0.1",
            user="core",
            password="bAsY8kR5",
            database="Core"
        )

        cursor = Db.cursor()

        while True:

            cursor.execute("CHECKSUM TABLE games")

            result = cursor.fetchall()

            if result[0][1] != self.checksum:

                self.checksum = result[0][1]

                Db.commit()

                cursor.execute("SELECT * FROM games")

                result = cursor.fetchall()

                if result[0][0] == 0:
                    self.enable = 0
                    Db.commit()
                    break
                else:
                    self.game = result[0][1]
                    Db.commit()
            else:
                Db.commit()

        return

    def game_cycle(self):

        dbcheck = threading.Thread(target=self.dbChecker)
        dbcheck.start()

        i = 32
        while self.enable:

            if self.game == "Tetris":

                self.Driver.pixels.fill((0, 0, 0))

                self.draw_frame()

                self.update_matrix()

                if self.fast == 0:
                    if self.t >= 0.1:
                        self.stop = time.time()
                        self.elapsed = self.stop - self.start
                        #print("time: " + str(self.elapsed))
                        self.tetris.game_cycle()
                        self.t = 0.0
                        self.start = time.time()
                    else:
                        self.t += 0.01
                else:
                    if self.t >= 0:
                        self.stop = time.time()
                        self.elapsed = self.stop - self.start
                        #print("time: " + str(self.elapsed))
                        self.tetris.game_cycle()
                        self.t = 0.0
                        self.start = time.time()
                    else:
                        self.t += 0.01

                if self.quit == 1:
                    self.Driver.pixels.fill((0, 0, 0))
                    self.Driver.pixels.show()
                    break

            elif "Rule" in self.game:

                if i < 32:
                    self.wolfram.update_state(i)
                    self.update_matrix()
                    i = i+1
                else:
                    sort_rule = {
                        "Rule110": Rule110,
                        "Rule106": Rule106,
                    }
                    self.wolfram = sort_rule[self.game]()
                    self.Driver.pixels.fill((0, 0, 0))
                    i = 0

        return

    def draw_frame(self):

        for a in range(21):
            self.Driver.pixels[self.Driver.XY(2, a)] = (255, 255, 255)
        for a in range(21):
            self.Driver.pixels[self.Driver.XY(13, a)] = (255, 255, 255)

        for b in range(2, 14):
            self.Driver.pixels[self.Driver.XY(b, 0)] = (255, 255, 255)
        for b in range(2, 14):
            self.Driver.pixels[self.Driver.XY(b, 21)] = (255, 255, 255)

        return

    def update_matrix(self):

        if self.game == "Tetris":
            for y in range(1, 1 + len(self.tetris.matrix)):
                for x in range(3, 3 + len(self.tetris.matrix[0])):
                    if self.tetris.matrix[y - 1][x - 3] != 0:
                        self.Driver.pixels[self.Driver.XY(x, y)] = self.colors[self.tetris.matrix[y - 1][x - 3]]
                    if self.tetris.fallingMatrix[y - 1][x - 3] != 0:
                        self.Driver.pixels[self.Driver.XY(x, y)] = self.colors[self.tetris.fallingMatrix[y - 1][x - 3]]
        elif "Rule" in self.game:
            for y in range(0, 32):
                for x in range(0, 16):
                    self.Driver.pixels[self.Driver.XY(x, y)] = self.wolfram.screen[y][x+8]

        self.Driver.pixels.show()

        return


class Driver:

    def __init__(self):
        self.MatW = 8
        self.MatH = 64

        NUM_LEDS = self.MatW * self.MatH

        print("[CORE] Initializing led matrix")

        self.pixels = neopixel.NeoPixel(board.D18, NUM_LEDS, brightness=0.01, auto_write=False)
        self.pixels.fill((0, 0, 0))

        print("[CORE] Led matrix initialized")

        return

    def XY(self, x, y):
        i = 0
        if y % 2 != 0:
            if x > 7:
                x = x - 8
                y = y + 32
                i = self.XY(x, y)
            else:
                rx = (self.MatW - 1) - x
                i = (y * self.MatW) + rx
        else:
            if x > 7:
                x = x - 8
                y = y + 32
                i = self.XY(x, y)
            else:
                i = (y * self.MatW) + x
        return i

    def display_main_menu(self, upd, hour, minute, temp, temp_unit, status):

        print("[CORE] Displaying main menu")

        # self.pixels.fill((0, 0, 0))
        # self.pixels.show()

        if upd == 1 or upd == 3:
            self.display_time(hour, minute)
        if upd == 2 or upd == 3:
            self.display_weather(temp, temp_unit, status)

        self.pixels.show()

        return

    def display_led(self, mode, rgb, brightness):

        def Static():
            self.pixels.fill(rgb)
            self.pixels.brightness = brightness * 0.001
            return

        def Breathing():
            return

        def Fade():
            return

        def Waterfall():
            return

        sort_mode = {
            'Static': Static,
            'Breathing': Breathing,
            'Fade': Fade,
            'Waterfall': Waterfall
        }

        sort_mode[mode]()

        self.pixels.show()

        return

    def print_number(self, num, x, y):

        def zero(x, y):
            for i in range(3):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 4)] = (255, 255, 255)

            for i in range(3):
                self.pixels[self.XY(x, y + 1 + i)] = (255, 255, 255)
                self.pixels[self.XY(x - 2, y + 1 + i)] = (255, 255, 255)
            return

        def one(x, y):
            for i in range(4):
                self.pixels[self.XY(x - 1, y + i)] = (255, 255, 255)
            for i in range(3):
                self.pixels[self.XY(x - i, y + 4)] = (255, 255, 255)
            self.pixels[self.XY(x, y)] = (255, 255, 255)
            return

        def two(x, y):
            for i in range(3):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 2)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 4)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 1)] = (255, 255, 255)
            self.pixels[self.XY(x, y + 3)] = (255, 255, 255)
            return

        def three(x, y):
            for i in range(3):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 4)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 1)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 2)] = (255, 255, 255)
            self.pixels[self.XY(x - 1, y + 2)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 3)] = (255, 255, 255)
            return

        def four(x, y):
            for i in range(2):
                self.pixels[self.XY(x, y + i)] = (255, 255, 255)
                self.pixels[self.XY(x - 2, y + i)] = (255, 255, 255)
                self.pixels[self.XY(x - 2, y + 3 + i)] = (255, 255, 255)
            for i in range(3):
                self.pixels[self.XY(x - i, y + 2)] = (255, 255, 255)
            return

        def five(x, y):
            for i in range(3):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 2)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 4)] = (255, 255, 255)
            self.pixels[self.XY(x, y + 1)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 3)] = (255, 255, 255)
            return

        def six(x, y):
            for i in range(2):
                self.pixels[self.XY(x - 2 + i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - 2 + i, y + 2)] = (255, 255, 255)
                self.pixels[self.XY(x - 2 + i, y + 4)] = (255, 255, 255)
            for i in range(5):
                self.pixels[self.XY(x, y + i)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 3)] = (255, 255, 255)
            return

        def seven(x, y):
            for i in range(2):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
            for i in range(5):
                self.pixels[self.XY(x - 2, y + i)] = (255, 255, 255)
            return

        def eight(x, y):
            for i in range(3):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 2)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 4)] = (255, 255, 255)
            for i in range(2):
                self.pixels[self.XY(x - (i * 2), y + 3)] = (255, 255, 255)
                self.pixels[self.XY(x - (i * 2), y + 1)] = (255, 255, 255)
            return

        def nine(x, y):
            for i in range(3):
                self.pixels[self.XY(x - i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - i, y + 2)] = (255, 255, 255)
            for i in range(2):
                self.pixels[self.XY(x - 2, y + 3 + i)] = (255, 255, 255)
            self.pixels[self.XY(x, y + 1)] = (255, 255, 255)
            self.pixels[self.XY(x - 2, y + 1)] = (255, 255, 255)
            return

        sort_num = {
            0: zero,
            1: one,
            2: two,
            3: three,
            4: four,
            5: five,
            6: six,
            7: seven,
            8: eight,
            9: nine
        }

        sort_num[num](x, y)

        return

    def display_time(self, hour, minute):

        print("[CORE]   Displaying time")

        for i in range(self.XY(0, 0), self.XY(7, 7)):
            self.pixels[i] = (0, 0, 0)
        for i in range(self.XY(8, 0), self.XY(15, 7)):
            self.pixels[i] = (0, 0, 0)

        if hour > 9:
            self.print_number(int(str(hour)[0]), 15, 1)
            self.print_number(int(str(hour)[1]), 11, 1)
        else:
            self.print_number(int(str(hour)[0]), 11, 1)

        if minute > 9:
            self.print_number(int(str(minute)[0]), 6, 1)
            self.print_number(int(str(minute)[1]), 2, 1)
        else:
            self.print_number(0, 6, 1)
            self.print_number(int(str(minute)[0]), 2, 1)

        return

    def display_weather(self, temp, temp_unit, status):

        print("[CORE]   Displaying weather")

        def display_img():

            sort_sprite = {
                'Sun': cv2.imread('imgs/solone2.png'),
                'Rain': cv2.imread('imgs/nuvoletta piagnona.png'),
                'Snow': cv2.imread('imgs/fiocchetto de borra.png'),
                'Clouds': cv2.imread('imgs/nuvoletta felicia .png'),
                'Clear': cv2.imread('imgs/solone2.png'),
            }

            img = sort_sprite[status]

            zero = numpy.zeros(3, int)

            for i in range(self.XY(7, 15), self.XY(0, 31)+1):
                self.pixels[i] = (0, 0, 0)
            for i in range(self.XY(15, 15), self.XY(8, 31)+1):
                self.pixels[i] = (0, 0, 0)

            print("[CORE]   Displaying Image")

            for y in range(16):
                for x in range(16):
                    if img[y * 16][x * 16][2] != zero[2]:
                        self.pixels[self.XY(x, y + 15)] = img[y*16][x*16]

            return

        def C(x, y):

            for i in range(self.XY(7, 7), self.XY(7, 15)):
                self.pixels[i] = (0, 0, 0)

            for i in range(3):
                self.pixels[self.XY(x-i, y)] = (255, 255, 255)
                self.pixels[self.XY(x-i, y+4)] = (255, 255, 255)

            for i in range(3):
                self.pixels[self.XY(x, y+1+i)] = (255, 255, 255)

            return

        def F(x, y):

            for i in range(self.XY(7, 7), self.XY(7, 15)):
                self.pixels[i] = (0, 0, 0)

            for i in range(5):
                self.pixels[self.XY(x, y+i)] = (255, 255, 255)

            for i in range(2):
                self.pixels[self.XY(x-1-i, y)] = (255, 255, 255)
                self.pixels[self.XY(x - 1 - i, y+2)] = (255, 255, 255)

            return

        for i in range(self.XY(15, 7), self.XY(15, 15)):
            self.pixels[i] = (0, 0, 0)

        if temp > 9:
            self.print_number(int(str(int(temp))[0]), 15, 8)
            self.print_number(int(str(int(temp))[1]), 11, 8)
        else:
            self.print_number(int(str(int(temp))[0]), 11, 8)

        if temp_unit == 'C':
            C(4, 8)
        elif temp_unit == 'F':
            F(4, 8)

        display_img()

        return
