//
//  LYDetailTool.h
//  美团HD
//
//  Created by lynn on 16/3/16.
//  Copyright © 2016年 lynn. All rights reserved.
//
//  文件的存档读档 不能单纯的一个个写入  因为存档方式是 覆盖写入的 后者会覆盖前者

#import <Foundation/Foundation.h>
@class LYDeal;
@interface LYDetailTool : NSObject

//** collection*/
// 存档方法
+ (void)collected:(LYDeal *)deal;


// 移除存档方法
+ (void)uncollected:(LYDeal *)deal;

// 读取 deal数组
+ (NSArray *)collectedDeals;

// 判断以及在存档中的方法
+ (BOOL)isCollected:(LYDeal *)deal;



//** history*/
// 存档方法
+ (void)history:(LYDeal *)deal;


// 移除存档方法
+ (void)unhistory:(LYDeal *)deal;

// 读取 deal数组
+ (NSArray *)historyDeals;

// 判断以及在存档中的方法
+ (BOOL)isHistory:(LYDeal *)deal;



@end
