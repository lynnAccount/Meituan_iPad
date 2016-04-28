//
//  LYDetailTool.m
//  美团HD
//
//  Created by lynn on 16/3/16.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYDetailTool.h"
#import "LYDeal.h"

// 收藏文件的路径
#define collectedFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"collectedFile"]
#define LYCollectFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deal.data"]

#define LYHistoryFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history_deal.data"]
@implementation LYDetailTool

// 用于先读取 之前有的数据
static NSMutableArray *_collectedDeals;
static NSMutableArray *_historyDeals;

+ (void)initialize{
    // 取出之前的deals数组
    _collectedDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:LYCollectFile];
    if (_collectedDeals == nil) {
        _collectedDeals = [NSMutableArray array];
    }
    
    // 取出之前的history数组
    _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:LYCollectFile];
    if (_collectedDeals == nil) {
        _collectedDeals = [NSMutableArray array];
    }
}

// 存档方法
+ (void)collected:(LYDeal *)deal{
    // 插入到数组
    [_collectedDeals insertObject:deal atIndex:0];
    // 数组存档
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:LYCollectFile];
    
    [_historyDeals insertObject:deal atIndex:0];
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:LYCollectFile];

}

// 移除存档方法
+ (void)uncollected:(LYDeal *)deal{
    // 移除到数组
    [_collectedDeals removeObject:deal];
    // 数组存档
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:LYCollectFile];
    
    
}

// 读取 deal数组
+ (NSArray *)collectedDeals{
    return _collectedDeals;
}


// 判断以及在存档中的方法
+ (BOOL)isCollected:(LYDeal *)deal{
    
    for (LYDeal *collecteddeal in _collectedDeals) {
        if ([collecteddeal.deal_id isEqualToString:deal.deal_id]) {
            return YES;
            break;
        }
    }
    return NO;
}

#pragma mark - History
// 存档方法
+ (void)history:(LYDeal *)deal{
    // 如果大于8个 则移除最后一个
    if (_historyDeals.count > 8) {
        [_historyDeals removeLastObject];
    }
    
    [_historyDeals insertObject:deal atIndex:0];
    // 存档
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:LYHistoryFile];
}


// 移除存档方法
+ (void)unhistory:(LYDeal *)deal{
    [_historyDeals removeObject:deal];
    // 存档
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:LYHistoryFile];
}

// 读取 deal数组
+ (NSArray *)historyDeals{
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:LYHistoryFile];
}

// 判断以及在存档中的方法
+ (BOOL)isHistory:(LYDeal *)deal{
    for (LYDeal *hisdeal in _historyDeals) {
        if ([hisdeal.deal_id isEqualToString:deal.deal_id]) {
            return YES;
            break;
        }
    }
    return NO;
}



@end
