//
//  LYDeal.m
//  美团HD
//
//  Created by lynn on 16/3/13.
//  Copyright © 2016年 lynn. All rights reserved.
//
#import "MJExtension.h"
#import "LYDeal.h"
#import "NSString+MJExtension.h"
#import "NSString+LYPriceCorrect.h"
@implementation LYDeal

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}


- (void)setCurrent_price:(NSString *)current_price{
    _current_price = [current_price dealedPriceString];
}


- (void)setPublish_date:(NSString *)publish_date{
    
}

MJCodingImplementation

@end
