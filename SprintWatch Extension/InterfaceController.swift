//
//  InterfaceController.swift
//  SprintWatch Extension
//
//  Created by Xi Xia on 12/29/18.
//  Copyright © 2018 Xi Xia. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var X_Accel_Label: WKInterfaceLabel!
  
  let motionManager: CMMotionManager = CMMotionManager()
  let queue = OperationQueue()
  let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
  let sampleInterval = 0.01
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
      guard motionManager.isAccelerometerAvailable else {
        print("CM Motion manager not available")
        return
      }
      
      motionManager.accelerometerUpdateInterval = sampleInterval
      motionManager.startAccelerometerUpdates(to: .main) {
        [weak self] (data, error) in
        guard let data = data, error == nil else {
          return
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let num = NSNumber(value: data.acceleration.x)
        let finalNumber = numberFormatter.string(from: num)

       
        self?.X_Accel_Label.setText(finalNumber)
        
       
        
        // ...
      }
      
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
