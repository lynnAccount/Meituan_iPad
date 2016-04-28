//
//  LYCollectionViewController.m
//  美团HD
//
//  Created by lynn on 16/3/9.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYCollectionViewController.h"
#import "DPAPI.h"
#import "LYCategotyViewController.h"
#import "LYNaviItemView.h"
#import "LYDistrictViewController.h"
#import "LYCategory.h"
#import "LYCities.h"
#import "LYDistrict.h"
#import "LYSort.h"
#import "LYCategory.h"
#import "LYSortViewController.h"
#import "LYCollectionViewCell.h"
#import "LYDeal.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LYDealsResult.h"
#import "AwesomeMenu.h"
#import "LYDetailTool.h"
#import "LYHistoryViewController.h"
#import "LYDetailViewController.h"
#import "PureLayout.h"
#import "MBProgressHUD+HMExtension.h"
#import "LYMenuViewController.h"
#import "LYNavigationController.h"
#import "LYDetailDeal.h"

@interface LYCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AwesomeMenuDelegate>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayOut;

// 导航栏的按钮
@property (nonatomic, strong)UIBarButtonItem *sortItem;
@property (nonatomic, strong)UIBarButtonItem *districtItem;
@property (nonatomic, strong)UIBarButtonItem *categoryItem;
// 地区的控制器 用以传递地区的城市模型
@property (nonatomic, strong)LYDistrictViewController *districtVC;

// 记录当前的城市模型 等用于发送网络请求
@property (nonatomic, copy)NSString *currentCityName;
@property (nonatomic, strong)LYCities *currentCity;
@property (nonatomic, copy)NSString *currentDistrictName;
@property (nonatomic, copy)NSString *currentSortName;
@property (nonatomic, copy)NSString *currentCategoryName;
@property (nonatomic, strong)LYDealsResult *currentResult;

@property (nonatomic, assign)int currentPage;
// 当前的所有deal
@property (nonatomic, strong)NSMutableArray *deals;

@property (nonatomic, strong)DPRequest *currentRequest;

@property (nonatomic, strong)UIImageView *emptyImage;

@end

@implementation LYCollectionViewController

- (UIImageView *)emptyImage{
    if (_emptyImage == nil) {
        _emptyImage =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        _emptyImage.x = self.collectionView.bounds.size.width * 0.5 - _emptyImage.image.size.width * 0.5;
        _emptyImage.y = self.collectionView.bounds.size.height * 0.5 - _emptyImage.image.size.height * 0.5;
        [self.collectionView addSubview:_emptyImage];
        
    }
    return _emptyImage;
}

- (NSMutableArray *)deals{
    if (_deals == nil) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

static NSString * const reuseIdentifier = @"dealCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"LYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.flowLayOut.itemSize = CGSizeMake(305, 305);
    
    // 设置flowlayout (由此设置布局)
    self.flowLayOut.itemSize = CGSizeMake(305, 305);
    
    int cols = 3;
    if (self.collectionView.width != 1024)
    {
        cols = 2;
    }
    
    CGFloat origin = (self.collectionView.width - cols * 305) / (cols + 1);
    self.flowLayOut.minimumInteritemSpacing = origin;
    self.flowLayOut.sectionInset = UIEdgeInsetsMake(origin, origin, 0, origin);
    self.flowLayOut.minimumLineSpacing = origin;

    // 设置左边naviBar
    [self setNaviBarLeft];
    // 设置右边naviBar
    [self setNaviBarRight];
    // 设置监听者
    [self setNotificationObserver];
    // 设置下拉与上拉刷新
    [self setRefresh];
    
    // 初始调用获取数据方法
    [self getNewDeal];
    
    [self setupAwesomemenu];
}

