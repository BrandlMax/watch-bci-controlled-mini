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

io.on('connection', function(socket){
    
    socket.on('speed', function(speed){
        console.log('Speed', speed);
    })

    socket.on('direction', function(direction){
        console.log('direction', direction);
    })

    socket.on('light', function(light){
        console.log('light', light);
    })

    socket.on('horn', function(sound){
        console.log('horn', sound);
    })

});
