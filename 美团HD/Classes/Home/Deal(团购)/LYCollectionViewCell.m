//
//  LYCollectionViewCell.m
//  美团HD
//
//  Created by lynn on 16/3/13.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYCollectionViewCell.h"
#import "LYDeal.h"
#import "LYPrepriceLabel.h"
#import "UIImageView+WebCache.h"
@interface LYCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *newdeal;
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UILabel *dealName;
@property (weak, nonatomic) IBOutlet UILabel *dealDisc;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet LYPrepriceLabel *prePrice;


@property (weak, nonatomic) IBOutlet UILabel *sellCount;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImg;

@end

@implementation LYCollectionViewCell
- (IBAction)coverClick:(id)sender {
    self.deal.selected = YES;
    self.checkImg.hidden = NO;
    
    // 发送通知让控制器更新 选中要删除的数量
    [LYNoteCenter postNotificationName:LYSelectedDidChangedNoty object:nil];
}

- (void)setDeal:(LYDeal *)deal{
    _deal = deal;
    // 图片
    [self.dealImage sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.dealName.text = deal.title;
    self.dealDisc.text = deal.desc;
    self.prePrice.text = [NSString stringWithFormat:@"原价¥%@",deal.list_price];
    self.nowPrice.text = [NSString stringWithFormat:@"¥%@",deal.current_price];
    self.sellCount.text = [NSString stringWithFormat:@"已有%@人购买",deal.purchase_count];
    
    // 拿到当前的时间 以及 deal 发布时间 相比
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = @"yyyy-MM-dd";
    NSDate *publishDate = [dateF dateFromString:self.deal.publish_date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 删除 cover 与 check 标记
    self.coverBtn.hidden = !deal.isCovered;
    self.checkImg.hidden = !deal.isSelected;
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:publishDate toDate:[NSDate date] options:kNilOptions];
    if (components.year > 0 || components.month > 0 || components.day < -1) {
        self.newdeal.hidden = YES;
    }else{
        self.newdeal.hidden = NO;
    }
}

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}

@end
