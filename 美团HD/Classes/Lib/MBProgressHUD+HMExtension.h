//
//  MBProgressHUD+HMExtension.h
//  美团HD
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HMExtension)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
