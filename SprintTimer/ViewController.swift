//
//  ViewController.swift
//  SprintTimer
//
//  Created by Xi Xia on 12/16/18.
//  Copyright © 2018 Xi Xia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  @IBOutlet weak var videoPreviewView: UIView!
  @IBOutlet weak var outputLog: UILabel!
  
  var captureSession: AVCaptureSession?
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var captureDeviceInput: AVCaptureDeviceInput?
  var videoOutput: AVCaptureVideoDataOutput?
  var frameCounter: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //should use discovery session instead, seems more robust
    let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
    
    // now check if this device is available when setting input
    do{
       captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice!)
    }catch{
      print("Shit, no camera")
    }
    
    //initialize captureSession
    captureSession = AVCaptureSession()
    videoOutput = AVCaptureVideoDataOutput()
    videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_32BGRA] as [String : Any]

    videoOutput?.alwaysDiscardsLateVideoFrames = true
    
    videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label:"sample buffer"))
    captureSession?.addInput(captureDeviceInput!)
    captureSession?.addOutput(videoOutput!)
    
    //set up preview layer to see video
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

    // sets the videopreviewLayer size to be bound by the view I created.
    videoPreviewLayer?.frame = videoPreviewView.layer.bounds
    
    /*
     can change the size of the frame
     
    videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
    */
    
    videoPreviewView.layer.addSublayer(videoPreviewLayer!)
    
    // start capturing
    captureSession?.startRunning()
  }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    frameCounter += 1
    DispatchQueue.main.async {
      self.outputLog.text = String("Frame # \(self.frameCounter)")
    }
  }

}

