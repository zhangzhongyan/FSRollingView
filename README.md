# FSRollingView

iOS可定制空间，跑马灯、LED效果。 使用加入重用机制，标准数据源委托协议，更容易嵌入。

#### 版本修改

|  版本   | 修改内容  |
|  ----  | ----  |
| v1.0.0  | 支持竖直方向LED效果 |

请查看workspace工中的**Example**示例项目。 下载后，您将需要运行pod install。


# 示例代码

```

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


```





