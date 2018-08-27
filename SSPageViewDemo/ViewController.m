//
//  ViewController.m
//  SSPageViewDemo
//
//  Created by RockXeng on 2018/8/27.
//  Copyright © 2018年 ShuSheng. All rights reserved.
//

#import "ViewController.h"
#import "BDPageCountView.h"

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, BDPageCountViewDelegate,BDPageCountViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BDPageCountView *countView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"pageViewDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.countView = [[BDPageCountView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, SCREEN_HEIGHT - 80.f - 64.f, 45.f, 45.f) tableView:self.tableView];
    self.countView.delegate = self;
    self.countView.dataSource = self;
    
    [self.view addSubview:self.countView];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 200; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"第%ld个cell",(long)i]];
        }
    }
    
    return _dataArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - BDCountViewDataSource
- (NSString *)numbersOfTotalPageInPageCountView {
    return [NSString stringWithFormat:@"%ld", (long)self.dataArray.count];
}

- (NSString *)numbersOfPerPageInPageCountView {
    return @"20";
}

#pragma mark - BDCountViewDelegate
- (void)countViewDidClickBackTop:(BDPageCountView *)pageCountView {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_countView) {
        [_countView pageCountViewScrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_countView) {
        [_countView pageCountViewScrollViewDidEndDecelerating];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_countView) {
        [_countView pageCountViewScrollViewWillBeginDecelerating];
    }
}


@end
