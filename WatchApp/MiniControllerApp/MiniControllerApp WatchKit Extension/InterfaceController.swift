//
//  InterfaceController.swift
//  MiniControllerApp WatchKit Extension
//
//  Created by Maximilian Brandl on 16.10.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import WatchKit
import Foundation
import SocketIO

let manager = SocketManager(socketURL: URL(string: "http://192.168.0.24:3000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("--------------**************⌚️*************---------------")
        
        // SOCKET
        socket.on(clientEvent: .connect) {  data, ack in
            print("socket connected")
        }
        
        socket.on("test") { data, ack in
            print(data)
            
        }
        
        socket.connect()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // UI
    @IBAction func direction_left() {
        socket.emit("direction", -255)
    }
    
    @IBAction func direction_right() {
        socket.emit("direction", 255)
    }
    
    @IBAction func speed_forward() {
        socket.emit("speed", 255)
    }

    @IBAction func speed_backwards() {
        socket.emit("speed", -255)
    }
    
    @IBAction func horn() {
        socket.emit("horn", true)
    }
    
    @IBAction func light() {
        socket.emit("light", true)
    }
    
    
    
}
