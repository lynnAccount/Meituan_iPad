//
//  LYCategotyViewController.m
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYCategotyViewController.h"
#import "LYLocalPlistTool.h"
#import "LYCategory.h"
@interface LYCategotyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (nonatomic, strong)NSArray *categories;

@end

@implementation LYCategotyViewController

- (NSArray *)categories{
    if (_categories == nil) {
        _categories = [LYCategory categories];
    }
    return _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat rowHeight = 40;
    self.leftTableView.rowHeight = rowHeight;
    self.rightTableView.rowHeight = rowHeight;
    
    self.preferredContentSize = CGSizeMake(400, self.categories.count * rowHeight);
}

#pragma mark -- 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.categories.count;
    }else{
        NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
        LYCategory *category = self.categories[row];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        static NSString *leftID = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
        }
        // 模型
        LYCategory *category = self.categories[indexPath.row];
        cell.textLabel.text = category.name;
        
        // image
        if (category.subcategories.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
        
        // 背景图
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        
        return cell;
    }else{
        static NSString *rightID = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
        }
        // 背景图
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
//        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        

        NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
        LYCategory *category = self.categories[row];
        NSArray *subCategory = category.subcategories;
        cell.textLabel.text = subCategory[indexPath.row];
        return cell;
    }
}

#pragma mark -- tableView 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (tableView == self.leftTableView) {
        // 拿到点击左边时候的 模型 (由于还需要图片)
        LYCategory *cat = self.categories[indexPath.row];
        if (!cat.subcategories.count) {
            [self dismissViewControllerAnimated:YES completion:^{
            // 发通知更新
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                userInfo[LYCategoryCurrentKey] = cat;
                [LYNoteCenter postNotificationName:LYCategoryDidChangedNoty object:nil userInfo:userInfo];
            }];
        }
        [self.rightTableView reloadData];
        
        
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            // 发通知更新
            // 拿到点击右边时候 左边模型
            NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
            LYCategory *cat = self.categories[row];
            NSArray *arraySubCat = cat.subcategories;
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[LYCategoryCurrentKey] = cat;
            userInfo[LYCategoryCurrentSubKey] = arraySubCat[indexPath.row];
            [LYNoteCenter postNotificationName:LYCategoryDidChangedNoty object:nil userInfo:userInfo];
        }];
    }
}

@end
