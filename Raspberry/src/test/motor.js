var five = require("johnny-five");
var Raspi = require("raspi-io");

var board = new five.Board({
  io: new Raspi()
});

board.on("ready", function() {
  let motor = new five.Motor(['P1-12', 'P1-16', 'P1-18']);
  let lenkung = new five.Motor(['P1-33', 'P1-38', 'P1-40']);

  lenkung.stop();
  lenkung.start(0);

  motor.stop();
  motor.start(0);


  board.wait(5000, function () {
    motor.forward(255);
    lenkung.forward(255);
    console.log('forward');
  });

  board.wait(15000, function () {
    lenkung.reverse(255);
    motor.reverse(255);
    console.log('reverse');
  });


  board.wait(20000, function () {
    lenkung.stop();
    motor.stop();
    console.log('reverse');
  });


});

