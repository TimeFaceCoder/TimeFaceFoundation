//
//  InputLimit.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "InputLimit.h"

#define RUNTIME_ADD_PROPERTY(propertyName)      \
-(id)valueForUndefinedKey:(NSString *)key {     \
if ([key isEqualToString:propertyName]) {   \
return objc_getAssociatedObject(self, key.UTF8String);  \
}                                           \
return nil;                                 \
}                                               \
-(void)setValue:(id)value forUndefinedKey:(NSString *)key { \
if ([key isEqualToString:propertyName]) {               \
objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN); \
}                                                       \
}

#define IMPLEMENT_PROPERTY(className) \
@implementation className (Limit) RUNTIME_ADD_PROPERTY(PROPERTY_NAME) @end

IMPLEMENT_PROPERTY(UITextField)
IMPLEMENT_PROPERTY(UITextView)


@implementation InputLimit

+(void) load {
    [super load];
    [InputLimit sharedInstance];
}


+(InputLimit *) sharedInstance {
    static InputLimit *g_limitInput;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        g_limitInput = [[InputLimit alloc] init];
        g_limitInput.enableLimitCount = YES;
    });
    
    return g_limitInput;
}

-(id) init {
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidChange:) name:UITextFieldTextDidChangeNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object: nil];
    }
    
    return self;
}


- (NSInteger)charNumber:(NSString*)strtemp
{
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

- (NSString *)subString:(NSString *)str length:(NSInteger)length {
    
    if ([self charNumber:str] > length) {
        NSString* tmp;
        for (NSInteger i = str.length; i > 0; i--) {
            tmp = [str substringToIndex:i];
            if ([self charNumber:tmp] <= length) {
                return tmp;
                break;
            }
        }
    }
    
    return str;
}



-(void)textFieldViewDidChange:(NSNotification*)notification {
    if (!self.enableLimitCount) return;
    UITextField *textField = (UITextField *)notification.object;
    
    NSNumber *number = [textField valueForKey:PROPERTY_NAME];
    NSInteger length = [self charNumber:textField.text];
    if (number && textField.markedTextRange == nil) {
        if (length > [number integerValue]) {
            textField.text = [self subString:textField.text length:[number integerValue]];
        }
    }
}


-(void) textViewDidChange: (NSNotification *) notificaiton {
    if (!self.enableLimitCount) return;
    UITextView *textView = (UITextView *)notificaiton.object;
    
    NSNumber *number = [textView valueForKey:PROPERTY_NAME];
    if (number && textView.text.length > [number integerValue] && textView.markedTextRange == nil) {
        textView.text = [textView.text substringWithRange: NSMakeRange(0, [number integerValue])];
    }
}


@end
