//
//  LYLocalPlistTool.m
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYLocalPlistTool.h"
#import "MJExtension.h"
#import "LYSort.h"
#import "LYCategory.h"
#import "LYCityGroupAToZ.h"
#import "LYDistrict.h"
#import "LYCities.h"
@interface LYLocalPlistTool ()
@end

@implementation LYLocalPlistTool
// 类方法无法拿到自身属性 所以定义一个全局变量数组
static NSArray *_sort;

+ (NSArray *)sort{
    if (_sort == nil) {
        _sort = [LYSort mj_objectArrayWithFilename:@"sorts.plist"];
    }
    return _sort;
}


static NSArray *_category;
+ (NSArray *)category{
    if (_category == nil) {
        _category = [LYCategory mj_objectArrayWithFilename:@"categories.plist"];
    }
    return _category;
}

static NSArray *_citiesGroup;
+ (NSArray *)citiesGroup{
    if (_citiesGroup == nil) {
        _citiesGroup = [LYCityGroupAToZ mj_objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _citiesGroup;
}

static NSArray *_cities;
+ (NSArray *)cities{
    if (_cities == nil) {
        _cities = [LYCities mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static NSArray *_districts;
+ (NSArray *)districts{
    if (_districts == nil) {
        _districts = [LYDistrict mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _districts;
}



@end
