//
//  LYSearchResultController.m
//  美团HD
//
//  Created by lynn on 16/3/12.
//  Copyright © 2016年 lynn. All rights reserved.
//

#import "LYSearchResultController.h"
#import "LYLocalPlistTool.h"
#import "LYCities.h"
@interface LYSearchResultController ()

@property (nonatomic, strong)NSArray *result;
@end

@implementation LYSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 重写搜索源的set方法 实时更新数据
- (void)setSearchSource:(NSString *)searchSource{
    
    _searchSource = searchSource;
    
    self.result = nil;
    // 拿到模型数据
    NSString *searchLowCase = searchSource.lowercaseString;
    
    NSArray *cities = [LYLocalPlistTool cities];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchLowCase, searchLowCase, searchLowCase];
    
    self.result = [cities filteredArrayUsingPredicate:predicate];

    
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"一共有%zd个搜索结果",self.result.count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"resultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    LYCities *city = self.result[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

#pragma mark tableView 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // dismiss 控制器 并且发送通知
    [self dismissViewControllerAnimated:YES completion:nil];
        // 拿到对应的模型
    LYCities *city = self.result[indexPath.row];
    NSDictionary *userInfo = @{LYCityCurrentKey:city};
        
    [LYNoteCenter postNotificationName:LYCityDidChangedNoty object:nil userInfo:userInfo];
    ;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
