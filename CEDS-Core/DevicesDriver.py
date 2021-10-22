import threading
import socket
import mysql.connector
import time
import sys

class Devices:

    def __init__(self):

        self.IP = socket.gethostbyname(socket.gethostname() + ".local")
        self.PORT = 56789
        self.ADDR = (self.IP, self.PORT)

        self.CLIENTS = []
        self.CONNECTIONS = 0

        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.bind(self.ADDR)

        self.SERVER = threading.Thread(target=self.listen)
        self.SERVER.start()

        return

    def listen(self):

        self.server.listen()

        print(f"[SERVER] Thread started on address {self.ADDR[0]}:{self.ADDR[1]}")

        while True:
            conn, addr = self.server.accept()
            self.add_device(conn, addr)
            client = threading.Thread(target=self.HandleClient, args=(self, self.CLIENTS[-1]))
            client.start()

        return

    def add_device(self, conn, addr):

        self.CONNECTIONS = self.CONNECTIONS + 1

        device_id = self.CONNECTIONS

        self.CLIENTS.append((device_id, conn, addr))

        Devicesdb = mysql.connector.connect(
            host="127.0.0.1",
            user="core",
            password="bAsY8kR5",
            database="Core"
        )
        dbCursor = Devicesdb.cursor()

        dbCursor.execute(
            "insert into devices (id, hostname, MWSO, MPSO, state, RE) values (%s, %s, 0, 0, 0, 0)",
            (device_id, "DOM-"+str(device_id))
        )

        Devicesdb.commit()
        Devicesdb.close()

        print(f"[SERVER] New connection. Active connections: {self.CONNECTIONS}")
        print("[SERVER] Connected clients: ")
        for client in self.CLIENTS:
            print(f"\t Client:{client[0]}")

        return

    def disconnect_device(self, client):

        print(f"[SERVER] Client:{client[0]} disconnected. Performing disconnection procedure...")
        self.CLIENTS.remove(client)

        self.CONNECTIONS = self.CONNECTIONS - 1

        Devicesdb = mysql.connector.connect(
            host="127.0.0.1",
            user="core",
            password="bAsY8kR5",
            database="Core"
        )
        dbCursor = Devicesdb.cursor()

        dbCursor.execute("delete from devices where id = %s", (client[0],))

        Devicesdb.commit()
        Devicesdb.close()

        print("[SERVER] Connected clients: ")
        if len(self.CLIENTS) > 0:
            for client in self.CLIENTS:
                print(f"\t Client:{client[0]}")
        else:
            print("\t No clients currently connected")

        return

    class HandleClient(object):

        def __init__(self, outer, client):

            print("[SERVER] Starting client thread...")

            self.client = client
            self.outer = outer

            self.Devicesdb = mysql.connector.connect(
                host="127.0.0.1",
                user="core",
                password="bAsY8kR5",
                database="Core"
            )
            self.dbCursor = self.Devicesdb.cursor()

            self.connected = True
            self.checksum = 0
            self.state = 0

            self.hostname = socket.gethostbyaddr(self.client[2][0])

            stillalive = threading.Thread(target=self.stillalive, args=(self.client[1],))
            stillalive.start()

            MPSO = threading.Thread(target=self.MPSO, args=(self.client[1],))
            MPSO.start()

            self.main(self.client[1])

            return

        def stillalive(self, client):
            client.settimeout(5)
            while True:
                try:
                    msg = "stillalive\n"
                    client.send(msg.encode('utf-8'))
                    response = client.recv(10).decode('utf-8')
                    if response == "stillalive":
                        print(f"\t [CLIENT:{self.client[0]}] Conn check passed")
                        time.sleep(10)
                        continue
                    elif response == "MPSO-1":
                        response = client.recv(10).decode('utf-8')
                        if response == "stillalive":
                            print(f"\t [CLIENT:{self.client[0]}] Conn check passed")
                            time.sleep(10)
                            continue
                    else:
                        print(f"\t [CLIENT:{self.client[0]}] Conn check failed")
                        break
                except:
                    print(f"\t [CLIENT:{self.client[0]}] Conn check failed")
                    break

            self.connected = False
            self.Devicesdb.close()
            self.outer.disconnect_device(self.client)
            sys.exit()

            return

        def MPSO(self, client):

            while self.connected:
                msg = client.recv(6).decode('utf-8')
                if msg == "MPSO-0":
                    self.dbCursor.execute("update devices set MWSO = 0, MPSO = 1, sate = 1")
                    continue
                elif msg == "MPSO-1":
                    continue

            return

        def check_state_change(self):

            try:
                self.dbCursor.execute("CHECKSUM TABLE devices")

                myresult = self.dbCursor.fetchall()

                if myresult[0][1] != self.checksum:
                    print(f"\t [CLIENT:{self.client[0]}] Detected database change")
                    self.checksum = myresult[0][1]
                    self.Devicesdb.commit()
                    return 1
                else:
                    self.Devicesdb.commit()
                    return 0
            except:
                return 0

        def apply_changes(self):

            self.dbCursor.execute("select MWSO, state from devices where id = " + str(self.client[0]))

            myresult = self.dbCursor.fetchall()

            self.Devicesdb.commit()

            MWSO = myresult[0][0]
            state = myresult[0][1]

            if MWSO == 1:
                if state != self.state:
                    self.state = state
                    print(f"[SERVER] Client:{self.client[0]} state change. New state: ", end='')
                    if state == 1:
                        print("ON. Sending command...")
                        return 1
                    else:
                        print("OFF. Sending Command...")
                        return 0
                else:
                    print(f"[SERVER] No state change. Nothing sent to Client:{self.client[0]}")
                    return

            return

        def main(self, client):

            print(f"[SERVER] Client:{self.client[0]} thread successfully started")

            while self.connected:

                if self.check_state_change():

                    change = self.apply_changes()

                    if change == 1:
                        msg = "1\n"
                        client.send(msg.encode('utf-8'))
                        print("[SERVER] Command sent")
                    elif change == 0:
                        msg = "0\n"
                        client.send(msg.encode('utf-8'))
                        print("[SERVER] Command sent")
                    else:
                        continue

                    print("[SERVER] Waiting response from client")
                    response = client.recv(1).decode('utf-8')
                    print("[SERVER] Received response")
                    if response == "1":
                        print(f"\t [CLIENT:{self.client[0]}] Sate change. New state: ON")
                    elif response == "0":
                        print(f"\t [CLIENT:{self.client[0]}] Sate change. New state: OFF")

            sys.exit()
            return
