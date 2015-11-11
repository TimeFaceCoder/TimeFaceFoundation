//
//  UIImage+Letters.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIImage+Letters.h"
#import "TFDefaultStyle.h"
#import "TimeFaceFoundationConst.h"

@implementation UIImage (Letters)


+ (UIImage *)imageWithString:(NSString *)string size:(CGSize)size {
   return [self imageWithString:string size:size color:nil];
}

+ (UIImage *)imageWithString:(NSString *)string size:(CGSize)size  color:(UIColor *)color {
    UIView *tempView = [[UIView alloc] init];
    tempView.tfSize = size;
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:tempView.bounds];
    letterLabel.textAlignment = NSTextAlignmentCenter;
    letterLabel.backgroundColor = [UIColor clearColor];
    letterLabel.textColor = [UIColor whiteColor];
    letterLabel.adjustsFontSizeToFitWidth = YES;
    letterLabel.minimumScaleFactor = 8.0f / 65.0f;
    letterLabel.font = [self fontForLetterLabel:size.width];
    [tempView addSubview:letterLabel];
    
    NSMutableString *displayString = [NSMutableString stringWithString:@""];
    
    NSArray *words = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([words count]) {
        NSString *firstWord = words[0];
        if ([firstWord length]) {
            [displayString appendString:[firstWord substringWithRange:NSMakeRange(0, 1)]];
        }
        
        if ([words count] >= 2) {
            NSString *lastWord = words[[words count] - 1];
            if ([lastWord length]) {
                [displayString appendString:[lastWord substringWithRange:NSMakeRange(0, 1)]];
            }
        }
    }
    letterLabel.text = [displayString uppercaseString];
    
    //check cache
    if ([[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"image_letter_%@",displayString]]) {
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"image_letter_%@",displayString]];
        color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    //
    // Set the background color
    //
    tempView.backgroundColor = color ? color : [self randomColor];
    
    if (!color) {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:tempView.backgroundColor];

        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:[NSString stringWithFormat:@"image_letter_%@",displayString]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //
    // Return an image instance of the temporary view
    //
    return [self imageSnapshotFromView:tempView size:size];
}


#pragma mark - Helpers

+ (UIFont *)fontForLetterLabel:(CGFloat)width {
    return [UIFont systemFontOfSize:width * 0.48];
}

+ (UIColor *)randomColor {
    float red = 0.0;
    while (red < 0.1 || red > 0.84) {
        red = drand48();
    }
    
    float green = 0.0;
    while (green < 0.1 || green > 0.84) {
        green = drand48();
    }
    
    float blue = 0.0;
    while (blue < 0.1 || blue > 0.84) {
        blue = drand48();
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIImage *)imageSnapshotFromView:(UIView *)inputView size:(CGSize)size {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width = floorf(size.width * scale) / scale;
    size.height = floorf(size.height * scale) / scale;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, 0);
    
    [inputView.layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

+ (UIImage *)tf_imageNamed:(NSString *)name {
    NSLog(@"imageNamed hack");
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
}



@end