- (void)setupAwesomemenu{
     //统一背景图片
    UIImage *image = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    AwesomeMenuItem *start = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenuItem *user = [[AwesomeMenuItem alloc] initWithImage:image     highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    
    AwesomeMenuItem *mark = [[AwesomeMenuItem alloc] initWithImage:image     highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    AwesomeMenuItem *record = [[AwesomeMenuItem alloc] initWithImage:image     highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];

    AwesomeMenuItem *more = [[AwesomeMenuItem alloc] initWithImage:image     highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:start menuItems:@[user, mark, record, more]];
    [self.view addSubview:menu];

    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(250, 250)];

    menu.menuWholeAngle = M_PI * 0.5;
    
    menu.startPoint = CGPointMake(50, 200);
    menu.alpha = 0.5;
    menu.delegate = self;
}

# pragma mark awesomeMenu 的代理方法
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    
    switch (idx) {
        case 0:
            NSLog(@"点击了个人按钮");
            break;
        case 1:{
            LYMenuViewController *menuVC = [[LYMenuViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            LYNavigationController *nav = [[LYNavigationController alloc] initWithRootViewController:menuVC];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:{
            LYHistoryViewController *history = [[LYHistoryViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            LYNavigationController *nav = [[LYNavigationController alloc] initWithRootViewController:history];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 3:
            NSLog(@"点击了更多按钮");
            break;

        default:
            break;
    }
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.5;
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.5;
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    menu.alpha = 1;
}


# pragma mark 设置通知的监听者
- (void)setNotificationObserver{
    // 接收分类的通知
    [LYNoteCenter addObserver:self selector:@selector(categoryChange:) name:LYCategoryDidChangedNoty object:nil];
    // 接收排序的通知
    [LYNoteCenter addObserver:self selector:@selector(sortChange:) name:LYSortDidChangedNoty object:nil];
    // 接收城市改变通知
    [LYNoteCenter addObserver:self selector:@selector(cityChange:) name:LYCityDidChangedNoty object:nil];
    // 接收地区改变通知
    [LYNoteCenter addObserver:self selector:@selector(districtChange:) name:LYDistrictDidChangedNoty object:nil];
}

# pragma mark 通知的监听方法

- (void)districtChange:(NSNotification *)noti{
    LYNaviItemView *districtView = self.districtItem.customView;
    
    LYDistrict *district = noti.userInfo[LYDistrictCurrentKey];
    //当前地区名字
    if ( noti.userInfo[LYDistrictCurrentSubKey] == nil) {
        self.currentDistrictName = district.name;
    }else{
        self.currentDistrictName = noti.userInfo[LYDistrictCurrentSubKey];
    }
    
    districtView.title.text = [NSString stringWithFormat:@"%@ | %@",self.currentCityName, district.name];
    districtView.subTitle.text = noti.userInfo[LYDistrictCurrentSubKey];
    // 发送网络请求
    [self.collectionView.header beginRefreshing];
}

- (void)cityChange:(NSNotification *)noti{
    LYNaviItemView *districtView = self.districtItem.customView;
    LYCities *city = noti.userInfo[LYCityCurrentKey];
    // 当前城市名字
    self.currentCityName = city.name;
    self.currentCity = city;
    
    districtView.title.text = city.name;
    districtView.subTitle.text = nil;
    // 发送网络请求
    [self.collectionView.header beginRefreshing];
}

- (void)sortChange:(NSNotification *)noti{
    LYNaviItemView *sortView = self.sortItem.customView;
    
    NSDictionary *userInfo = noti.userInfo;
    LYSort *sort = userInfo[LYSortCurrentKey];
    self.currentSortName = [NSString stringWithFormat:@"%d",sort.value];
    
    sortView.subTitle.text = sort.label;
    // 发送网络请求
    [self.collectionView.header beginRefreshing];
}

- (void)categoryChange:(NSNotification *)noti{
    LYNaviItemView *categoryView = self.categoryItem.customView;
    
    NSDictionary *userInfo = noti.userInfo;
    LYCategory *cat = userInfo[LYCategoryCurrentKey];
    
    categoryView.title.text = cat.name;
    
    [categoryView.btn setImage:[UIImage imageNamed:cat.icon] forState:UIControlStateNormal];
    
    self.currentCategoryName = cat.name;
    categoryView.subTitle.text = userInfo[LYCategoryCurrentSubKey];
    // 发送网络请求
    [self.collectionView.header beginRefreshing];
}

#pragma mark -- 移除观察者
- (void)dealloc{
    [LYNoteCenter removeObserver:self];
    [self.currentRequest disconnect];
}

#pragma mark -- 设置上拉与下拉刷新
- (void)setRefresh{
    // 根据第三方框架的方法 设置刷新该调用的方法
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewDeal)];
    
    // 上拉加载更多
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDeal)];
}

#pragma mark -- 设置左边导航栏按钮
- (void)setNaviBarLeft{
    // 图标 icon
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    item1.enabled = NO;
    
    // 分类 category
    LYNaviItemView *item2View = [LYNaviItemView naviItemView];
    item2View.title.text = @"全部";
    item2View.subTitle.text = nil;
    [item2View.btn setImage:[UIImage imageNamed:@"icon_category_-1"] forState:UIControlStateNormal];
    item2View.width = 120;
    
    [item2View.btn setImage:[UIImage imageNamed:@"icon_category_highlighted_-1"] forState:UIControlStateHighlighted];
    [item2View.btn addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:item2View];
    self.categoryItem = item2;
    
    // 地区 district
    LYNaviItemView *item3View = [LYNaviItemView naviItemView];
    self.currentCityName = @"北京";
    item3View.title.text = self.currentCityName;
    
    item3View.subTitle.text = nil;
    [item3View.btn setImage:[UIImage imageNamed:@"icon_district"] forState:UIControlStateNormal];
    
    [item3View.btn setImage:[UIImage imageNamed:@"icon_district_highlighted"] forState:UIControlStateHighlighted];
    [item3View.btn addTarget:self action:@selector(districtClick) forControlEvents:UIControlEventTouchUpInside];
    item3View.width = 160;
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:item3View];
    self.districtItem = item3;
    
    // 排序sort
    LYNaviItemView *item4View = [LYNaviItemView naviItemView];
    item4View.title.text = @"排序";
    item4View.subTitle.text = @"默认排序";
    [item4View.btn setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    
    [item4View.btn setImage:[UIImage imageNamed:@"icon_sort_highlighted"] forState:UIControlStateHighlighted];
    [item4View.btn addTarget:self action:@selector(sortClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithCustomView:item4View];
    self.sortItem = item4;
    
    self.navigationItem.leftBarButtonItems = @[item1, item2, item3, item4];
}
#pragma mark 封装发送网络请求的方法
// 获取新的数据
- (void)getNewDeal{
    if (self.currentCityName == nil) {
        [self.currentRequest disconnect];
        [self.collectionView.header endRefreshing];

        UIAlertController *alct = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您所在的城市名" preferredStyle:UIAlertControllerStyleAlert];
        [alct addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alct animated:YES completion:nil];
        return;
    }
    // 取消正在执行的请求
    [self.currentRequest disconnect];
    // 取消刷新 (取消的是footer 的刷新)
    [self.collectionView.footer endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"limit"] = @20;
    
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    
    if (self.currentCityName) params[@"city"] = self.currentCityName;
    
    if (self.currentDistrictName) params[@"region"] = self.currentDistrictName;
    
    if (self.currentSortName) params[@"sort"] = @(self.currentSortName.intValue);
    
    self.currentRequest = [[DPAPI sharedRequest] requestWithURL:@"v1/deal/find_deals" params:params success:^(id json) {

        // 转换为模型 赋值给属性
        self.currentPage = 1;
        
        self.currentResult = [LYDealsResult mj_objectWithKeyValues:json];
        // 先移除之前保存的数据 再赋值
        [self.deals removeAllObjects];
        [self.deals addObjectsFromArray:self.currentResult.deals];
        // 刷新
        [self.collectionView reloadData];
        // 停止显示菊花
        [self.collectionView.header endRefreshing];

        
    } failure:^(NSError *error) {
        // 停止显示菊花
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        [self.collectionView.header endRefreshing];
    }];
}

// 获取更多数据
- (void)getMoreDeal{
    if (self.currentCityName == nil) {
        UIAlertController *alct = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您所在的城市名" preferredStyle:UIAlertControllerStyleAlert];
        [alct addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alct animated:YES completion:nil];
    
        return;
    }    // 取消正在执行的请求
    [self.currentRequest disconnect];
    // 取消header 的刷新  (如果是拉上面  还没刷新结束)
    [self.collectionView.header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"limit"] = @20;
    params[@"page"] = @(self.currentPage);
    
    if (self.currentCategoryName) params[@"category"] = self.currentCategoryName;
    
    if (self.currentCityName) params[@"city"] = self.currentCityName;
    
    if (self.currentDistrictName) params[@"region"] = self.currentDistrictName;
    
    if (self.currentSortName) params[@"sort"] = @(self.currentSortName.intValue);
    
    self.currentRequest = [[DPAPI sharedRequest] requestWithURL:@"v1/deal/find_deals" params:params success:^(id json) {
        // 转换为模型 赋值给属性
        self.currentPage ++;
        LYDealsResult *result = [LYDealsResult mj_objectWithKeyValues:json];
        [self.deals addObjectsFromArray:result.deals];
        // 刷新
        [self.collectionView reloadData];
        // 隐藏footer菊花
        self.collectionView.footer.hidden = YES;

    } failure:^(NSError *error) {
        // 隐藏footer菊花
        self.collectionView.footer.hidden = YES;
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

#pragma mark --点击了地区按钮
- (void)districtClick{
    LYDistrictViewController *district = [[LYDistrictViewController alloc] init];
    district.modalPresentationStyle = UIModalPresentationPopover;
    district.popoverPresentationController.barButtonItem = self.districtItem;
    self.districtVC = district;
    // 城市内容发送给 区域控制器
    district.districts = self.currentCity.districts;
    
    [self presentViewController:district animated:YES completion:nil];
}

#pragma mark 点击了排序按钮
- (void)sortClick{
    // 创建popover
    LYSortViewController *sort = [[LYSortViewController alloc] init];
    sort.modalPresentationStyle = UIModalPresentationPopover;
    sort.popoverPresentationController.barButtonItem
    = self.sortItem;
    [self presentViewController:sort animated:YES completion:nil];
}
#pragma mark 点击了分类按钮
-  (void)categoryClick{
    LYCategotyViewController *category = [[LYCategotyViewController alloc] init];
    category.modalPresentationStyle = UIModalPresentationPopover;
    category.popoverPresentationController.barButtonItem = self.categoryItem;
    [self presentViewController:category animated:YES completion:nil];
}


#pragma mark -- 设置右边导航栏按钮
- (void)setNaviBarRight{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_search_highlighted"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    item1.customView.width = 50;
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"icon_map_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    btn2.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    item2.customView.width = 50;
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 下拉刷新是否显示
    
    self.collectionView.footer.hidden = (self.currentResult.total_count == self.deals.count);
    // 数据为空是否显示
    self.emptyImage.hidden = self.currentResult.total_count;
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    // 设置flowlayout (由此设置布局)
    self.flowLayOut.itemSize = CGSizeMake(305, 305);
    
    int cols = 3;
    if (size.width != 1024)
    {
        cols = 2;
    }
    CGFloat origin = (size.width - cols * 305) / (cols + 1);
    self.flowLayOut.minimumInteritemSpacing = origin;
    self.flowLayOut.sectionInset = UIEdgeInsetsMake(origin, origin, 0, origin);
    self.flowLayOut.minimumLineSpacing = origin;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LYDetailViewController *detailVC = [[LYDetailViewController alloc] init];
    
    //[self addChildViewController:detailVC];
    
    detailVC.deal = self.deals[indexPath.item];;

    [self presentViewController:detailVC animated:YES completion:nil];
    
    // 存档到历史 (先删除相同的再存档到最前面)
    [LYDetailTool history:self.deals[indexPath.item]];
}

@end




