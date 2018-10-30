//
//  ViewController.swift
//  MiniControllerApp
//
//  Created by Maximilian Brandl on 16.10.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import UIKit
import SocketIO
import WatchConnectivity

let manager = SocketManager(socketURL: URL(string: "http://10.100.50.13:3000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class ViewController: UIViewController, WCSessionDelegate {
    
    
    var session : WCSession!
    
    // UI
    @IBOutlet weak var messages: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // CONNECTIVITY
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
            
            watchConnectionStatus()
        }
        
        // SOCKET
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("test") { data, ack in
                print(data)
                socket.emit("test2", ["amount": 100])
        }
        
        socket.connect()
    }
    
    func watchConnectionStatus(){
        
        print("isPaired",session.isPaired)
        print("session.isWatchAppInstalled",session.isWatchAppInstalled)
        print(session.watchDirectoryURL as Any)
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        watchConnectionStatus()
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("MESSAGE!!!!! ⌚️")
        self.messages.text = String(describing: message)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // UI
    
    @IBAction func sendTest(_ sender: Any) {
        print("TEST!")
        print("isPaired",session.isPaired)
        print("session.isWatchAppInstalled",session.isWatchAppInstalled)
        print(session.watchDirectoryURL as Any)
        session.sendMessage(["message":"My Messege"], replyHandler: nil, errorHandler: nil)
    }
    
}
