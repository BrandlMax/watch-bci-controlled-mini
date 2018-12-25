//
//  TouchInterface.swift
//  MiniControllerApp WatchKit Extension
//
//  Created by Maximilian Brandl on 25.12.18.
//  Copyright © 2018 Maximilian Brandl. All rights reserved.
//

import WatchKit
import Foundation

var oSpeedTest = 0

class TouchInterface: WKInterfaceController {

    @IBOutlet weak var speedLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Touch!")
        
        // DELEGATE 👑
        crownSequencer.delegate = self as WKCrownDelegate
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // START FOCUS 👑
        crownSequencer.focus()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}


// CROWN 👑
extension TouchInterface: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print("\(rotationalDelta*100)")
        oSpeedTest = oSpeedTest + Int((rotationalDelta*100))
        if(oSpeedTest > 100){
            oSpeedTest = 100
        }
        
        if(oSpeedTest < -100){
            oSpeedTest = -100
        }
        speedLabel.setText("\(oSpeedTest)")
    }
}
