//
//  ViewController.swift
//  MiniControllerApp
//
//  Created by Maximilian Brandl on 16.10.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import UIKit
import SocketIO

let manager = SocketManager(socketURL: URL(string: "http://10.100.50.13:3000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class ViewController: UIViewController {
    
    // UI
    @IBOutlet weak var messages: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    // UI
    
    @IBAction func sendTest(_ sender: Any) {
        print("TEST!")
    }
    
}
