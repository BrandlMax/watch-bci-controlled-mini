var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
    console.log('a user connected');
});

http.listen(3000, function(){
    console.log('listening on *:3000');
});

var five = require("johnny-five");
var Raspi = require("raspi-io");

var board = new five.Board({
  io: new Raspi()
});

board.on("ready", function() {
    let motor = new five.Motor(['P1-12', 'P1-16', 'P1-18']);
    let lenkung = new five.Motor(['P1-33', 'P1-38', 'P1-40']);
    let lights = new five.Led('P1-11');

    lights.blink(500);

    // SETUP
    lenkung.stop();
    lenkung.start(0);

    motor.stop();
    motor.start(0);

    io.on('connection', function(socket){
        
        socket.on('speed', function(speed){
            console.log('Speed', speed);

            if(speed >= 0){
                motor.forward(speed);
            } else{
                motor.reverse(speed*-1)
            }
        })

        socket.on('direction', function(direction){
            console.log('direction', direction);
            
            if(direction >= 0){
                lenkung.forward(direction);
            } else{
                lenkung.reverse(direction*-1)
            }
        })

        socket.on('light', function(light){
            console.log('light', light);

        })

        socket.on('horn', function(horn){
            console.log('horn', horn);

        })

    });

});

