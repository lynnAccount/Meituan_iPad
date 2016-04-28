//
//  UIBarButtonItem+Extension.h
//  美团HD
//
//  Created by apple on 20/6/13.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  创建一个拥有2张图片的item对象
 *
 *  @param image     普通图片
 *  @param highImage 高亮图片
 *  @param target 点击item后会调用target的action方法
 *  @param action    点击item后调用的方法
 *
 *  @return 返回创建好的item对象
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
