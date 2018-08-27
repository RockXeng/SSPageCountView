# SSPageCountView
仿京东页码指示器
## 安装
下载项目，然后直接将SSPageView文件夹拖入工程中即可

## 如何使用
要想实现类似于京东的页码功能，只需要下面四个步骤：
1. 在需要使用的.m文件中import"SSPageView.h"
然后遵从 BDPageCountViewDelegate, BDPageCountViewDataSource两个协议,接着初始化pageView：
```
   self.countView = [[BDPageCountView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, SCREEN_HEIGHT - 80.f - 64.f, 45.f, 45.f) tableView:self.tableView];            self.countView.delegate = self;     self.countView.dataSource = self;
   [self.view addSubview:self.countView];
``` 
注意点：要与UITableView配合使用

2. 实现BDPageCountViewDataSource，用于返回数据源（总条数和每页的条数）:
```
- (NSString *)numbersOfTotalPageInPageCountView {
    return [NSString stringWithFormat:@"%ld", (long)self.dataArray.count];
}

- (NSString *)numbersOfPerPageInPageCountView {
    return @"20";
}
```

3. 实现BDCountViewDelegate，用于响应点击事件：
```
- (void)countViewDidClickBackTop:(BDPageCountView *)pageCountView {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
```
4. 实现UIScrollViewDelegate，因为需要根据列表是否滚动来显示页码和返回顶部按钮，所以需要在scrollViewDelegate的两个方法中返回状态：
```
//正在滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_countView) {
        [_countView pageCountViewScrollViewDidScroll];
    }
}

//结束滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_countView) {
        [_countView pageCountViewScrollViewDidEndDecelerating];
    }
}

//开始滑动
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_countView) {
        [_countView pageCountViewScrollViewWillBeginDecelerating];
    }
}
```
## 效果
![image](https://github.com/RockXeng/SSPageCountView/blob/master/image/pageViewDemo.gif)


