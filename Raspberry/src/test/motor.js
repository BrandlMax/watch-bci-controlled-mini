const Gpio = require('pigpio').Gpio;
const Motor = new Gpio(12, {mode: Gpio.OUTPUT});

let pulseWidth = 1000;
let increment = 100;

setInterval(() => {
  Motor.servoWrite(pulseWidth);

  pulseWidth += increment;
  if (pulseWidth >= 2000) {
    increment = -100;
  } else if (pulseWidth <= 1000) {
    increment = 100;
  }
}, 1000);