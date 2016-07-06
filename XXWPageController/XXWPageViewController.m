//
//  XXWPageViewController.m
//  XXWPageController
//
//  Created by dllo on 16/6/2.
//  Copyright © 2016年 xuxiwen. All rights reserved.
//

#import "XXWPageViewController.h"



@interface XXWPageViewController ()<UIScrollViewDelegate>

/** 标题 ScrollView */
@property (nonatomic, strong) UIScrollView *titleScrollView;
/** 内容 ScrollView */
@property (nonatomic, strong) UIScrollView *contentScrollView;

/** 指示器视图 */
@property (nonatomic, strong) UIView *indicatorView;

/** 选中标题按钮 */
@property (nonatomic, strong) UIButton *selTitleButton;

/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation XXWPageViewController



- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithVCArr:(NSArray <NSString *> *)VCArr titleStrArr:(NSArray <NSString *> *)titleStrArr
{
    self = [super init];
    if (self) {
        [self addChildViewControllerWithVCArr:VCArr];
        [self setupContentScrollView];
        [self setUpTitleScrollViewWithTitleStrArr:titleStrArr];
    }
    return self;
    
}


#pragma mark - 设置标题
- (void)setUpTitleScrollViewWithTitleStrArr:(NSArray <NSString *> *)titleStrArr
{
    
    CGRect rect = CGRectMake(0, TitleY, XXWScreenW, TitleH);
    
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    _titleScrollView.backgroundColor = TitileBackgroundColor;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.bounces = TitileBounces;
    [self.view addSubview:_titleScrollView];
    
    // 设置标题
    NSUInteger count = titleStrArr.count;
    
    CGFloat x = 0;
    CGFloat w = TitleW;
    CGFloat h = TitleH;
    
    CGFloat space = (XXWScreenW - (TitleW * TitleNumOfOnePage)) / (TitleNumOfOnePage + 1);
    
    for (int i = 0; i < count; i++)
    {
        x = i * (w + space);
        
        CGRect rect = CGRectMake(x + space, 0, w, h - IndicatorViewH);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        btn.frame = rect;
        btn.tag = i + 1000;
        NSString *title = titleStrArr[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:TitleNormalColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:TitleFontSize];
        
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:btn];
        [self.buttons addObject:btn];
        
        if (i == 0)
        {
            [self titleClick:btn];
            self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, h - IndicatorViewH, btn.frame.size.width, 2)];
            _indicatorView.backgroundColor = IndicatorViewColor;
            [self.titleScrollView addSubview:_indicatorView];

        }
    }
    self.titleScrollView.contentSize = CGSizeMake(count * (w + space) + space, 0);
}


#pragma mark - 标题点击事件

- (void)titleClick:(UIButton *)button
{
    [self selTitleBtn:button];
    NSUInteger i = button.tag - 1000;
    CGFloat x = i * XXWScreenW;
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.indicatorView.frame = CGRectMake(button.frame.origin.x, TitleH - IndicatorViewH,button.frame.size.width, 2);
    }];
}

#pragma mark -  选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    [self setupTitleCenter:btn];
    [self.selTitleButton setTitleColor:TitleNormalColor forState:UIControlStateNormal]; // 变回原来字体颜色
    self.selTitleButton.transform = CGAffineTransformIdentity; //变回原来样式
    [btn setTitleColor:TitleSelectedColor forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(MaxTitleScale, MaxTitleScale);
    self.selTitleButton = btn;
}


#pragma mark - 添加子控制器

- (void)addChildViewControllerWithVCArr:(NSArray <NSString *> *)VCArr
{
    // 添加子控制器
    NSInteger count = VCArr.count;
    for (NSInteger i = 0; i < count; i++) {
        Class VCClass = NSClassFromString(VCArr[i]);
        UIViewController *vc = [[VCClass alloc] init];
        [self addChildViewController:vc];
     
        
    }
}

#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGRect rect = CGRectMake(0, TitleY + TitleH, XXWScreenW, XXWScreenH - TitleH - TitleY);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
        _contentScrollView.backgroundColor = ContentBackgroundColor;
    [self.view addSubview:_contentScrollView];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = ContentBounces;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * XXWScreenW, 0);
}

#pragma mark - 添加控制器到视图
- (void)setUpOneChildViewController:(NSInteger)i
{
    CGFloat x = i * XXWScreenW;
    UIViewController *vc = self.childViewControllers[i];
    
    // 如果父视图存在 表明已经添加直接返回
    if ([self.contentScrollView.subviews containsObject:vc.view]) {
        return;
    }

    vc.view.frame = CGRectMake(x, 0, XXWScreenW, self.contentScrollView.frame.size.height);
    [self.contentScrollView addSubview:vc.view];
}



#pragma mark - 计算Title 位置居中
- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - XXWScreenW * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - XXWScreenW;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / XXWScreenW;
    [self selTitleBtn:_buttons[i]];
    [self setUpOneChildViewController:i];
    
    UIButton *btn = [self.titleScrollView viewWithTag:1000 + i];
    [UIView animateWithDuration:0.5 animations:^{
        self.indicatorView.frame = CGRectMake(btn.frame.origin.x, TitleH - IndicatorViewH,btn.frame.size.width, 2);
    }];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / XXWScreenW;
    NSInteger rightIndex = leftIndex + 1;
    
    //    NSLog(@"%zd,%zd",leftIndex,rightIndex);
    
    UIButton *leftButton = self.buttons[leftIndex];
    
    UIButton *rightButton = nil;
    if (rightIndex < self.buttons.count) {
        rightButton = self.buttons[rightIndex];
    }
    CGFloat scaleR = offsetX / XXWScreenW - leftIndex;
    CGFloat scaleL = 1 - scaleR;
    
    
    CGFloat transScale = MaxTitleScale - 1;
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
   // 颜色渐变
    
    CGFloat r=0,g=0,b=0,a=0;
        const CGFloat *components = CGColorGetComponents(TitleSelectedColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    
    UIColor *rightColor = [UIColor colorWithRed:scaleR *r green:g * scaleR blue:b * scaleR alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL *r green:g * scaleR blue:b * scaleR alpha:1];
    
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
