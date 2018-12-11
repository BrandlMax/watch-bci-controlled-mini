import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library
from time import sleep # Import the sleep function from the time module
from aiohttp import web
import socketio

from l293d import driver

# SETUP GPIO
GPIO.cleanup() 
GPIO.setwarnings(True) 
GPIO.setmode(GPIO.BOARD) # Use physical pin numbering

# SETUP LED
GPIO.setup(22, GPIO.OUT, initial=GPIO.LOW) # Set pin 8 to be an output pin and set initial value to low (off)

#SETUP MOTOR
motor = driver.DC(38, 32, 36)

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
    data = int(data)
    if data >= 0:
        motor.clockwise(speed=data)
    else:
        data = data * -1
        print(data)
        motor.anticlockwise(speed=data)


@sio.on('direction')
async def changeDirection(sid, data):
    print("changeDirection ", data)

@sio.on('horn')
async def playHorn(sid, data):
    print("playHorn ", data)

@sio.on('light')
async def turnLight(sid, data):
    print("turnLight ", data)
    if data:
        GPIO.output(22, GPIO.HIGH)
    else:
        GPIO.output(22, GPIO.LOW)

@sio.on('disconnect')
def disconnect(sid):
    print('disconnect ', sid)

if __name__ == '__main__':
    web.run_app(app)

GPIO.cleanup() 