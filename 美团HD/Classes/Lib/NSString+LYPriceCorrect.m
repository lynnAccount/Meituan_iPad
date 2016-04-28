//
//  NSString+LYPriceCorrect.m
//  美团HD
//
//  Created by lynn on 16/3/13.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "NSString+LYPriceCorrect.h"

@implementation NSString (LYPriceCorrect)

+ (instancetype)correctPriceWith:(NSString *)troublePrice{
    
    NSInteger loction = [troublePrice rangeOfString:@"."].location;
    
    if (loction != NSNotFound) {
        // 小数位数
        NSInteger smallLocation = troublePrice.length - loction - 1;
        if (smallLocation > 2) {
            troublePrice = [troublePrice substringToIndex:loction + 3];
            if ([troublePrice hasSuffix:@"0"]) {
                troublePrice = [troublePrice substringToIndex:troublePrice.length - 1];
            }
        }
    }
    return troublePrice;
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
