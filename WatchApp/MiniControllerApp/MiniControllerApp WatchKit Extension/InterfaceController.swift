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

import WatchConnectivity

let manager = SocketManager(socketURL: URL(string: "http://10.100.50.13:3000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("--------------**************😸*************---------------")
        
        // SOCKET
        socket.on(clientEvent: .connect) {data, ack in
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
        
        //CONNECTIVITY
//        if WCSession.isSupported() {
//            session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // CONNECTIVITY
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        
        let message = message["message"] as! String
        print(message)
        
        replyHandler(["msg":"successfully sent from iPhone"])
        
    }
    
    // UI

    @IBAction func pressedSpeed() {
        print("Speed")
    }
}
