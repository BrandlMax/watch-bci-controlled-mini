//
//  GyroInterface.swift
//  MiniControllerApp
//
//  Created by Maximilian Brandl on 23.12.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import WatchKit
import CoreMotion
import Foundation


//⌚️🕹
let OmotionManager = CMMotionManager()

class GyroInterface: WKInterfaceController {
    
    @IBOutlet weak var GyroLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("Gyro")
        
        //⌚️🕹
        if OmotionManager.isDeviceMotionAvailable {
            print("Device Available")
            OmotionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
                    } else {
                        //handle the error
                    }
            })
            OmotionManager.deviceMotionUpdateInterval = 0.1
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    //⌚️🕹
    func degrees(radians:Double) -> Double {
        return 180 / Double.pi * radians
    }
    
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        let roll = degrees(radians: attitude.roll)
        let pitch = degrees(radians: attitude.pitch)
        let yaw = degrees(radians: attitude.yaw)
        
        var gyroState = "Roll: \(roll), Pitch: \(pitch), Yaw: \(yaw)"
        print(gyroState)
        GyroLabel.setText(gyroState)
    }
    
}
