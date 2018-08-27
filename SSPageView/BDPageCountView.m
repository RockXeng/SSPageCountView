//
//  BDPageCountView.m
//  pluto
//
//  Created by RockXeng on 2018/8/7.
//  Copyright © 2018年 bertadata. All rights reserved.
//

#import "BDPageCountView.h"

@interface BDPageNumberView()

@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, copy) NSString *currentNumber;
@property (nonatomic, copy) NSString *totalNumber;

@end

@implementation BDPageNumberView
{
    CGFloat _height;
    CGFloat _width;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _width = frame.size.width;
        _height = (frame.size.height - 1)/2;
        
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        
        _currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.f, _width, _height - 5)];
        _currentLabel.textColor = [UIColor grayColor];
        _currentLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_currentLabel];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor lightGrayColor].CGColor;
        line.frame = CGRectMake(10.f, CGRectGetMaxY(_currentLabel.frame), _width - 10.f*2, 1.f);
        
        [self.layer addSublayer:line];
        
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), _width, _height - 5.f)];
        _totalLabel.textColor = [UIColor grayColor];
        _totalLabel.font = [UIFont systemFontOfSize:11.f];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_totalLabel];
    }
    
    return self;
}

- (void)updateWithCurrentNumber:(NSString *)currentNumber
                    totalNumber:(NSString *)totalNumebr {
    if (![totalNumebr isEqualToString:_totalNumber]) {
        _totalNumber = totalNumebr;
        _totalLabel.text = _totalNumber;
    }
    
    if ([currentNumber isEqualToString:_currentNumber]) {
        return;
    }
    
    if (_currentNumber && _currentNumber.length > 0) {
        if ([_currentNumber integerValue] > [currentNumber integerValue]) {//数字变小
            _currentNumber = currentNumber;
            _currentLabel.text = _currentNumber;
            
            _currentLabel.alpha = 0;
            _currentLabel.frame = CGRectMake(_currentLabel.frame.origin.x, _currentLabel.frame.origin.y -_height, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
            
            [UIView animateWithDuration:0.3f animations:^{
                self.currentLabel.alpha = 1;
                self.currentLabel.frame = CGRectMake(self.currentLabel.frame.origin.x, 5.f, self.currentLabel.frame.size.width, self.currentLabel.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        } else {
            _currentNumber = currentNumber;
            _currentLabel.text = _currentNumber;
            
            _currentLabel.alpha = 0;
            _currentLabel.frame = CGRectMake(_currentLabel.frame.origin.x, _height, _currentLabel.frame.size.width, _currentLabel.frame.size.height);
            
            [UIView animateWithDuration:0.3f animations:^{
                self.currentLabel.alpha = 1;
                self.currentLabel.frame = CGRectMake(self.currentLabel.frame.origin.x, 5.f, self.currentLabel.frame.size.width, self.currentLabel.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    } else {
        _currentNumber = currentNumber;
        _currentLabel.text = _currentNumber;
    }
}

@end

@interface BDPageCountView()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;

@end

@implementation BDPageCountView

- (instancetype)initWithFrame:(CGRect)frame
                    tableView:(UITableView *)tableView {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = tableView;
        
        _pageNumberView = [[BDPageNumberView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _pageNumberView.alpha = 0;
        
        [self addSubview:_pageNumberView];
        
        _backTopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_backTopButton setImage:[UIImage imageNamed:@"BackTop"] forState:UIControlStateNormal];
        [_backTopButton addTarget:self action:@selector(backTopAction:) forControlEvents:UIControlEventTouchUpInside];
        _backTopButton.alpha = 0;
        
        [self addSubview:_backTopButton];
    }
    
    return self;
}

- (void)backTopAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(countViewDidClickBackTop:)]) {
        [self.delegate countViewDidClickBackTop:self];
    }
}

- (void)refreshViewWithCurrentNumber:(NSString *)currentNumber
                         totalNumber:(NSString *)totalNumber {
    [_pageNumberView updateWithCurrentNumber:currentNumber totalNumber:totalNumber];
}

- (void)pageCountViewScrollViewDidScroll {
    if (!(self.dataSource && [self.dataSource respondsToSelector:@selector(numbersOfTotalPageInPageCountView)] && [self.dataSource respondsToSelector:@selector(numbersOfPerPageInPageCountView)])) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    NSInteger currentRow = currentIndexPath.row + 1;
    
    if (currentIndexPath.section > 0) {
        currentRow = currentIndexPath.section + 1;
    }
    
    NSInteger perCount = [[self.dataSource numbersOfPerPageInPageCountView] integerValue];
    NSString *resultCount = [self.dataSource numbersOfTotalPageInPageCountView];
    
    self.currentPageNumber = currentRow/perCount;
    NSInteger restPageNumber = currentRow%perCount;
    if (restPageNumber != 0) {
        self.currentPageNumber ++;
    }
    
    NSString *totalNumber = @"";
    if ([resultCount containsString:@"+"]) {
        resultCount = [resultCount stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        totalNumber = [NSString stringWithFormat:@"%ld+", [resultCount integerValue]/perCount];
        self.totalPageNumber = [[totalNumber stringByReplacingOccurrencesOfString:@"+" withString:@""] integerValue];
    } else {
        NSInteger pageNumber = [resultCount integerValue]/perCount;
        NSInteger restNumebr = [resultCount integerValue]%perCount;
        if (restNumebr != 0) {
            pageNumber ++;
        }
        
        totalNumber = [NSString stringWithFormat:@"%ld", pageNumber];
        self.totalPageNumber = pageNumber;
    }
    
    [self refreshViewWithCurrentNumber:[NSString stringWithFormat:@"%ld", self.currentPageNumber] totalNumber:totalNumber];
}

- (void)pageCountViewScrollViewDidEndDecelerating {
    [UIView animateWithDuration:0.3f animations:^{
        if (self.currentPageNumber > 1) {
            self.backTopButton.alpha = 1.f;
        } else {
            self.backTopButton.alpha = 0.f;
        }
        self.pageNumberView.alpha = 0.f;
    }];
}

- (void)pageCountViewScrollViewWillBeginDecelerating {
    [UIView animateWithDuration:0.3f animations:^{
        if (self.totalPageNumber > 1) {
            self.pageNumberView.alpha = 1.f;
            self.backTopButton.alpha = 0.f;
        } else {
            self.pageNumberView.alpha = 0.f;
            self.backTopButton.alpha = 0.f;
        }
    }];
}

@end
