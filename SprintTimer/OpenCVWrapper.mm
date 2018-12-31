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

//the "varThreshold" 100.0

cv::Ptr<cv::BackgroundSubtractor> pBackSub = cv::createBackgroundSubtractorMOG2(1,25.0,false);

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

+(NSMutableDictionary *)MotionMask:(CMSampleBufferRef)buffer :(int)frameNumber {
  
  NSMutableDictionary *imageAndTime = [NSMutableDictionary dictionary];
  //add code for converting buffer to mat here
  CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(buffer);
  
  CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
  cv::Mat frame, fgmask, bgMask;

  //Processing here
  int bufferWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
  int bufferHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
  unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
  
  //put buffer in open cv, no memory copied
   frame = cv::Mat(bufferHeight,bufferWidth,CV_8UC4,pixel,CVPixelBufferGetBytesPerRow(pixelBuffer));
  
  //End processing
  CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
  
  //Background subtraction processing
  //the 0.1 is "learning rate". If it was 0, it would never learn and change the background.  Meaning, whatever was the first frame is assumed to be always the background and never changes. Maximum value is 1, which means every frame is a new background.
  
  pBackSub->apply(frame, fgmask, 0.5);
  
  //this seemed to make background black, foreground white
  cv::threshold(fgmask, fgmask, 10, 255, CV_THRESH_BINARY);
  
  
  UIImage *image = MatToUIImage(fgmask);
  //set the image in the dictionary for return
  [imageAndTime setObject:image forKey:@"image"];

  //checking for motion by counting white pixels
  
  if(frameNumber > 30){
    int whitePixelCount = cv::countNonZero(fgmask);
    if (whitePixelCount > (bufferWidth * bufferHeight)/4) {
      
      //set the current time into dictionary for return
      NSDate * now = [NSDate date];
//      NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//      [outputFormatter setDateFormat:@"HH:mm:ss:SS"];
//      NSString *newDateString = [outputFormatter stringFromDate:now];
      [imageAndTime setObject:now  forKey:@"time"];
      return imageAndTime;
//      NSLog(@"newDateString %@", newDateString);
      //    NSLog(@"%i", whitePixelCount);

    }
  }
  
//  NSString *noMotion = @"0";
  [imageAndTime setObject:[NSNull null]  forKey:@"time"];
  return imageAndTime;
}

@end


