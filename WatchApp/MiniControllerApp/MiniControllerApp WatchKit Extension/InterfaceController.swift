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

let Omanager = SocketManager(socketURL: URL(string: "http://mini.local:8080")!, config: [.log(true), .compress])
let Osocket = manager.defaultSocket


let OstreamUrl = "http://mini.local:1337/stream.mjpg"


var OlightState = false
var OspeedState = 0
let OdirState = 0

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var ImageViewStream: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        print("--------------**************📺*************---------------")
        ImageViewStream.setImageWithUrl(url: OstreamUrl, scale: 2.0)
        
        print("--------------**************⌚️*************---------------")
        
        // SOCKET
        Osocket.on(clientEvent: .connect) {  data, ack in
            print("socket connected")
        }
        
        Osocket.on("test") { data, ack in
            print(data)
            
        }
        
        Osocket.connect()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // UI
    @IBAction func direction_left() {
        Osocket.emit("direction", -100)
    }
    
    @IBAction func direction_right() {
        Osocket.emit("direction", 100)
    }
    
    @IBAction func speed_forward() {
        Osocket.emit("speed", 100)
    }

    @IBAction func speed_backwards() {
        Osocket.emit("speed", -100)
    }
    
    @IBAction func horn() {
        Osocket.emit("horn", true)
    }
    
    @IBAction func light() {
        print("LIGHT DOWN")
        OlightState = !OlightState
        Osocket.emit("light", OlightState)
    }
    
}

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        
        let request = URLRequest(url: URL(string: url)! as URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
