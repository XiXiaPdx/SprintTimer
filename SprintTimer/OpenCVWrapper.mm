//
//  OpenCVWrapper.m
//  SprintTimer
//
//  Created by Xi Xia on 12/22/18.
//  Copyright © 2018 Xi Xia. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation OpenCVWrapper : NSObject




+(UIImage *)ConvertImage:(UIImage *)image {
  cv::Mat mat;
  
  // motion detection stuff
  cv::Mat fgMask;
  cv::Ptr<cv::BackgroundSubtractor> pBackSub;
  
  pBackSub = cv::createBackgroundSubtractorMOG2();

  UIImageToMat(image, mat);
  
  pBackSub->apply(mat, fgMask);
  
//  cv::Mat gray;
//  cv::cvtColor(mat, gray, CV_RGB2GRAY);
//
//  cv::Mat bin;
//  cv::threshold(gray, bin, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
  
  UIImage *binImg = MatToUIImage(fgMask);
  return binImg;
}

@end


