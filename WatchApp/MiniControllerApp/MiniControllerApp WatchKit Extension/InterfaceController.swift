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

let manager = SocketManager(socketURL: URL(string: "http://mini.local:8080")!, config: [.log(true), .compress])
let socket = manager.defaultSocket
let streamUrl = "http://mini.local:1337/stream.mjpg"

var lightState = false
var speedState = 0
let dirState = 0

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var WKLifeStream: WKInterfaceImage!
    
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
        
        // Stream
        _ = self.WKLifeStream.setImageWithUrl(url: streamUrl, scale: 1.0)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // UI
    @IBAction func direction_left() {
        socket.emit("direction", -100)
    }
    
    @IBAction func direction_right() {
        socket.emit("direction", 100)
    }
    
    @IBAction func speed_forward() {
        socket.emit("speed", 100)
    }

    @IBAction func speed_backwards() {
        socket.emit("speed", -100)
    }
    
    @IBAction func horn() {
        socket.emit("horn", true)
    }
    
    @IBAction func light() {
        lightState = !lightState
        socket.emit("light", lightState)
    }
    
}

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        
        let reqUrl = NSURL(string: url)! as URL
        var req = URLRequest(url: reqUrl)
        req.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async {
                    self.setImage(image)
                }
            }
            }.resume()
        
        return self
    }
}
