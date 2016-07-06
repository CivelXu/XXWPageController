//
//  XXWPageViewController.h
//  XXWPageController
//
//  Created by dllo on 16/6/2.
//  Copyright © 2016年 xuxiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXWPageViewController : UIViewController

// 宏定义修改相关属性即可
#define XXWScreenW [UIScreen mainScreen].bounds.size.width
#define XXWScreenH [UIScreen mainScreen].bounds.size.height
#define MaxTitleScale 1.2
#define TitleH 30
#define TitleY 0
#define TitleW 30
#define TitleNumOfOnePage 3
#define TitleFontSize 14

#define TitileBackgroundColor [UIColor whiteColor]
#define ContentBackgroundColor [UIColor whiteColor]

#define TitleNormalColor [UIColor blackColor]
#define TitleSelectedColor [UIColor orangeColor]
#define TitileBounces YES
#define ContentBounces YES

#define IndicatorViewH 2
#define IndicatorViewColor [UIColor redColor]


/**
*  初始化方法
*
*  @param VCArr   传递视图控制器对象
*  @param titleStrArr  标题数组 (NSString *)
*
*  @return 视图对象
*/

- (instancetype)initWithVCArr:(NSArray *)VCArr titleStrArr:(NSArray <NSString *> *)titleStrArr;







@end
