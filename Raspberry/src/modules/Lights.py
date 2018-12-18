import RPi.GPIO as GPIO

# SET UP LED
def setup():
    GPIO.setup(22, GPIO.OUT, initial=GPIO.LOW) # Set pin 8 to be an output pin and set initial value to low (off)

def on():
    GPIO.output(22, GPIO.HIGH)

def off():
    GPIO.output(22, GPIO.LOW)