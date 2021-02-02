//
//  ViewController.m
//  Example
//
//  Created by 张忠燕 on 2020/6/12.
//  Copyright © 2020 张忠燕. All rights reserved.
//

#import "ViewController.h"
#import <FSRollingView/FSRollingView.h>
#import <Masonry/Masonry.h>

@interface ViewController ()<FSRollingViewDataSource, FSRollingViewDelegate>

@property (nonatomic, strong) FSRollingView *rollingView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view addSubview:self.rollingView];
    [self.rollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self.view);
        make.height.equalTo(@(200));
    }];
    
    [self.rollingView reloadData];
    [self.rollingView startRolling];
}


#pragma mark - <FSRollingViewDataSource>

/// 几个滚动数据可见
- (NSUInteger)numberOfRowsVisiableRollingView:(FSRollingView *)rollingView
{
    return 1;
}
/// 总共几个滚动数据
- (NSInteger)numberOfRowsInRollingView:(FSRollingView *)rollingView
{
    return 20;
}

/// 滚动单元
- (FSRollingViewCell *)rollingView:(FSRollingView *)rollingView cellForRowAtIndex:(NSInteger)index
{
    FSRollingViewCell *cell = [rollingView dequeueReusableCellWithIdentifier:NSStringFromClass(FSRollingViewCell.class)];
    
    UILabel *textLabel = [cell viewWithTag:100];
    if (!textLabel) {
        textLabel = [[UILabel alloc] init];
        [cell addSubview:textLabel];
        textLabel.tag = 100;
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
    }
    
    textLabel.text = [NSString stringWithFormat:@"%ld", index];
    
    return cell;
}

- (CGSize)sizeForRollingView:(FSRollingView *)rollingView
{
    return CGSizeMake(self.view.frame.size.width, 200);
}

#pragma mark - <FSRollingViewDelegate>

- (void)rollingView:(FSRollingView *)tableView didSelectRowAtIndex:(NSInteger)index
{
    
}

#pragma mark - property

- (FSRollingView *)rollingView {
    if (!_rollingView) {
        _rollingView = [[FSRollingView alloc] initWithFrame:CGRectZero];
        [_rollingView registerClass:FSRollingViewCell.class forCellReuseIdentifier:NSStringFromClass(FSRollingViewCell.class)];
        _rollingView.dataSource = self;
        _rollingView.delegate = self;
        _rollingView.rollingInterval = 2;
        _rollingView.clipsToBounds = YES;
        _rollingView.backgroundColor = [UIColor whiteColor];
    }
    return _rollingView;
}


@end
