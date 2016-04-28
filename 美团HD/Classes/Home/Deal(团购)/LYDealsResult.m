//
//  LYDealsResult.m
//  美团HD
//
//  Created by lynn on 16/3/13.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYDealsResult.h"
#import "MJExtension.h"
#import "LYDeal.h"
@implementation LYDealsResult
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"deals": [LYDeal class]};
}
@end
