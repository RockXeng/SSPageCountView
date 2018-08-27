//
//  BDPageCountView.h
//  pluto
//
//  Created by RockXeng on 2018/8/7.
//  Copyright © 2018年 bertadata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BDPageCountView;

@protocol BDPageCountViewDelegate <NSObject>

- (void)countViewDidClickBackTop:(BDPageCountView *)pageCountView;

@end

@protocol BDPageCountViewDataSource <NSObject>

@required
/**
 返回总条数
 */
- (NSString *)numbersOfTotalPageInPageCountView;
/**
 返回每页的条数
 */
- (NSString *)numbersOfPerPageInPageCountView;

@end

@interface BDPageNumberView : UIView

@end

@interface BDPageCountView : UIView

@property (nonatomic, weak) id<BDPageCountViewDelegate> delegate;
@property (nonatomic, weak) id<BDPageCountViewDataSource> dataSource;

@property (nonatomic, strong) BDPageNumberView *pageNumberView;
@property (nonatomic, strong) UIButton *backTopButton;

- (instancetype)initWithFrame:(CGRect)frame
                    tableView:(UITableView *)tableView;

- (void)pageCountViewScrollViewDidScroll;
- (void)pageCountViewScrollViewDidEndDecelerating;
- (void)pageCountViewScrollViewWillBeginDecelerating;

@end
