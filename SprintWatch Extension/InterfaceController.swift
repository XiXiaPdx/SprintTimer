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
import WatchConnectivity


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var X_Accel_Label: WKInterfaceLabel!
  @IBOutlet var Y_Accel_Label: WKInterfaceLabel!
  @IBOutlet var timeStampLabel: WKInterfaceLabel!
  
  @IBOutlet var restartButton: WKInterfaceButton!
  let session = WCSession.default

  let motionManager: CMMotionManager = CMMotionManager()
  let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
  let sampleInterval = 0.01
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
      
      //connectivity session
      session.delegate = self
      session.activate()
      
      guard motionManager.isAccelerometerAvailable else {
        print("CM Motion manager not available")
        return
      }
      
      motionManager.accelerometerUpdateInterval = sampleInterval
      startMonitoring()
      
    }
  
  
  func startMonitoring () {
    restartButton.setHidden(true)
    X_Accel_Label.setText("waiting...")
    Y_Accel_Label.setText("waiting...")
    timeStampLabel.setText("Ready to sprint!")

    motionManager.startDeviceMotionUpdates(to: .main) {
      [weak self] (data, error) in
      guard let data = data, error == nil else {
        self?.X_Accel_Label.setText("motion update err")
        return
      }
      
      let xAccel = data.userAcceleration.x
      let yAccel = data.userAcceleration.y
      
      if xAccel > 4.0 || yAccel > 4.0 {
        
        // stop motion sension
        self?.motionManager.stopDeviceMotionUpdates()
        self?.timeStampLabel.setText("You're sprinting!")
        
        
        self?.X_Accel_Label.setText("X: \(String(format: "%.2f", xAccel))")
        self?.Y_Accel_Label.setText("Y: \(String(format: "%.2f", yAccel))")
        
//        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "mm:ss:SS"
        let date = Date()
//        let dateString = dateFormatter.string(from: date)
//        self?.timeStampLabel.setText(dateString)
        
        //update to phone
        if let validSession = self?.session {
          let watchContext = ["startTime": date]
          do {
            try validSession.updateApplicationContext(watchContext)
            
          } catch {
            print("Something went wrong")
          }
        }
      }
    }
  }
    
  @IBAction func restartTapped() {
    startMonitoring()
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

extension InterfaceController: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func processApplicationContext() {
    if let phoneContext = session.receivedApplicationContext as? [String : TimeInterval] {
      let calculatedSprintTime = phoneContext["calculatedTime"]
      let sprintTimeAsString = String(format: "%.3f", calculatedSprintTime!)
      timeStampLabel.setText("Time! \(sprintTimeAsString)")
    }
    restartButton.setHidden(false)
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    DispatchQueue.main.async() {
      self.processApplicationContext()
    }
  }
  
  
}
