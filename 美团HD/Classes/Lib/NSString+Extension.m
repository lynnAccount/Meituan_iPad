//
//  NSString+Extension.m
//  美团HD
//
//  Created by apple on 15/6/23.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (instancetype)dealedPriceString:(NSString *)sourceString
{
    // 小数点的位置
    NSUInteger dotLoc = [sourceString rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        // 小数位数
        NSUInteger decimalCount = sourceString.length - dotLoc - 1;
        
        // 小数位数过多
        if (decimalCount > 2) {
            // 89.90000000000001 --> 89.90
            sourceString = [sourceString substringToIndex:dotLoc + 3];
            if ([sourceString hasSuffix:@"0"]) {
                sourceString = [sourceString substringToIndex:sourceString.length - 1];
            }
        }
    }
    return sourceString;
}

- (instancetype)dealedPriceString
{
    // 处理过的字符串
    NSString *newString = self;
    
    // 小数点的位置
    NSUInteger dotLoc = [newString rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        // 小数位数
        NSUInteger decimalCount = newString.length - dotLoc - 1;
        
        // 小数位数过多
        if (decimalCount > 2) {
            // 89.90000000000001 --> 89.90
            newString = [newString substringToIndex:dotLoc + 3];
            if ([newString hasSuffix:@"0"]) {
                newString = [newString substringToIndex:newString.length - 1];
            }
        }
    }
    return newString;
}

@end
