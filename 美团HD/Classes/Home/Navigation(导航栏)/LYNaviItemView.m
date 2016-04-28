//
//  LYNaviItemView.m
//  美团HD
//
//  Created by lynn on 16/3/9.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYNaviItemView.h"

@implementation LYNaviItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)naviItemView{
    return [[NSBundle mainBundle] loadNibNamed:@"LYNaviItemView" owner:nil options:nil].firstObject;
}

@end
