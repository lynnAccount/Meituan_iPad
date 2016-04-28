//
//  LYDistrictViewController.h
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYDistrictViewController : UIViewController

@property (nonatomic, strong)NSArray *districts;

- (void)reloadLeftTableViewData;

@end
