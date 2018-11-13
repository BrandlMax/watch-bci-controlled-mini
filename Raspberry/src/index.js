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
    let motor = new five.Motor(['P1-32', 'P1-38', 'P1-36']);
    let lenkung = new five.Motor(['P1-33', 'P1-37', 'P1-35']);
    let lights = new five.Led('P1-22');
    var horn = new five.Piezo('P1-16');

    board.repl.inject({
        piezo: horn
    });

    // SETUP / RESET
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
                motor.reverse(speed*-1);
            }
        })

        socket.on('direction', function(direction){
            console.log('direction', direction);

            if(direction >= 0){
                lenkung.forward(direction);
            } else{
                lenkung.reverse(direction*-1);
            }
        })

        socket.on('light', function(light){
            console.log('light', light);
            if(light){
                lights.on();
            }else{
                light.off();
            }
            
        })

        socket.on('horn', function(sound){
            console.log('horn', sound);
            horn.play({
                song: "E4 G4 - A4 A4 - A4 B4 - C5 C5 - C5 D5 B4 B4 - A4 G4 A4 - E4 G4 A4 A4 - A4 B4 C5 C5 - C5 D5 B4 B4 - A4 G4 A4 ",
                beats: 1 / 4,
                tempo: 80
            });
        })

    });

});

