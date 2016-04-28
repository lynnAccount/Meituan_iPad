//
//  LYNaviItemView.h
//  美团HD
//
//  Created by lynn on 16/3/9.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYNaviItemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UIButton *btn;

+ (instancetype)naviItemView;
@end
