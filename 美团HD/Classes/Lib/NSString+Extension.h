//
//  NSString+Extension.h
//  美团HD
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/** 返回处理过的价格字符串 */
+ (instancetype)dealedPriceString:(NSString *)sourceString;

- (instancetype)dealedPriceString;

@end
