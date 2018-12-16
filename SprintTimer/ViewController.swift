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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //should use discovery session instead and check for available cameras first
    let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
  }


}

