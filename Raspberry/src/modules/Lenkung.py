# Thanks to Johannes Petz https://www.johannespetz.de/l293d-geschwindigkeit-und-richtung-von-dc-motoren-steuern/

import RPi.GPIO as io
io.setmode(io.BOARD)

lenkung = ""
in1_pin = 37
in2_pin = 35
pwm_pin = 33

def setup():
    global lenkung
    io.setup(in1_pin, io.OUT)
    io.setup(in2_pin, io.OUT)
    io.setup(pwm_pin, io.OUT)
    
    # PWM konfigurieren
    # Pulse Weite
    lenkung = io.PWM(pwm_pin, 100)
    # Start des Pulses
    lenkung.start(0)
    # Stillstand vorgeben
    lenkung.ChangeDutyCycle(0)
 
def winkel(speed):
    global lenkung
    # Hier wird die Geschwindigkeit geregelt, durch den Multiplikator 11
    # wird eine maximale Pulse Weite von 99 erreicht. In diesem Skript
    # ist eine Pulsweite von 0-100 vorgegeben. 99 ist hierbei das schnellste
    speed = int(speed)
    lenkung.ChangeDutyCycle(speed)
 
# Die Definition der Richtung ist nicht vorgegeben, da die Pins keine bestimmte
# Belegung voraussetzten.
# Stehen beide Outputs auf False, werden die Motoren blockiert und somit gebremst.
def right():
    io.output(in1_pin, True)
    io.output(in2_pin, False)
 
def left():
    io.output(in1_pin, False)
    io.output(in2_pin, True)