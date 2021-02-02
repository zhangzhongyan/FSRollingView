//
//  FSRollingView.m
//  Fargo
//
//  Created by 张忠燕 on 2020/9/15.
//  Copyright © 2020 geekthings. All rights reserved.
//

#import "FSRollingView.h"

@interface FSRollingView ()

@property (nonatomic, strong) NSMutableDictionary *reuseDict;

@property (nonatomic, strong) NSMutableArray<FSRollingViewCell *> *reuseCells;

@property (nonatomic, strong) NSMutableArray<FSRollingViewCell *> *visiableCells;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) NSInteger rollingInex;

@property (nonatomic, assign) NSInteger visiableCount;

@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation FSRollingView

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews
{
    self.clipsToBounds = YES;
}

- (void)startTimer
{
    [self stopTimer];
    
    //定时器大于0秒才能滚动
    if (self.rollingInterval > 0) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.rollingInterval target:self selector:@selector(automaticRolling) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)automaticRolling
{
    //滚动当前位置
    [self rollingWithIndex:self.rollingInex];
    
    //下一个滚动位置
    self.rollingInex++;
    
    //最后位置，重置第一个
    if (self.rollingInex >= self.totalCount) {
        self.rollingInex = 0;
    }
}

- (void)rollingWithIndex:(NSInteger)index
{
    //数据为0
    if (!self.totalCount) {
        return;
    }
    
    //刚好一屏显示完
    if (self.totalCount <= self.visiableCount && self.visiableCells.count >= self.totalCount) {
        return;
    }
    
    //取出视图
    FSRollingViewCell *cell = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(rollingView:cellForRowAtIndex:)]) {
        cell = [self.dataSource rollingView:self cellForRowAtIndex:index];
    }
    
    __weak __typeof__(self) weakSelf = self;
    cell.clickBlock = ^{
        __strong __typeof(self) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(rollingView:didSelectRowAtIndex:)]) {
            [strongSelf.delegate rollingView:strongSelf didSelectRowAtIndex:index];
        }
    };
    [self.reuseCells removeObject:cell];
    
    //先放在边缘
    CGSize size = self.bounds.size;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sizeForRollingView:)]) {
        size  = [self.dataSource sizeForRollingView:self];
    }
    CGFloat height = size.height / self.visiableCount;
    cell.frame = CGRectMake(0.0f, size.height, size.width, height);
    [self addSubview:cell];
    
    //入可见队列
    if (cell) {
        [self.visiableCells addObject:cell];
    }
    
    if (self.visiableCells.count <= self.visiableCount) {
        
        CGFloat originY =  (size.height - height * self.visiableCells.count) / 2.0f;
        [UIView animateWithDuration:0.7f animations:^{
            __strong __typeof(self) strongSelf = weakSelf;

            for (int i = 0; i < strongSelf.visiableCells.count; i++) {
                
                FSRollingViewCell *item = [strongSelf.visiableCells objectAtIndex:i];
                item.frame = CGRectMake(0.0f, originY  + height * i, size.width, height);
            }
        } completion:nil];
    }
    //铺满
    else {
        
        //动画完成后进入重用队列
        FSRollingViewCell *cell = self.visiableCells.firstObject;
        [self.visiableCells removeObject:cell];
        
        __weak __typeof__(cell) weakCell = cell;
        [UIView animateWithDuration:0.7f animations:^{
            __strong __typeof(self) strongSelf = weakSelf;
            __strong __typeof(cell) strongCell = weakCell;

            strongCell.frame = CGRectMake(0.0f, -height, size.width, height);
            for (int i = 0; i < strongSelf.visiableCells.count; i++) {
                FSRollingViewCell *item = [strongSelf.visiableCells objectAtIndex:i];
                item.frame = CGRectMake(0.0f, height * i, size.width, height);
            }
        } completion:^(BOOL finished) {
            __strong __typeof(self) strongSelf = weakSelf;
            __strong __typeof(cell) strongCell = weakCell;
            
            [strongCell removeFromSuperview];
            if (strongCell) {
                [strongSelf.reuseCells addObject:strongCell];
            }
        }];
    }
}

#pragma mark - Public Methods

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.reuseDict setObject:NSStringFromClass(cellClass) forKey:identifier];
}

- (nullable __kindof FSRollingViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    for (FSRollingViewCell *cell in self.reuseCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            return cell;
        }
    }
    
    //只考虑Class注册
    Class cellCls = NSClassFromString(self.reuseDict[identifier]);
    FSRollingViewCell *cell = [[cellCls alloc] initWithReuseIdentifier:identifier];
    return cell;
}

- (void)reloadData
{
    //重置数据
    self.rollingInex = 0;
    self.visiableCount = 0;
    self.totalCount = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsVisiableRollingView:)]) {
        self.visiableCount = [self.dataSource numberOfRowsVisiableRollingView:self];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInRollingView:)]) {
        self.totalCount = [self.dataSource numberOfRowsInRollingView:self];
    }
    
    //重置页面
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.reuseCells removeAllObjects];
    [self.visiableCells removeAllObjects];
    
    if (self.totalCount) {
        [self automaticRolling];
    }
}

- (void)startRolling
{
    [self startTimer];
}

- (void)stopRolling
{
    [self stopTimer];
}

#pragma mark - property

- (NSMutableDictionary *)reuseDict {
    if (!_reuseDict) {
        _reuseDict = [NSMutableDictionary dictionary];
    }
    return _reuseDict;
}

- (NSMutableArray<FSRollingViewCell *> *)reuseCells {
    if (!_reuseCells) {
        _reuseCells = [NSMutableArray array];
    }
    return _reuseCells;
}

- (NSMutableArray<FSRollingViewCell *> *)visiableCells {
    if (!_visiableCells) {
        _visiableCells = [NSMutableArray array];
    }
    return _visiableCells;
}

@end
