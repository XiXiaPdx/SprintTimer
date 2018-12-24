//
//  OpenCVWrapper.m
//  SprintTimer
//
//  Created by Xi Xia on 12/22/18.
//  Copyright © 2018 Xi Xia. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@implementation OpenCVWrapper : NSObject

// this is much faster than buffer -> image -> mat -> image.  But memory issue somewhere causing crash

+(UIImage *)ImageFromBuffer:(CMSampleBufferRef)buffer {
  

  CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(buffer);

  CVPixelBufferLockBaseAddress( pixelBuffer, 0 );

  //Processing here
  int bufferWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
  int bufferHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
  unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);

  //put buffer in open cv, no memory copied
  cv::Mat mat = cv::Mat(bufferHeight,bufferWidth,CV_8UC4,pixel,CVPixelBufferGetBytesPerRow(pixelBuffer));

  //End processing
  CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );

  
  cv::Mat matGray;
  cvtColor(mat, matGray, CV_BGR2GRAY);

  //Convert Mat to UIImage

  UIImage *grayImg = MatToUIImage(matGray);
  
//  UIImage *fakeImg =[[UIImage alloc] init];
  return grayImg;
}

+(UIImage *)MotionMask:(CMSampleBufferRef)buffer {
  
  //add code for converting buffer to mat here
  CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(buffer);
  
  CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
  cv::Mat frame, fgmask;

  //Processing here
  int bufferWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
  int bufferHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
  unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
  
  //put buffer in open cv, no memory copied
   frame = cv::Mat(bufferHeight,bufferWidth,CV_8UC4,pixel,CVPixelBufferGetBytesPerRow(pixelBuffer));
  
  cv::Ptr<cv::BackgroundSubtractor> pBackSub;
  pBackSub = cv::createBackgroundSubtractorMOG2();
 
  
  pBackSub->apply (frame, fgmask);
  
  //End processing
  CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );

  UIImage *image = MatToUIImage(fgmask);
  return image;
}


@end


