//
//  FSRollingViewCell.h
//  Fargo
//
//  Created by 张忠燕 on 2020/9/16.
//  Copyright © 2020 geekthings. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSRollingViewCell : UIView

/// 重用标识
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

/// 点击回调
@property (nonatomic, copy, nullable) void (^clickBlock) (void);

/// 指定构造方法
/// @param reuseIdentifier 重用标示
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
