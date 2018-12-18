#python3 index.py
import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library
from time import sleep # Import the sleep function from the time module
from aiohttp import web
import socketio

from modules import Lights
from modules import Motor
from modules import Lenkung
from modules import Horn

# SETUP GPIO
GPIO.cleanup() 
GPIO.setwarnings(True) 
GPIO.setmode(GPIO.BOARD) # Use physical pin numbering
GPIO.setwarnings(False)

# SETUP HORN
Horn.setup()

# SETUP LED
Lights.setup()

#SETUP MOTOR & LENKUNG
Motor.setup()
Lenkung.setup()

# SETUP SOCKET
sio = socketio.AsyncServer()
app = web.Application()
sio.attach(app)

@sio.on('connect')
def connect(sid, environ):
    print("connect ", sid)

@sio.on('speed')
async def changeSpeed(sid, data):
    print("changeSpeed ", data)
    data = float(data)
    print("DATA", data)
    if data > 0:
        Motor.geschwindigkeit(data)
        Motor.clockwise()
    else:
        data = data * -1
        Motor.geschwindigkeit(data)
        Motor.counter_clockwise()

@sio.on('direction')
async def changeDirection(sid, data):
    print("changeDirection ", data)
    data = float(data)
    print("DATA", data)
    if data > 0:
        Lenkung.winkel(data)
        Lenkung.right()
    else:
        data = data * -1
        Lenkung.winkel(data)
        Lenkung.left()

@sio.on('horn')
async def playHorn(sid, data):
    print("playHorn ", data)
    await Horn.playSong()

@sio.on('light')
async def turnLight(sid, data):
    print("turnLight ", data)
    if data:
        Lights.on()
    else:
        Lights.off()

@sio.on('disconnect')
def disconnect(sid):
    print('disconnect ', sid)

if __name__ == '__main__':
    web.run_app(app)

GPIO.cleanup() 