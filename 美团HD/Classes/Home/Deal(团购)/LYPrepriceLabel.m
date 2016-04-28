//
//  LYPrepriceLabel.m
//  美团HD
//
//  Created by lynn on 16/3/13.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYPrepriceLabel.h"

@implementation LYPrepriceLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, rect.size.height * 0.25)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height * 0.25)];
    [path stroke];
}

@end
