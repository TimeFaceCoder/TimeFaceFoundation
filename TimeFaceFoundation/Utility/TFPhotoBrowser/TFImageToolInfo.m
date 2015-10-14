//
//  TFImageToolInfo.m
//  TimeFaceV2
//
//  Created by Melvin on 1/29/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFImageToolInfo.h"

@interface TFImageToolInfo(){
    
}


@property (nonatomic, strong) NSString *toolName;
@property (nonatomic, strong) NSArray *subtools;

@end

@implementation TFImageToolInfo

- (void)setObject:(id)object forKey:(NSString *)key inDictionary:(NSMutableDictionary*)dictionary
{
    if(object){
        dictionary[key] = object;
    }
}

- (NSDictionary*)descriptionDictionary
{
    NSMutableArray *array = [NSMutableArray array];
    for(TFImageToolInfo *sub in self.sortedSubtools){
        [array addObject:sub.descriptionDictionary];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self setObject:self.toolName forKey:@"toolName"  inDictionary:dict];
    [self setObject:self.title forKey:@"title" inDictionary:dict];
    [self setObject:((self.available)?@"YES":@"NO") forKey:@"available" inDictionary:dict];
    [self setObject:@(self.dockedNumber) forKey:@"dockedNumber" inDictionary:dict];
    [self setObject:self.iconImagePath forKey:@"iconImagePath" inDictionary:dict];
    [self setObject:array forKey:@"subtools" inDictionary:dict];
    if(self.optionalInfo){
        [self setObject:self.optionalInfo forKey:@"optionalInfo" inDictionary:dict];
    }
    
    return dict;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@", self.descriptionDictionary];
}

- (NSString*)toolTreeDescriptionWithSpace:(NSString*)space
{
    NSString *str = [NSString stringWithFormat:@"%@%@\n", space, self.toolName];
    
    space = [NSString stringWithFormat:@"    %@", space];
    for(TFImageToolInfo *sub in self.sortedSubtools){
        str = [str stringByAppendingFormat:@"%@", [sub toolTreeDescriptionWithSpace:space]];
    }
    return str;
}

- (NSString*)toolTreeDescription
{
    return [NSString stringWithFormat:@"\n%@", [self toolTreeDescriptionWithSpace:@""]];
}

- (UIImage*)iconImage
{
    return [UIImage imageNamed:self.iconImagePath];
}

- (NSString*)toolName
{
    if([_toolName isEqualToString:@"_CLImageEditorViewController"]){
        return @"CLImageEditor";
    }
    return _toolName;
}

- (NSArray*)sortedSubtools
{
    self.subtools = [self.subtools sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGFloat dockedNum1 = [obj1 dockedNumber];
        CGFloat dockedNum2 = [obj2 dockedNumber];
        
        if(dockedNum1 < dockedNum2){ return NSOrderedAscending; }
        else if(dockedNum1 > dockedNum2){ return NSOrderedDescending; }
        return NSOrderedSame;
    }];
    return self.subtools;
}

- (TFImageToolInfo*)subToolInfoWithToolName:(NSString*)toolName recursive:(BOOL)recursive
{
    TFImageToolInfo *result = nil;
    
    for(TFImageToolInfo *sub in self.subtools){
        if([sub.toolName isEqualToString:toolName]){
            result = sub;
            break;
        }
        if(recursive){
            result = [sub subToolInfoWithToolName:toolName recursive:recursive];
            if(result){
                break;
            }
        }
    }
    
    return result;
}


@end
