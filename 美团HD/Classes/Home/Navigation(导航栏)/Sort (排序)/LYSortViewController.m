//
//  LYSortViewController.m
//  美团HD
//
//  Created by lynn on 16/3/10.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYSortViewController.h"
#import "LYLocalPlistTool.h"
#import "LYSort.h"
@interface LYSortViewController ()
@property (nonatomic, strong)NSArray *sort;
@end

@implementation LYSortViewController

- (NSArray *)sort{
    if (_sort == nil) {
        _sort = [LYLocalPlistTool sort];
    }
    return _sort;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubBtn];
}

- (void)setSubBtn{
    NSInteger count = self.sort.count;
    CGFloat margin = 10;
    CGFloat width = 100;
    CGFloat height = 30;
    CGFloat x = 10;
    // 创建五个按钮
    for (int i = 0; i < count; i++) {
        CGFloat y = margin + (margin + height) * i;
        UIButton *btn = [[UIButton alloc] init];
        
        btn.frame = CGRectMake(x, y, width, height);
        
        LYSort *model = self.sort[i];
        [btn setTitle:model.label forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btn.tag = model.value;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
        
        [btn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    // 控制器应该展示的大小
    self.preferredContentSize = CGSizeMake(2 * margin + width, margin + (margin + height) * count);
    
}

- (void)sortClick:(UIButton *)sender{
    // 发送通知
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    int index = sender.tag - 1;
    LYSort *sort = self.sort[index];
    userInfo[LYSortCurrentKey] = sort;
    [LYNoteCenter postNotificationName:LYSortDidChangedNoty object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
