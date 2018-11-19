//
//  MedicineUnit.h
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/19.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicineUnit : NSObject

@property (nonatomic, copy)NSString *uid;  // 单元机id
@property (nonatomic, copy)NSString *bh;   // 单元机编号
@property (nonatomic, copy)NSString *ypmc; //药品名称
@property (nonatomic, copy)NSString *ypid; //药品ID
@property (nonatomic, copy)NSString *ph;   //药品批号
@property (nonatomic, copy)NSString *storage;//库存（-1为请求出错）
@property (nonatomic, assign)NSInteger need; //0：不需要补药（绿色）1：需要补药（红色）-1：请求出错
@property (nonatomic, assign)NSInteger zt;   //单元机运行状态

+(MedicineUnit *)unit;

@end

NS_ASSUME_NONNULL_END
