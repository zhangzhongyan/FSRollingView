//
//  FSRollingViewCell.m
//  Fargo
//
//  Created by 张忠燕 on 2020/9/16.
//  Copyright © 2020 geekthings. All rights reserved.
//

#import "FSRollingViewCell.h"

@implementation FSRollingViewCell

#pragma mark - Initialize Methods

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self setupInit];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupInit];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupInit
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Event

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
