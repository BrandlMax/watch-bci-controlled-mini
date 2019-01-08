//
//  ViewController.swift
//  MiniControllerApp
//
//  Created by Maximilian Brandl on 16.10.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import UIKit
import SocketIO

let manager = SocketManager(socketURL: URL(string: "http://mini.local:3000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class ViewController: UIViewController {
    
    
    // UI
    @IBOutlet weak var imageView: UIImageView!
    
    var stream: MJPEGStreamLib!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // SOCKET
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            // socket.emit("speed", 255)
        }
        
        socket.connect()
        
        // Set the ImageView to the stream object
        stream = MJPEGStreamLib(imageView: imageView)
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
    
}
