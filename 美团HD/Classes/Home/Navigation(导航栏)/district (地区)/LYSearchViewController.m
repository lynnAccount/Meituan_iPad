//
//  LYSearchViewController.m
//  美团HD
//
//  Created by lynn on 16/3/11.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYSearchViewController.h"
#import "LYLocalPlistTool.h"
#import "LYCityGroupAToZ.h"
#import "LYSearchResultController.h"
#import "LYCities.h"
#import "LYLocalPlistTool.h"
@interface LYSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)UIButton *coverBtn;

@property (nonatomic, strong)LYSearchResultController *searchResult;

@property (nonatomic, strong)NSArray *citiesGroup;

@end

@implementation LYSearchViewController

// 创建搜索栏
- (LYSearchResultController *)searchResult{
    if (_searchResult == nil) {
        LYSearchResultController *searchResult = [[LYSearchResultController alloc] init];
        searchResult.tableView.frame = self.tableView.frame;
        // 控制器之间需要 进行属性的赋值(数据传递)操作的时候 需要建立 父子控制器关系
        _searchResult = searchResult;
        [self addChildViewController:searchResult];
        [self.view addSubview:searchResult.tableView];
    }
    return _searchResult;
}


- (NSArray *)citiesGroup{
    if (_citiesGroup == nil) {
        _citiesGroup = [LYLocalPlistTool citiesGroup];
    }
    return _citiesGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.preferredContentSize = CGSizeMake(500, 600);
    self.title = @"切换城市";
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    [self setDismissItem];
    
    [self setCoverBtn];
    
    //[self searchResult];
}

- (void)setCoverBtn{
    UIButton *coverBtn = [[UIButton alloc] init];
    coverBtn.backgroundColor = [UIColor darkGrayColor];
    coverBtn.alpha = 0.8;
    
    [self.view addSubview:coverBtn];
    coverBtn.frame = self.tableView.frame;
    self.coverBtn = coverBtn;
    self.coverBtn.hidden = YES;
}

// 设置取消键
- (void)setDismissItem{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"btn_navigation_close"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_navigation_close_hl"] forState:UIControlStateHighlighted];
    
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;

}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.citiesGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LYCityGroupAToZ *model = self.citiesGroup[section];
    return model.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    LYCityGroupAToZ *model = self.citiesGroup[indexPath.section];
    NSArray *cities = model.cities;
    
    cell.textLabel.text = cities[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    LYCityGroupAToZ *model = self.citiesGroup[section];
    return model.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (LYCityGroupAToZ *model in self.citiesGroup) {
        NSString *title = model.title;
        [arrayM addObject:title];
    }
    return arrayM.copy;
}

#pragma mark -- tableView 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    
        // 拿到对应的名字  再根据名字在citiesPlist 中查找该类的模型 ,因为是跟搜索结果共用一个通知 而且 citiesPlist 类型的模型 传过去 才有具体的地址
    LYCityGroupAToZ *cityGroup = self.citiesGroup[indexPath.section];
        NSArray *cityArray = cityGroup.cities;
        NSString *cityName = cityArray[indexPath.row];

        // 根据城市名 在cities模型中搜索该名字对应的模型
        NSArray *arrayCities = [LYLocalPlistTool cities];
        for (LYCities *city in arrayCities) {
            if ([city.name isEqualToString:cityName]) {
                // 发送通知
                NSDictionary *userInfo = @{LYCityCurrentKey:city};
                
                [LYNoteCenter postNotificationName:LYCityDidChangedNoty object:nil userInfo:userInfo];
            }
        }
}

#pragma mark -- searchBar 的代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 导航栏隐藏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 搜索栏背景图片改变
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 弹出新的搜索tableView (结果显示在hearder上)
    searchBar.showsCancelButton = YES;
    
    // 创建coverButton (用btn 点击能 弹回状态)
    self.coverBtn.hidden = NO;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    searchBar.showsCancelButton = NO;
    
    self.coverBtn.hidden = YES;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // 添加新的resulttableView
    if (searchText.length > 0) {
        self.searchResult.tableView.hidden = NO;
        
        self.searchResult.searchSource = searchText;
        // 给搜索结果控制器的 属性赋值 重写其该属性的 set方法 实现同步更新
    }else{
        self.searchResult.tableView.hidden = YES;
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    // 点击了取消按钮
    [searchBar resignFirstResponder];
}

@end
