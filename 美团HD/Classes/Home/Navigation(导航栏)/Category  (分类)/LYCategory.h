//
//  LYCategory.h
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCategory : NSObject

@property (nonatomic, copy)NSString *highlighted_icon;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *small_highlighted_icon;
@property (nonatomic, copy)NSString *small_icon;

@property (nonatomic, strong)NSArray *subcategories;

+ (instancetype)categoryWithDic:(NSDictionary *)dic;

+ (NSArray *)categories;
@end
