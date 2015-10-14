//
//  TFImageToolInfo.h
//  TimeFaceV2
//
//  Created by Melvin on 1/29/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFImageToolInfo : NSObject

@property (nonatomic, readonly) NSString            *toolName;
@property (nonatomic, strong  ) NSString            *title;
@property (nonatomic, assign  ) BOOL                available;
@property (nonatomic, assign  ) CGFloat             dockedNumber;
@property (nonatomic, strong  ) NSString            *iconImagePath;
@property (nonatomic, readonly) UIImage             *iconImage;
@property (nonatomic, readonly) NSArray             *subtools;
@property (nonatomic, strong  ) NSMutableDictionary *optionalInfo;


- (NSString*)toolTreeDescription;
- (NSArray*)sortedSubtools;

- (TFImageToolInfo*)subToolInfoWithToolName:(NSString*)toolName recursive:(BOOL)recursive;



@end
