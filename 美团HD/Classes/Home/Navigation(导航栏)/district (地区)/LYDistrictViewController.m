//
//  LYDistrictViewController.m
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYDistrictViewController.h"
#import "LYSearchViewController.h"
#import "LYNavigationController.h"
#import "LYDistrict.h"
#import "LYCities.h"
#import "LYLocalPlistTool.h"
@interface LYDistrictViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation LYDistrictViewController

- (void)reloadLeftTableViewData{
    [self.leftTableView reloadData];
}

- (IBAction)districtChangeClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        // modal 出一个新的搜索控制器 (用的导航控制器还是之前那个 因为下面的蓝线一样)
        LYSearchViewController *searchC = [[LYSearchViewController alloc] init];
        //searchC.modalPresentationStyle = UIModalPresentationFormSheet;
        LYNavigationController *navC = [[LYNavigationController alloc] initWithRootViewController:searchC];
        
        // 需要在屏幕正中显示出来的样式 只能设置nav 导航控制器的modal样式是 formSheet
        navC.modalPresentationStyle = UIModalPresentationFormSheet;
        
        // 因为本控制器需要被dismiss  所以只能用跟控制器来 modal
        UIViewController *rootV = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [rootV presentViewController:navC animated:YES completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(400, 400);
}

#pragma mark -- 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.districts.count;
    }else{
        NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
        LYDistrict *district = self.districts[row];
        return district.subdistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        static NSString *leftID = @"districtLeftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
        }
        // 模型
        LYDistrict *district = self.districts[indexPath.row];
        cell.textLabel.text = district.name;
        // image
        if (district.subdistricts.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        // 背景图
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        
        return cell;
    }else{
        static NSString *rightID = @"districtRightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
        }
        // 背景图
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        //        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        
        
        NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
        LYDistrict *district = self.districts[row];
        NSArray *subdistrict = district.subdistricts;
        cell.textLabel.text = subdistrict[indexPath.row];
        return cell;
    }
}

#pragma mark -- tableView 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.leftTableView) {
        // 拿到点击左边时候的 模型 (由于还需要图片)
        LYDistrict *district = self.districts[indexPath.row];
        if (!district.subdistricts.count) {
            [self dismissViewControllerAnimated:YES completion:^{
                // 发通知更新
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                userInfo[LYDistrictCurrentKey] = district;

                [LYNoteCenter postNotificationName:LYDistrictDidChangedNoty object:nil userInfo:userInfo];
            }];
        }
        [self.rightTableView reloadData];
        
        
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            // 发通知更新
            // 拿到点击右边时候 左边模型
            NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
            LYDistrict *district = self.districts[row];
            NSArray *arraySubDis = district.subdistricts;
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[LYDistrictCurrentKey] = district;
            userInfo[LYDistrictCurrentSubKey] = arraySubDis[indexPath.row];
            [LYNoteCenter postNotificationName:LYDistrictDidChangedNoty object:nil userInfo:userInfo];
        }];
    }
}

@end
