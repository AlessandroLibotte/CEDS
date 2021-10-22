import numpy as np
import time
import random


class Rule110:

    def __init__(self):
        self.celNum = 32
        self.screen = np.zeros((32, 32, 3), np.uint8)
        self.cells = np.zeros(self.celNum, bool)
        random.seed(time.time())
        self.random_condition()
        return

    def random_condition(self):
        for j in range(random.randrange(32)):
            self.cells[random.randrange(32)] = 1

    def update_screen(self, x, y):
        self.screen[x][y] = (255, 255, 255)
        return

    def update_state(self, y):
        next_cells = np.zeros(self.celNum, bool)
        for x in range(len(self.cells)-1):
            if self.cells[x]:
                next_cells[x] = not(self.cells[x-1] and self.cells[x+1])
            else:
                next_cells[x] = self.cells[x+1]

            if next_cells[x]:
                self.update_screen(y, x)

        self.cells = next_cells
        return


class Rule106:

    def __init__(self):
        self.celNum = 32
        self.screen = np.zeros((32, 32, 3), np.uint8)
        self.cells = np.zeros(self.celNum, bool)
        random.seed(time.time())
        self.random_condition()
        return

    def random_condition(self):
        for j in range(random.randrange(self.celNum)):
            self.cells[random.randrange(self.celNum)] = 1

    def update_screen(self, x, y, color):
        self.screen[y][x] = color
        return

    def update_state(self, y):
        color = ()
        next_cells = np.zeros(self.celNum, bool)
        for x in range(len(self.cells)-1):

            if self.cells[x-1] == 1:

                if self.cells[x] == 1:

                    if self.cells[x+1] == 1:
                        next_cells[x] = 0
                    else:
                        next_cells[x] = 1
                        color = (255, 255, 0)

                else:

                    if self.cells[x+1] == 1:
                        next_cells[x] = 1
                        color = (255, 125, 0)
                    else:
                        next_cells[x] = 0

            else:

                if self.cells[x] == 1:

                    if self.cells[x+1] == 1:
                        next_cells[x] = 1
                        color = (255, 125, 125)
                    else:
                        next_cells[x] = 0

                else:

                    if self.cells[x+1] == 1:
                        next_cells[x] = 1
                        color = (125, 0, 255)
                    else:
                        next_cells[x] = 0

            if next_cells[x]:
                self.update_screen(x, y, color)

        self.cells = next_cells
        return
