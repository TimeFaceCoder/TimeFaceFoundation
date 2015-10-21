//
//  TFModel.h
//  TimeFace
//
//  Created by zguanyu on 9/23/15.
//  right © 2015 timeface. All rights reserved.
//

#import <Realm/RLMObject.h>
#import <Realm/RLMArray.h>

@interface TFModel : RLMObject

- (id)initWithDictionary:(NSDictionary*)dict error:(NSError**)error;


- (NSDictionary*)toDictionary;

@end
