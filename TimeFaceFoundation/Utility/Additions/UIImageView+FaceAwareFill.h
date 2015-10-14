//
//  UIImageView+FaceAwareFill.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TNMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FaceAwareFill)

- (void) faceAwareFill;

- (NSArray *) getAllFaceRects;

@end
