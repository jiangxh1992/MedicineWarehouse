//
//  ParamBase.h
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/28/16.
//
//

#import <Foundation/Foundation.h>

@interface ParamBase : NSObject

/**
 *  请求类型
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  药品id
 */
@property (nonatomic, copy) NSString *medicine_id;

/**
 * param
 */
+(ParamBase *)param;

@end
