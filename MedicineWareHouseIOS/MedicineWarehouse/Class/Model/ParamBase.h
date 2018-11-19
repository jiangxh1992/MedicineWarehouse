//
//  ParamBase.h
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/28/16.
//
//

#import <Foundation/Foundation.h>

@interface ParamBase : NSObject

@property (nonatomic, assign) NSInteger type;     // 请求类型
@property (nonatomic, copy) NSString *medicine_id;// 药品id
@property (nonatomic, assign) NSInteger num;      // 数量

/**
 * param
 */
+(ParamBase *)param;

@end
