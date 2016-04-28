//
//  LYMenuViewController.m
//  美团HD
//
//  Created by lynn on 16/3/16.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYMenuViewController.h"
#import "DPAPI.h"
#import "DPRequest.h"
#import "LYDeal.h"
#import "MJRefresh.h"
#import "LYCollectionViewCell.h"
#import "LYDetailViewController.h"
#import "LYNaviItemView.h"
#import "LYDetailTool.h"

@interface LYMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)DPRequest *currentRequest;
// 当前的所有deal
@property (nonatomic, strong)NSMutableArray *deals;
@property (nonatomic, strong)UIImageView *emptyImage;

@property (nonatomic, strong)UIBarButtonItem *backItem;
@property (nonatomic, strong)UIBarButtonItem *editItem;

@property (nonatomic, strong)UIBarButtonItem *allItem;
@property (nonatomic, strong)UIBarButtonItem *nothingItem;
@property (nonatomic, strong)UIBarButtonItem *deleteItem;

@end

@implementation LYMenuViewController
#pragma mark --懒加载
- (UIImageView *)emptyImage{
    if (_emptyImage == nil) {
        _emptyImage =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
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
- (UIBarButtonItem *)editItem{
    if (_editItem == nil) {
        // 返回按钮
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:LYRGBColor(71, 159, 140) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.size = CGSizeMake(44, 44);
        
        _editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    }
    return _editItem;
}

- (UIBarButtonItem *)backItem{
    if (_backItem == nil) {
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"icon_back_highlighted"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        backBtn.size = backBtn.currentImage.size;
        
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    }
    return _backItem;
}
- (UIBarButtonItem *)allItem{
    if (_allItem == nil) {
        // 返回按钮
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setTitle:@"全部" forState:UIControlStateNormal];
       // [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:LYRGBColor(71, 159, 140) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
        editBtn.size = CGSizeMake(44, 44);
        
        
        _allItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    }
    return _allItem;
}
- (UIBarButtonItem *)nothingItem{
    if (_nothingItem == nil) {
        // 返回按钮
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setTitle:@"全不" forState:UIControlStateNormal];
       // [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:LYRGBColor(71, 159, 140) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(nothingClick) forControlEvents:UIControlEventTouchUpInside];
        editBtn.size = CGSizeMake(44, 44);
        
        _nothingItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    }
    return _nothingItem;
}
- (UIBarButtonItem *)deleteItem{
    if (_deleteItem == nil) {
        // 返回按钮
        UIButton *editBtn = [[UIButton alloc] init];
        [editBtn setTitle:@"删除" forState:UIControlStateNormal];
      //  [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:LYRGBColor(71, 159, 140) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        editBtn.size = CGSizeMake(64, 44);
        
        _deleteItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        
    }
    return _deleteItem;
}

- (void)allClick{
    // 所以没选中的 全不变为选中
    for (LYDeal *deal in self.deals) {
        if (deal.selected == NO) {
            deal.selected = YES;
        }
    }
    [self.collectionView reloadData];
}

- (void)nothingClick{
    for (LYDeal *deal in self.deals) {
        if (deal.selected == YES) {
            deal.selected = NO;
        }
    }
    [self.collectionView reloadData];}

- (void)deleteClick{
    // 拿到选中的 从存档中删除 然后更新
    for (LYDeal *deal in self.deals) {
        if (deal.selected) {
            [LYDetailTool uncollected:deal];
        }
    }
    UIButton *btn = self.deleteItem.customView;
    [btn setTitle:@"删除" forState:UIControlStateNormal];

    // 重新获取数据
    [self.deals removeAllObjects];
    [self.deals addObjectsFromArray:[LYDetailTool collectedDeals]];
    [self.collectionView reloadData];
}


#pragma mark 基本设置
static NSString * const reuseIdentifier = @"dealCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"LYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = LYRGBColor(203, 203, 203);
    
    [self setFlowlayout];
    
    [self setNav];
    
    // 接收通知
    [LYNoteCenter addObserver:self selector:@selector(selectedToDelete) name:LYSelectedDidChangedNoty object:nil];
}

- (void)selectedToDelete{
    // 计算选中的btn数量 并实时更新在删除按钮上面
    int count = 0;
    for (LYDeal *deal in self.deals) {
        if (deal.selected) {
            count++;
        }
    }
    if (count == 0) {
        UIButton *btn = self.deleteItem.customView;
        [btn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        UIButton *btn = self.deleteItem.customView;
        [btn setTitle:[NSString stringWithFormat:@"删除(%d)",count] forState:UIControlStateNormal];
    }
}



- (void)setNav{
    // 返回按钮 编辑按钮
    self.title = @"我的收藏";
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    self.navigationItem.rightBarButtonItem = self.editItem;

}

- (void)editClick:(UIButton *)sender{
    if (sender.isSelected) {
        sender.selected = NO;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        self.backItem.enabled = YES;
        
        for (LYDeal *deal in self.deals) {
            deal.covered = NO;
            deal.selected = NO;
        }
        [self.collectionView reloadData];
    }else{
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.allItem, self.nothingItem, self.deleteItem];
        sender.selected = YES;
        
        self.backItem.enabled = NO;
        
        for (LYDeal *deal in self.deals) {
            deal.covered = YES;
        }
        [self.collectionView reloadData];
    }
    UIButton *btn = self.deleteItem.customView;
    [btn setTitle:@"删除" forState:UIControlStateNormal];

}

- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setFlowlayout{
    // 设置flowlayout (由此设置布局)
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(305, 305);
    
    // 设置flowlayout (由此设置布局)
    flowLayout.itemSize = CGSizeMake(305, 305);
    
    int cols = 3;
    if (self.collectionView.width != 1024)
    {
        cols = 2;
    }
    
    CGFloat origin = (self.collectionView.width - cols * 305) / (cols + 1);
    flowLayout.minimumInteritemSpacing = origin;
    flowLayout.sectionInset = UIEdgeInsetsMake(origin, origin, 0, origin);
    flowLayout.minimumLineSpacing = origin;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.deals removeAllObjects];
    // 重写从内存中读取数据
    [self.deals addObjectsFromArray:[LYDetailTool collectedDeals]];
    
    [self.collectionView reloadData];
    
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:nil];
}

#pragma mark --数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    self.emptyImage.hidden = self.deals.count;
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark -- 代理方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    // 设置flowlayout (由此设置布局)
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(305, 305);
    
    // 设置flowlayout (由此设置布局)
    flowLayout.itemSize = CGSizeMake(305, 305);
    
    int cols = 3;
    if (self.collectionView.width != 1024)
    {
        cols = 2;
    }
    
    CGFloat origin = (self.collectionView.width - cols * 305) / (cols + 1);
    flowLayout.minimumInteritemSpacing = origin;
    flowLayout.sectionInset = UIEdgeInsetsMake(origin, origin, 0, origin);
    flowLayout.minimumLineSpacing = origin;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LYDetailViewController *detailVC = [[LYDetailViewController alloc] init];
    
    //[self addChildViewController:detailVC];
    
    detailVC.deal = self.deals[indexPath.item];;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end