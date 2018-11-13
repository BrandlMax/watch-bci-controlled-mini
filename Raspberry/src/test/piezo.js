var five = require("johnny-five");
var Raspi = require("raspi-io");

var board = new five.Board({
  io: new Raspi()
});

board.on("ready", function() {
    var piezo = new five.Piezo('P1-16');

    // Injects the piezo into the repl
    board.repl.inject({
      piezo: piezo
    });
  
    // Plays a song
    // piezo.play({
    //   // song is composed by an array of pairs of notes and beats
    //   // The first argument is the note (null means "no note")
    //   // The second argument is the length of time (beat) of the note (or non-note)
    //   song: [
    //     ["C4", 1 / 4],
    //     ["D4", 1 / 4],
    //     ["F4", 1 / 4],
    //     ["D4", 1 / 4],
    //     ["A4", 1 / 4],
    //     [null, 1 / 4],
    //     ["A4", 1],
    //     ["G4", 1],
    //     [null, 1 / 2],
    //     ["C4", 1 / 4],
    //     ["D4", 1 / 4],
    //     ["F4", 1 / 4],
    //     ["D4", 1 / 4],
    //     ["G4", 1 / 4],
    //     [null, 1 / 4],
    //     ["G4", 1],
    //     ["F4", 1],
    //     [null, 1 / 2]
    //   ],
    //   tempo: 100
    // });
  
    // Plays the same song with a string representation
    piezo.play({
      // song is composed by a string of notes
      // a default beat is set, and the default octave is used
      // any invalid note is read as "no note"
      song: "E4 G4 - A4 A4 - A4 B4 - C5 C5 - C5 D5 B4 B4 - A4 G4 A4 - E4 G4 A4 A4 - A4 B4 C5 C5 - C5 D5 B4 B4 - A4 G4 A4 ",
      beats: 1 / 4,
      tempo: 80
    });
});