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
  UIImageToMat(image, mat);
  
  cv::Mat gray;
  cv::cvtColor(mat, gray, CV_RGB2GRAY);
  
  cv::Mat bin;
  cv::threshold(gray, bin, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
  
  UIImage *binImg = MatToUIImage(bin);
  return binImg;
}

@end


