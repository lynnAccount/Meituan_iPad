//
//  NSString+LYPriceCorrect.h
//  美团HD
//
//  Created by lynn on 16/3/13.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYPriceCorrect)

+ (instancetype)correctPriceWith:(NSString *)troublePrice;

- (instancetype)dealedPriceString;


@end
