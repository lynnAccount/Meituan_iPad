//
//  LYDetailViewController.m
//  美团HD
//
//  Created by lynn on 16/3/14.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYDetailViewController.h"
#import "LYPrepriceLabel.h"
#import "LYDeal.h"
#import "UIImageView+WebCache.h"
#import "LYDetailTool.h"
@interface LYDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet LYPrepriceLabel *listPrice;

@property (weak, nonatomic) IBOutlet UIButton *moneyBackAnytime;
@property (weak, nonatomic) IBOutlet UIButton *moneyBackOvertime;
@property (weak, nonatomic) IBOutlet UIButton *restTime;
@property (weak, nonatomic) IBOutlet UIButton *soldCount;
@property (weak, nonatomic) IBOutlet UIButton *collectedBtn;

@end

@implementation LYDetailViewController
- (IBAction)buyNowClick:(id)sender {
    NSLog(@"买买买");
}

#pragma mark -- 点击了收藏按钮
- (IBAction)collectedClick:(UIButton *)sender{
    if ([LYDetailTool isCollected:self.deal]) {
        // 解档
        [LYDetailTool uncollected:self.deal];
    }else{
        [LYDetailTool collected:self.deal];
    }
     sender.selected = !sender.isSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置好webView
    [self setupWebView];
    
    // 设置详情界面
    [self setDetail];
}

#pragma mark -- 给控件赋值
- (void)setDetail{
    self.titleLabel.text = self.deal.title;
    [self.dealImage sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url]];
    self.descrip.text = self.deal.desc;
    self.currentPrice.text = [NSString stringWithFormat:@"¥%@",self.deal.current_price];
    self.listPrice.text = [NSString stringWithFormat:@"原价¥%@",self.deal.list_price];
    // NSLog(@"%d",self.deal.is_refundable);
    self.moneyBackAnytime.selected = YES;//self.deal.is_refundable;
    self.moneyBackOvertime.selected = self.deal.is_refundable;
    [self.soldCount setTitle:[NSString stringWithFormat:@"已出售%@", self.deal.purchase_count] forState:UIControlStateNormal];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *deadlineDate = [formatter dateFromString:self.deal.purchase_deadline];
    deadlineDate = [deadlineDate dateByAddingTimeInterval:24 * 60 * 60];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unit fromDate:[NSDate date] toDate: deadlineDate options:kNilOptions];
    if (components.day >= 30) {
        [self.restTime setTitle:@"未来一个月有效" forState:UIControlStateNormal];
    }else{
        [self.restTime setTitle:[NSString stringWithFormat:@"剩余%d天%d小时%d分",components.day , components.hour, components.minute] forState:UIControlStateNormal];
    }
    
    self.collectedBtn.selected = [LYDetailTool isCollected:self.deal];
}
#pragma mark -- webView
// 发送请求
- (void)setupWebView{
    self.webView.delegate = self;

    // 截取id
    NSString *ID = [self.deal.deal_id substringFromIndex:2];
    // 拼接请求url
    NSString *url = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID];
    // 加载右边的页面
    NSURLRequest *currentRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:currentRequest];
}

// 对webView 的处理
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *javaScript =  @"document.getElementsByTagName('header')[0].remove();"
    "document.getElementsByClassName('cost-box')[0].remove();"
    "document.getElementsByClassName('buy-now')[0].remove();"
    "document.getElementsByTagName('footer')[0].remove();";
    
    // OC字符串转javaScript 语句执行
    [webView stringByEvaluatingJavaScriptFromString:javaScript];
}

// 只支持横屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)backClick:(id)sender {
    // 取消当前请求
    [self.webView stopLoading];
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
