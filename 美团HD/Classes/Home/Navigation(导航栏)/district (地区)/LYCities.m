//
//  LYCities.m
//  美团HD
//
//  Created by lynn on 16/3/12.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYCities.h"
#import "MJExtension.h"
#import "LYDistrict.h"
@implementation LYCities

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"districts": [LYDistrict class]};
}

@end
