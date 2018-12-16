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
  
  var captureSession: AVCaptureSession?
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var captureDeviceInput: AVCaptureDeviceInput?
  
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
    captureSession?.addInput(captureDeviceInput!)
    
    //set up preview layer to see video
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

    // full screen, nothing to do with size of videoPreviewView on Storyboard
    videoPreviewLayer?.frame = view.layer.bounds
    
    /*
     can change the size of the frame
     
    videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
    */
    
    videoPreviewView.layer.addSublayer(videoPreviewLayer!)
    
    // start capturing
    captureSession?.startRunning()
  }


}

