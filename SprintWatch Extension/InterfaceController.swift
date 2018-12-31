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
  @IBOutlet var Y_Accel_Label: WKInterfaceLabel!
  @IBOutlet var Z_Accel_Label: WKInterfaceLabel!


  
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
      motionManager.startDeviceMotionUpdates(to: .main) {
        [weak self] (data, error) in
        guard let data = data, error == nil else {
          return
        }
        
        let xAccel = data.userAcceleration.x
        let yAccel = data.userAcceleration.y
        let zAccel = data.userAcceleration.z
       
       
        
        
        if xAccel > 2.0 || yAccel > 2.0 || zAccel > 2.0  {
          self?.X_Accel_Label.setText("X: \(String(format: "%.2f", xAccel))")
          self?.Y_Accel_Label.setText("Y: \(String(format: "%.2f", yAccel))")
          self?.Z_Accel_Label.setText("Z: \(String(format: "%.2f", zAccel))")
        }
    
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
