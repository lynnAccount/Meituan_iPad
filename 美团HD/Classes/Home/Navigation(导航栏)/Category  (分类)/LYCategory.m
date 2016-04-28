//
//  LYCategory.m
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYCategory.h"

@implementation LYCategory

+ (instancetype)categoryWithDic:(NSDictionary *)dic{
    LYCategory *cat = [[self alloc] init];
    [cat setValuesForKeysWithDictionary:dic];
    return cat;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+ (NSArray *)categories{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"categories.plist" ofType:nil];
    NSArray *arrayDic = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dic in arrayDic) {
        LYCategory *cat = [self categoryWithDic:dic];
        [arrayM addObject:cat];
    }
    return arrayM.copy;
}

@end
