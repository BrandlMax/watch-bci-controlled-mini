var five = require("johnny-five");
var Raspi = require("raspi-io");

var board = new five.Board({
  io: new Raspi()
});

board.on("ready", function() {
  var led = new five.Led("P1-22");
  led.off();

  board.wait(3000, function () {
    console.log('ON');
    led.on();
  });

  board.wait(20000, function () {
    console.log('OFF');
    led.off();
  });
});