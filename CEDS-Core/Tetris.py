import numpy as np
import random2 as rand


class Tetris:

    def __init__(self):
        self.matrix = np.zeros((20, 10), np.uint)
        self.fallingMatrix = np.zeros((20, 10), np.uint)
        self.restart()

    def game_cycle(self):

        self.y += 1

        self.place_piece(0)

        self.update_falling_matrix()

        self.collision_detection(2)

        return

    def update_falling_matrix(self):

        def p0():

            def r0():
                for a in range(4):
                    self.fallingMatrix[(self.y - 1) + a][self.x] = self.c
                return

            def r1():
                for a in range(4):
                    self.fallingMatrix[self.y][(self.x - 2) + a] = self.c
                return

            def r2():
                for a in range(4):
                    self.fallingMatrix[(self.y - 2) + a][self.x] = self.c
                return

            def r3():
                for a in range(4):
                    self.fallingMatrix[self.y][(self.x - 1) + a] = self.c
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

            return

        def p1():

            def r0():
                for a in range(2):
                    self.fallingMatrix[self.y - a][self.x - 1] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y][(self.x + 1) - a] = self.c
                return

            def r1():
                for a in range(2):
                    self.fallingMatrix[self.y - 1][self.x + a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x] = self.c
                return

            def r2():
                for a in range(2):
                    self.fallingMatrix[self.y][self.x - a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x + 1] = self.c
                return

            def r3():
                for a in range(2):
                    self.fallingMatrix[self.y - a][self.x] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + 1][self.x - a] = self.c
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

            return

        def p2():

            def r0():
                for a in range(2):
                    self.fallingMatrix[(self.y - 1) + a][self.x + 1] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y][(self.x - 1) + a] = self.c
                return

            def r1():
                for a in range(2):
                    self.fallingMatrix[(self.y - 1) + a][self.x] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + 1][self.x + a] = self.c
                return

            def r2():
                for a in range(2):
                    self.fallingMatrix[self.y][self.x + a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x - 1] = self.c
                return

            def r3():
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y - 1][self.x - a] = self.c
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

            return

        def p3():

            def r0():
                for a in range(2):
                    self.fallingMatrix[self.y][self.x - a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y - 1][self.x + a] = self.c
                return

            def r1():
                for a in range(2):
                    self.fallingMatrix[self.y - a][self.x] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x + 1] = self.c
                return

            def r2():
                for a in range(2):
                    self.fallingMatrix[self.y][self.x + a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + 1][self.x - a] = self.c
                return

            def r3():
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y - a][self.x - 1] = self.c
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

            return

        def p4():

            def r0():
                for a in range(2):
                    self.fallingMatrix[self.y - 1][self.x - a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y][self.x + a] = self.c
                return

            def r1():
                for a in range(2):
                    self.fallingMatrix[self.y - a][self.x + 1] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x] = self.c
                return

            def r2():
                for a in range(2):
                    self.fallingMatrix[self.y][self.x - a] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + 1][self.x + a] = self.c
                return

            def r3():
                for a in range(2):
                    self.fallingMatrix[self.y - a][self.x] = self.c
                for a in range(2):
                    self.fallingMatrix[self.y + a][self.x - 1] = self.c
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

            return

        def p5():

            def r0():
                for a in range(3):
                    self.fallingMatrix[self.y][(self.x - 1) + a] = self.c
                self.fallingMatrix[self.y - 1][self.x] = self.c
                return

            def r1():
                for a in range(3):
                    self.fallingMatrix[(self.y - 1) + a][self.x] = self.c
                self.fallingMatrix[self.y][self.x + 1] = self.c
                return

            def r2():
                for a in range(3):
                    self.fallingMatrix[self.y][(self.x - 1) + a] = self.c
                self.fallingMatrix[self.y + 1][self.x] = self.c
                return

            def r3():
                for a in range(3):
                    self.fallingMatrix[(self.y - 1) + a][self.x] = self.c
                self.fallingMatrix[self.y][self.x - 1] = self.c
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

            return

        def p6():

            for a in range(2):
                self.fallingMatrix[self.y][self.x - a] = self.c
            for a in range(2):
                self.fallingMatrix[self.y - 1][self.x - a] = self.c

            return

        draw = {
            0: p0,
            1: p1,
            2: p2,
            3: p3,
            4: p4,
            5: p5,
            6: p6
        }

        self.fallingMatrix = np.zeros((20, 10), np.uint)

        draw[self.piece]()

        return

    def move(self, d):

        if d == 0:
            self.x = (self.x - 1) + self.border_detection(d)

            self.update_falling_matrix()

            self.x = self.x + self.collision_detection(d)

        elif d == 1:
            self.x = (self.x + 1) + self.border_detection(d)

            self.update_falling_matrix()

            self.x = self.x + self.collision_detection(d)

        self.update_falling_matrix()
        return

    def rotate(self):

        if self.piece != 6:
            self.r += 1

        if self.r > 3:
            self.r = 0

        if self.piece == 0:
            def r0():
                self.y -= 1

            def r1():
                self.x += 1

            def r2():
                self.y += 1

            def r3():
                self.x -= 1

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()

        r1 = self.r
        self.r += (-self.border_detection(0, 1)) + self.border_detection(1, 1)

        if self.r < 0:
            self.r = 3
        print(self.r)
        if self.piece == 0 and r1 != self.r:
            def r0():
                self.y += 1

            def r1():
                self.x -= 1

            def r2():
                self.y -= 1

            def r3():
                self.x += 1

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r + 1]()

        self.update_falling_matrix()
        self.r += self.collision_detection(1)
        self.update_falling_matrix()
        return

    def border_detection(self, d, r=0):

        def p0():

            def r0():
                if self.x + 1 - r > 9 and d == 1:
                    return -1
                elif self.x - 1 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r1():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 3 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r2():
                if self.x + 1 - r > 9 and d == 1:
                    return -1
                elif self.x - 1 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r3():
                if self.x + 3 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            return sort_r[self.r]()

        def p12():

            def r0():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r1():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 1 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r2():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r3():
                if self.x + 1 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            return sort_r[self.r]()

        def p34():

            def r0():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r1():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 1 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r2():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r3():
                if self.x + 1 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            return sort_r[self.r]()

        def p5():

            def r0():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r1():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 1 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r2():
                if self.x + 2 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            def r3():
                if self.x + 1 - r > 9 and d == 1:
                    return -1
                elif self.x - 2 + r < 0 and d == 0:
                    return 1
                else:
                    return 0

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            return sort_r[self.r]()

        def p6():

            if self.x + 1 > 9 and d == 1:
                return -1
            elif self.x - 2 < 0 and d == 0:
                return 1
            else:
                return 0

        sort_p = {
            0: p0,
            12: p12,
            34: p34,
            5: p5,
            6: p6
        }

        if self.piece == 1 or self.piece == 2:
            return sort_p[12]()
        elif self.piece == 3 or self.piece == 4:
            return sort_p[34]()
        else:
            return sort_p[self.piece]()

    def collision_detection(self, d):
        # checks neighbours pieces and bottom pieces
        if self.piece != 0:

            if self.piece == 6:
                for a in range(2):
                    for b in range(2):
                        if self.fallingMatrix[(self.y - 1) + a][(self.x - 1) + b] != 0:
                            if self.matrix[(self.y - 1) + a][(self.x - 1) + b] != 0:
                                if d == 0:
                                    return 1
                                elif d == 1:
                                    return -1
                                elif d == 2:
                                    self.y -= 1
                                    self.update_falling_matrix()
                                    self.place_piece(1)
                return 0

            def r0():
                for a in range(2):
                    for b in range(3):
                        if self.fallingMatrix[(self.y - 1) + a][(self.x - 1) + b] != 0:
                            if self.matrix[(self.y - 1) + a][(self.x - 1) + b] != 0:
                                if d == 0:
                                    return 1
                                elif d == 1:
                                    return -1
                                elif d == 2:
                                    self.y -= 1
                                    self.update_falling_matrix()
                                    self.place_piece(1)
                return 0

            def r1():
                for a in range(3):
                    for b in range(2):
                        if self.fallingMatrix[(self.y - 1) + a][self.x + b] != 0:
                            if self.matrix[(self.y - 1) + a][self.x + b] != 0:
                                if d == 0:
                                    return 1
                                elif d == 1:
                                    return -1
                                elif d == 2:
                                    self.y -= 1
                                    self.update_falling_matrix()
                                    self.place_piece(1)
                return 0

            def r2():
                for a in range(2):
                    for b in range(3):
                        if self.fallingMatrix[self.y + a][(self.x - 1) + b] != 0:
                            if self.matrix[self.y + a][(self.x - 1) + b] != 0:
                                if d == 0:
                                    return 1
                                elif d == 1:
                                    return -1
                                elif d == 2:
                                    self.y -= 1
                                    self.update_falling_matrix()
                                    self.place_piece(1)
                return 0

            def r3():
                for a in range(3):
                    for b in range(2):
                        if self.fallingMatrix[(self.y - 1) + a][(self.x - 1) + b] != 0:
                            if self.matrix[(self.y - 1) + a][(self.x - 1) + b] != 0:
                                if d == 0:
                                    return 1
                                elif d == 1:
                                    return -1
                                elif d == 2:
                                    self.y -= 1
                                    self.update_falling_matrix()
                                    self.place_piece(1)
                return 0

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            return sort_r[self.r]()
        else:
            def r0():
                for a in range(4):
                    if self.fallingMatrix[(self.y - 1) + a][self.x] != 0:
                        if self.matrix[(self.y - 1) + a][self.x] != 0:
                            if d == 0:
                                return 1
                            elif d == 1:
                                return -1
                            elif d == 2:
                                self.y -= 1
                                self.update_falling_matrix()
                                self.place_piece(1)
                return 0

            def r1():
                for a in range(4):
                    if self.fallingMatrix[self.y][(self.x - 2) + a] != 0:
                        if self.matrix[self.y][(self.x - 2) + a] != 0:
                            if d == 0:
                                return 1
                            elif d == 1:
                                return -1
                            elif d == 2:
                                self.y -= 1
                                self.update_falling_matrix()
                                self.place_piece(1)
                return 0

            def r2():
                for a in range(4):
                    if self.fallingMatrix[(self.y - 2) + a][self.x] != 0:
                        if self.matrix[(self.y - 2) + a][self.x] != 0:
                            if d == 0:
                                return 1
                            elif d == 1:
                                return -1
                            elif d == 2:
                                self.y -= 1
                                self.update_falling_matrix()
                                self.place_piece(1)
                return 0

            def r3():
                for a in range(4):
                    if self.fallingMatrix[self.y][(self.x - 2) + a] != 0:
                        if self.matrix[self.y][(self.x - 2) + a] != 0:
                            if d == 0:
                                return 1
                            elif d == 1:
                                return -1
                            elif d == 2:
                                self.y -= 1
                                self.update_falling_matrix()
                                self.place_piece(1)
                return 0

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            return sort_r[self.r]()

    def place_piece(self, c):
        if self.y <= 1 and c == 1:
            self.gameover()

        if self.piece == 0:
            def r0():
                if self.y == 18 or c == 1:
                    for a in range(4):
                        self.matrix[((self.y - 2) + c) + a][self.x] = self.c
                    self.restart()
                return

            def r1():
                if self.y == 20 or c == 1:
                    for a in range(4):
                        self.matrix[(self.y - 1) + c][(self.x - 2) + a] = self.c
                    self.restart()
                return

            def r2():
                if self.y == 19 or c == 1:
                    for a in range(4):
                        self.matrix[((self.y - 3) + c) + a][self.x] = self.c
                    self.restart()
                return

            def r3():
                if self.y == 20 or c == 1:
                    for a in range(4):
                        self.matrix[(self.y - 1) + c][(self.x - 1) + a] = self.c
                    self.restart()
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()
            return
        elif self.piece == 6:
            if self.y == 20 or c == 1:
                for a in range(2):
                    for b in range(2):
                        if self.fallingMatrix[((self.y-2) + c) + a][(self.x - 1) + b] != 0:
                            self.matrix[((self.y-2) + c) + a][(self.x - 1) + b] = self.fallingMatrix[((self.y-2) + c) + a][(self.x - 1) + b]
                self.restart()
            return
        else:
            def r0():
                if self.y == 20 or c == 1:
                    for a in range(2):
                        for b in range(3):
                            if self.fallingMatrix[((self.y - 2) + c) + a][(self.x - 1) + b] != 0:
                                self.matrix[((self.y - 2) + c) + a][(self.x - 1) + b] = self.fallingMatrix[((self.y - 2) + c) + a][(self.x - 1) + b]
                    self.restart()
                return

            def r1():
                if self.y == 19 or c == 1:
                    for a in range(3):
                        for b in range(2):
                            if self.fallingMatrix[((self.y - 2) + c) + a][self.x + b] != 0:
                                self.matrix[((self.y - 2) + c) + a][self.x + b] = self.fallingMatrix[((self.y - 2) + c) + a][self.x + b]
                    self.restart()
                return

            def r2():
                if self.y == 19 or c == 1:
                    for a in range(2):
                        for b in range(3):
                            if self.fallingMatrix[((self.y - 1) + c) + a][(self.x - 1) + b] != 0:
                                self.matrix[((self.y - 1) + c) + a][(self.x - 1) + b] = self.fallingMatrix[((self.y - 1) + c) + a][(self.x - 1) + b]
                    self.restart()
                return

            def r3():
                if self.y == 19 or c == 1:
                    for a in range(3):
                        for b in range(2):
                            if self.fallingMatrix[((self.y - 2) + c) + a][(self.x - 1) + b] != 0:
                                self.matrix[((self.y - 2) + c) + a][(self.x - 1) + b] = self.fallingMatrix[((self.y - 2) + c) + a][(self.x - 1) + b]
                    self.restart()
                return

            sort_r = {
                0: r0,
                1: r1,
                2: r2,
                3: r3
            }

            sort_r[self.r]()
        return

    def check_line(self):
        counter = 0
        for a in range(1, 20):
            for b in range(10):
                if self.matrix[a][b] != 0:
                    counter += 1
            if counter == 10:
                for c in range(a, 0, -1):
                    for b in range(10):
                        self.matrix[c][b] = self.matrix[c - 1][b]
            counter = 0
        return

    def restart(self):
        self.check_line()
        self.y = 1
        self.c = rand.randint(1, 7)
        self.piece = rand.randint(0, 6)
        self.x = 3
        if self.piece == 0:
            self.r = 1
        else:
            self.r = 0
        self.update_falling_matrix()
        return

    def gameover(self):
        self.fallingMatrix = np.zeros((20, 10), np.uint)
        self.matrix = np.zeros((20, 10), np.uint)
        return
