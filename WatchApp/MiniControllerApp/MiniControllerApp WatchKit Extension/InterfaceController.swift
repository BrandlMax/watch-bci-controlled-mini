//
//  InterfaceController.swift
//  MiniControllerApp WatchKit Extension
//
//  Created by Maximilian Brandl on 16.10.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import WatchKit
import Foundation

import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session : WCSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //CONNECTIVITY
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
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
