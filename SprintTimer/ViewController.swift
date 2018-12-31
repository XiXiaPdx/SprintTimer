//
//  ViewController.swift
//  SprintTimer
//
//  Created by Xi Xia on 12/16/18.
//  Copyright © 2018 Xi Xia. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity


class ViewController: UIViewController {
  @IBOutlet weak var videoPreviewView: UIView!
  @IBOutlet weak var outputLog: UILabel!
  @IBOutlet weak var blackWhitePreview: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  
  var session: WCSession?
  var watchStartTime: Date?

  var captureSession: AVCaptureSession?
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var captureDeviceInput: AVCaptureDeviceInput?
  var videoOutput: AVCaptureVideoDataOutput?
  var frameCounter: Int32 = 0
  var imageAndTime: NSMutableDictionary?
  var captureDevice: AVCaptureDevice?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if WCSession.isSupported() {
      session = WCSession.default
      session?.delegate = self
      session?.activate()
    }
    
    processApplicationContext()
  
    //should use discovery session instead, seems more robust
    captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
    
    // now check if this device is available when setting input
    do{
       captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice!)
    }catch{
      print("Shit, no camera")
    }
    
    //initialize captureSession
    captureSession = AVCaptureSession()
    captureSession?.sessionPreset = AVCaptureSession.Preset.vga640x480
    videoOutput = AVCaptureVideoDataOutput()
    videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_32BGRA] as [String : Any]

    videoOutput?.alwaysDiscardsLateVideoFrames = true
    
    videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label:"sample buffer"))
    captureSession?.addInput(captureDeviceInput!)
    
    //set frame rate
    do{
      try captureDevice?.lockForConfiguration()
      captureDevice?.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 60)
      captureDevice?.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 60)
      captureDevice?.unlockForConfiguration()
    } catch {
      return
    }


    captureSession?.addOutput(videoOutput!)
    
    
    //set up preview layer to see video
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

    // sets the videopreviewLayer size to be bound by the view I created.
    
    videoPreviewLayer?.frame = videoPreviewView.bounds
    
    //this shows the preview image on the screen
    videoPreviewView.layer.addSublayer(videoPreviewLayer!)
    
    // start capturing
    captureSession?.startRunning()
  }
  
  
  @IBAction func restartCameraTapped(_ sender: Any) {
    frameCounter = 0
    captureSession?.startRunning()
  }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    frameCounter += 1
    
//    image = OpenCVWrapper.image(from: sampleBuffer)
    imageAndTime = OpenCVWrapper.motionMask(sampleBuffer, frameCounter) as NSMutableDictionary?

    DispatchQueue.main.async {
      self.outputLog.text = String("Frame # \(self.frameCounter)")
      
//      let imageView = UIImageView(image: self.image)
//      imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 200))
      self.blackWhitePreview.image = self.imageAndTime?.value(forKey: "image") as! UIImage
      let checkMotion = self.imageAndTime?.value(forKey: "time")
      if checkMotion is NSNull {
        return
      } else {
        self.captureSession?.stopRunning()
        guard let watchStartTime = self.watchStartTime else {
          print("watchStartTime is nil")
          return
        }
        let difference =         (checkMotion as! Date).timeIntervalSince(watchStartTime)
        
        self.timeLabel.text = String(format: "%.3f", difference)

      }
    }
  }
}

extension ViewController: WCSessionDelegate {
  
  func processApplicationContext() {
    if let watchContext = session?.receivedApplicationContext as? [String : Date] {
      watchStartTime = watchContext["startTime"]
    }
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    DispatchQueue.main.async() {
      self.processApplicationContext()
    }
  }
  
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    
  }
  
  
}




