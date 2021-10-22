from cv2 import cv2
import numpy as np


class Driver:

    def __init__(self):

        self.MatW = 16
        self.MatH = 32
        self.scale = 25

        self.cls = lambda: np.zeros((self.MatH * self.scale, self.MatW * self.scale, 3), np.uint8)

        self.pixels = self.cls()

        self.draw_pixel = lambda x, y, color: cv2.rectangle(self.pixels, (x * self.scale, y * self.scale),
                                                            ((x + 1) * self.scale, (y + 1) * self.scale), color, -1)

        return

    def pixels_show(self):

        screen = cv2.flip(self.pixels, 1)

        cv2.imshow("CEDS-core", screen)
        cv2.waitKey(1)

        return

    def display_main_menu(self, upd, hour, minute, temp, temp_unit, status):

        if upd == 1 or upd == 3:
            self.display_time(hour, minute)
        if upd == 2 or upd == 3:
            self.display_weather(temp, temp_unit, status)

        self.pixels_show()

        return

    def print_number(self, num, x, y):

        def zero(x, y):
            for i in range(3):
                self.draw_pixel(x - i, y, (255, 255, 255))
                self.draw_pixel(x - i, y + 4,(255, 255, 255))

            for i in range(3):
                self.draw_pixel(x, y + 1 + i, (255, 255, 255))
                self.draw_pixel(x - 2, y + 1 + i, (255, 255, 255))
            return

        def one(x, y):
            for i in range(4):
                self.draw_pixel(x - 1, y + i, (255, 255, 255))
            for i in range(3):
                self.draw_pixel(x - i, y + 4, (255, 255, 255))
            self.draw_pixel(x, y, (255, 255, 255))
            return

        def two(x, y):
            for i in range(3):
                self.draw_pixel(x - i, y, (255, 255, 255))
                self.draw_pixel(x - i, y + 2, (255, 255, 255))
                self.draw_pixel(x - i, y + 4, (255, 255, 255))
            self.draw_pixel(x - 2, y + 1, (255, 255, 255))
            self.draw_pixel(x, y + 3, (255, 255, 255))
            return

        def three(x, y):
            for i in range(3):
                self.draw_pixel(x - i, y, (255, 255, 255))
                self.draw_pixel(x - i, y + 4, (255, 255, 255))
            self.draw_pixel(x - 2, y + 1, (255, 255, 255))
            self.draw_pixel(x - 2, y + 2, (255, 255, 255))
            self.draw_pixel(x - 1, y + 2, (255, 255, 255))
            self.draw_pixel(x - 2, y + 3, (255, 255, 255))
            return

        def four(x, y):
            for i in range(2):
                self.draw_pixel(x, y + i, (255, 255, 255))
                self.draw_pixel(x - 2, y + i, (255, 255, 255))
                self.draw_pixel(x - 2, y + 3 + i, (255, 255, 255))
            for i in range(3):
                self.draw_pixel(x - i, y + 2, (255, 255, 255))
            return

        def five(x, y):
            for i in range(3):
                self.draw_pixel(x - i, y, (255, 255, 255))
                self.draw_pixel(x - i, y + 2, (255, 255, 255))
                self.draw_pixel(x - i, y + 4, (255, 255, 255))
            self.draw_pixel(x, y + 1, (255, 255, 255))
            self.draw_pixel(x - 2, y + 3, (255, 255, 255))
            return

        def six(x, y):
            for i in range(2):
                self.draw_pixel(x - 2 + i, y, (255, 255, 255))
                self.draw_pixel(x - 2 + i, y + 2, (255, 255, 255))
                self.draw_pixel(x - 2 + i, y + 4, (255, 255, 255))
            for i in range(5):
                self.draw_pixel(x, y + i, (255, 255, 255))
            self.draw_pixel(x - 2, y + 3, (255, 255, 255))
            return

        def seven(x, y):
            for i in range(2):
                self.draw_pixel(x - i, y, (255, 255, 255))
            for i in range(5):
                self.draw_pixel(x - 2, y + i, (255, 255, 255))
            return

        def eight(x, y):
            for i in range(3):
                self.draw_pixel(x - i, y, (255, 255, 255))
                self.draw_pixel(x - i, y + 2, (255, 255, 255))
                self.draw_pixel(x - i, y + 4, (255, 255, 255))
            for i in range(2):
                self.draw_pixel(x - (i * 2), y + 3, (255, 255, 255))
                self.draw_pixel(x - (i * 2), y + 1, (255, 255, 255))
            return

        def nine(x, y):
            for i in range(3):
                self.draw_pixel(x - i, y, (255, 255, 255))
                self.draw_pixel(x - i, y + 2, (255, 255, 255))
            for i in range(2):
                self.draw_pixel(x - 2, y + 3 + i, (255, 255, 255))
            self.draw_pixel(x, y + 1, (255, 255, 255))
            self.draw_pixel(x - 2, y + 1, (255, 255, 255))
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

    def display_led(self, mode, rgb, brightness):

        def Static():
            self.pixels = self.cls()
            self.pixels[:][:] = rgb
            # self.pixels.brightness = brightness * 0.001
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

        self.pixels_show()

        return

    def display_time(self, hour, minute):

        for i in range(0, 7 * self.scale):
            for n in range(0, (7 * self.scale) + 1):
                self.pixels[i][n] = (0, 0, 0)
        for i in range(0, 7 * self.scale):
            for n in range(8 * self.scale, (15 * self.scale) + 1):
                self.pixels[i][n] = (0, 0, 0)

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

        def display_img():

            sort_sprite = {
                'Sun': cv2.imread('imgs/solone2.png'),
                'Rain': cv2.imread('imgs/nuvoletta piagnona.png'),
                'Snow': cv2.imread('imgs/fiocchetto de borra.png'),
                'Clouds': cv2.imread('imgs/nuvoletta felicia .png'),
                'Clear': cv2.imread('imgs/solone2.png'),
            }

            img = sort_sprite[status]

            zero = np.zeros(3, int)

            cv2.rectangle(self.pixels, (0, 15 * self.scale), ((16 * self.scale) - 1, 31 * self.scale), (0, 0, 0), -1)

            for y in range(16):
                for x in range(16):
                    if img[y * 16][x * 16][2] != zero[2]:
                        self.draw_pixel(x, y + 15, (int(img[y*16][x*16][0]), int(img[y*16][x*16][1]), int(img[y*16][x*16][1])))

            return

        def C(x, y):

            for i in range(7 * self.scale, 7 * self.scale):
                for n in range(7 * self.scale, 15 * self.scale):
                    self.pixels[i][n] = (0, 0, 0)

            for i in range(3):
                self.draw_pixel(x-i, y, (255, 255, 255))
                self.draw_pixel(x-i, y+4, (255, 255, 255))

            for i in range(3):
                self.draw_pixel(x, y+1+i, (255, 255, 255))

            return

        def F(x, y):

            for i in range(7 * self.scale, 7 * self.scale):
                for n in range(7 * self.scale, 15 * self.scale):
                    self.pixels[i][n] = (0, 0, 0)

            for i in range(5):
                self.draw_pixel(x, y+i, (255, 255, 255))

            for i in range(2):
                self.draw_pixel(x-1-i, y, (255, 255, 255))
                self.draw_pixel(x - 1 - i, y+2, (255, 255, 255))

            return

        for i in range(15 * self.scale, 7 * self.scale):
            for n in range(15 * self.scale, 15 * self.scale):
                self.pixels[i][n] = (0, 0, 0)

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
