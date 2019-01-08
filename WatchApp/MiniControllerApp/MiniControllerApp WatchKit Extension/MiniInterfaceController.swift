//
//  MiniInterfaceController.swift
//  MiniControllerApp WatchKit Extension
//
//  Created by Maximilian Brandl on 25.12.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import WatchKit
import CoreMotion
import Foundation
import SocketIO

// SOCKET 🔌
let streamUrl = "http://mini.local:1337/stream.mjpg"
let manager = SocketManager(socketURL: URL(string: "http://mini.local:8080")!, config: [.log(true), .compress])
let socket = manager.defaultSocket
var CONNECTED = false

// 🚗 STATES
var lightState = false
var speedState = 0
var dirState = 0
var calcNewSpeedState = 0
var dirLabelState = "⬆️"

// Motion ⌚️🕹
let motionManager = CMMotionManager()

class MiniInterfaceController: WKInterfaceController {

    @IBOutlet weak var StreamImage: WKInterfaceImage!
    @IBOutlet weak var speedLabel: WKInterfaceLabel!
    @IBOutlet weak var dirLabel: WKInterfaceLabel!
    
    var stream: MJPEGStreamWatch!
    var url: URL?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        // DELEGATE 👑
        crownSequencer.delegate = self as WKCrownDelegate
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(!CONNECTED){
            
            // SOCKET 🔌
            socket.on(clientEvent: .connect) {  data, ack in
                print("socket connected")
                CONNECTED = true
                
            }
            socket.on("test") { data, ack in
                print(data)
                
            }
            
            socket.connect()
            
        }

        
        // START FOCUS 👑
        crownSequencer.focus()
        
        // Motion ⌚️🕹
        if motionManager.isDeviceMotionAvailable {
            print("Device Available")
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
                    } else {
                        //handle the error
                    }
            })
            motionManager.deviceMotionUpdateInterval = 0.1
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        socket.disconnect()
        CONNECTED = false
    }
    
    override func didAppear() {
        // Set the ImageView to the stream object
        stream = MJPEGStreamWatch(imageView: StreamImage)
        // Start Loading Indicator
        stream.didStartLoading = { [unowned self] in
            // self.loadingIndicator.startAnimating()
            print("didStartLoading!")
        }
        // Stop Loading Indicator
        stream.didFinishLoading = { [unowned self] in
            // self.loadingIndicator.stopAnimating()
            print("didFinishLoading!")
        }
        
        // Your stream url should be here !
        let url = URL(string: "http://mini.local:1337/stream.mjpg")
        stream.contentURL = url
        stream.play() // Play the stream
    }

    @IBAction func turnLightOn() {
        print("LIGHT")
        if(CONNECTED){
            lightState = !lightState
            socket.emit("light", lightState)
        }
    }
    
    @IBAction func pushHorn() {
        print("HORN")
        if(CONNECTED){
            socket.emit("horn", true)
        }
    }
    
    @IBAction func stopMotors() {
        print("STOP")
        if(CONNECTED){
            socket.emit("speed", 0)
        }
    }
    
    // ⌚️🕹
    func degrees(radians:Double) -> Double {
        return 180 / Double.pi * radians
    }
    
    func mapDir(roll: Double) -> Int{
        
        let calcMappedRoll = roll * 3.33
        var mappedRoll = 0
        
        // 100
        if(calcMappedRoll >= 100){
            mappedRoll = 100
            dirLabelState = "➡️"
        }
        
        //50
        if(calcMappedRoll >= 50 && calcMappedRoll < 100){
            mappedRoll = 100
            dirLabelState = "↗️"
        }
        
        // 0
        if(calcMappedRoll > -50 && calcMappedRoll < 50){
            mappedRoll = 0
            dirLabelState = "⬆️"
        }
        
        //-50
        if(calcMappedRoll <= -50 && calcMappedRoll > -100){
            mappedRoll = -50
            dirLabelState = "↖️"
        }
        
        // -100
        if(calcMappedRoll <= -100){
            mappedRoll = -100
            dirLabelState = "⬅️"
        }
        
        return Int(mappedRoll)
    }
    
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        let roll = degrees(radians: attitude.roll)
        let NewDirection = mapDir(roll: roll)
        
        if(CONNECTED){
            if(NewDirection != dirState){
                dirState = NewDirection
                socket.emit("direction", dirState)
                dirLabel.setText("\(dirLabelState) km/h")
            }
        }
    }
    
}

// CROWN 👑
extension MiniInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        calcNewSpeedState = calcNewSpeedState + Int(rotationalDelta*100)
        
        var NewSpeedState = 0
        // 100 +
        if(calcNewSpeedState >= 100){
            NewSpeedState = 100
            calcNewSpeedState = 100
        }
        
        // 80
        if(calcNewSpeedState < 100 && calcNewSpeedState >= 80){
            NewSpeedState = 80
        }
        
        // 60
        if(calcNewSpeedState < 80 && calcNewSpeedState >= 60){
             NewSpeedState = 60
        }
        
        // 30
        if(calcNewSpeedState < 60 && calcNewSpeedState >= 30){
            NewSpeedState = 30
        }
        
        // 0
        if(calcNewSpeedState < 30 && calcNewSpeedState > -30){
            NewSpeedState = 0
        }
        
        
        // -30
        if(calcNewSpeedState <= -30 && calcNewSpeedState > -60){
            NewSpeedState = -30
        }
        
        // -60
        if(calcNewSpeedState <= -60 && calcNewSpeedState > -80){
            NewSpeedState = -60
        }
        
        
        // -80
        if(calcNewSpeedState <= -80 && calcNewSpeedState > -100){
            NewSpeedState = -80
        }
        
        // - 100
        if(calcNewSpeedState <= -100){
            NewSpeedState = -100
            calcNewSpeedState = -100
        }
        
        if(CONNECTED){
            if(NewSpeedState != speedState){
                speedState = NewSpeedState
                socket.emit("speed", speedState)
                speedLabel.setText("\(speedState) km/h")
            }
        }
        print("SpeedState= \(speedState), NewSpeedState= \(NewSpeedState), calcNewSpeedState= \(calcNewSpeedState)")
    }
}
