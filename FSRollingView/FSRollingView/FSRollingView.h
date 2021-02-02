//
//  FSRollingView.h
//  Fargo
//
//  Created by 张忠燕 on 2020/9/15.
//  Copyright © 2020 geekthings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSRollingViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class FSRollingView;
@protocol FSRollingViewDataSource <NSObject>
@optional
/// 滚动视图大小
- (CGSize)sizeForRollingView:(FSRollingView *)rollingView;
@required
/// 几个滚动数据可见
- (NSUInteger)numberOfRowsVisiableRollingView:(FSRollingView *)rollingView;
/// 总共几个滚动数据
- (NSInteger)numberOfRowsInRollingView:(FSRollingView *)rollingView;
/// 滚动单元
- (FSRollingViewCell *)rollingView:(FSRollingView *)rollingView cellForRowAtIndex:(NSInteger)index;
@end

@protocol FSRollingViewDelegate <NSObject>
- (void)rollingView:(FSRollingView *)tableView didSelectRowAtIndex:(NSInteger)index;
@end

/// 跑马灯
@interface FSRollingView : UIView

/// 滚动间隙
@property (nonatomic, assign) NSTimeInterval rollingInterval;

/// 数据源
@property (nonatomic, weak) id<FSRollingViewDataSource> dataSource;

/// 委托
@property (nonatomic, weak) id<FSRollingViewDelegate> delegate;

/// 注册重用Cell
/// @param cellClass FSRollingViewCell子类
/// @param identifier 重用标识
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/// 取出重用Cell
/// @param identifier 重用标识
- (nullable __kindof FSRollingViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

/// 加载数据
- (void)reloadData;

/// 开始滚动
- (void)startRolling;

/// 暂停滚动
- (void)stopRolling;

@end

NS_ASSUME_NONNULL_END
