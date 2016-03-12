//
//  TableViewController.m
//  pullToRefresh
//
//  Created by  songcaili on 16/3/9.
//  Copyright © 2016年  songcaili. All rights reserved.
//

#import "TableViewController.h"
#import "PullToRefreshHeadView.h"

@interface TableViewController () <PullToRefreshHeadViewDelegate> {
    NSInteger _rowCount;
}
@property(nonatomic,strong) PullToRefreshHeadView *refreshView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rowCount = 1;
    _refreshView = [[PullToRefreshHeadView alloc] initWithFrame:CGRectMake(0, -KSCREEN_HEIGHT, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    _refreshView.delegate = self;
    [self.view addSubview:_refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = @"a cell";
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshView refreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}


#pragma mark ---下拉刷新代理
- (void)refreshHeadViewDidTriggerRefresh:(PullToRefreshHeadView *)headView {
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
}

- (void)loadData {
    _rowCount++;
    [self.tableView reloadData];
    [_refreshView refreshScrollViewDidFinishedLoading:self.tableView];
}
@end
