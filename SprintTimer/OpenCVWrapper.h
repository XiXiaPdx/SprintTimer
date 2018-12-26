//
//  OpenCVWrapper.h
//  SprintTimer
//
//  Created by Xi Xia on 12/22/18.
//  Copyright © 2018 Xi Xia. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "OpenCVWrapper.h"

#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

@interface OpenCVWrapper : NSObject
+(UIImage *)ImageFromBuffer:(CMSampleBufferRef)buffer;
+(NSMutableDictionary *)MotionMask:(CMSampleBufferRef)buffer
  :(int)frameNumber;

@end

#endif /* OpenCVWrapper_h */
