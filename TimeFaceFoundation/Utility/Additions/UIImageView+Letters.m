//
//  UIImageView+Letters.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIImageView+Letters.h"
@implementation UIImageView (Letters)

- (void)setImageWithString:(NSString *)string {
    [self setImageWithString:string color:nil];
}

- (void)setImageWithString:(NSString *)string color:(UIColor *)color {
    
    //
    // Set up a temporary view to contain the text label
    //
    UIView *tempView = [[UIView alloc] initWithFrame:self.bounds];
    
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:self.bounds];
    letterLabel.textAlignment = NSTextAlignmentCenter;
    letterLabel.backgroundColor = [UIColor clearColor];
    letterLabel.textColor = [UIColor whiteColor];
    letterLabel.adjustsFontSizeToFitWidth = YES;
    letterLabel.minimumScaleFactor = 8.0f / 65.0f;
    letterLabel.font = [self fontForLetterLabel];
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
    
    //
    // Set the background color
    //
    tempView.backgroundColor = color ? color : [self randomColor];
    
    //
    // Return an image instance of the temporary view
    //
    self.image = [self imageSnapshotFromView:tempView];
}

#pragma mark - Helpers

- (UIFont *)fontForLetterLabel {
    return [UIFont systemFontOfSize:CGRectGetWidth(self.bounds) * 0.48];
}

- (UIColor *)randomColor {
    
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

- (UIImage *)imageSnapshotFromView:(UIView *)inputView {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize size = self.bounds.size;
    if (self.contentMode == UIViewContentModeScaleToFill ||
        self.contentMode == UIViewContentModeScaleAspectFill ||
        self.contentMode == UIViewContentModeScaleAspectFit ||
        self.contentMode == UIViewContentModeRedraw)
    {
        size.width = floorf(size.width * scale) / scale;
        size.height = floorf(size.height * scale) / scale;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -self.bounds.origin.x, -self.bounds.origin.y);
    
    [inputView.layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

@end
