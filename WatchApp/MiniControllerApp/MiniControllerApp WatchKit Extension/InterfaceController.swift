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

let manager = SocketManager(socketURL: URL(string: "http://10.100.50.13:3000")!, config: [.log(true), .compress])
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
            socket.emit("test Watch", ["amount": 100])
        }
        
        socket.connect()
        
        let url = URLRequest(url: URL(string: "http://10.100.50.13:3000")!)
        let session = URLSession.shared
        session.dataTask(with: url){data, response, err in
            
            print(response, err)
            
        }.resume()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // UI
    @IBAction func pressedSpeed() {
        print("Speed")
    }
}
