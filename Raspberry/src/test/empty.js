var five = require("johnny-five");
var Raspi = require("raspi-io");

var board = new five.Board({
    io: new Raspi(),
    debug: true,
});