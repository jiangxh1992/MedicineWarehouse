//
//  ParamBase.m
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/28/16.
//
//

#import "ParamBase.h"

@implementation ParamBase

- (id)init {
    if ([super init]) {
        _type = 0;
    }
    return self;
}

+(ParamBase *)param {
    return [[ParamBase alloc]init];
}

@end
