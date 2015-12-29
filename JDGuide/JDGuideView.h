//
//  JDGuideView.h
//  JDGuide
//
//  Created by 黄景达 on 15/11/2.
//  Copyright © 2015年 youruncle. All rights reserved.
//
//

/* ------使用说明--------*/

 /*
 
 
    viewController 传入你的RootController
    imageArray 传入一个image数组,里面存放imageName
    once  YES表示只第一次进入引导页,NO 表示每次都进入
    btn   YES表示第一页有点击进入主页按钮,NO 则没有
  
  ** 如果想重写按钮点击事件,请接受代理
  
 */

#import <UIKit/UIKit.h>

@protocol JDGuideDelegate <NSObject>

//代理方法
- (void)guideButtonAction:(UIButton *)button;


@end

@interface JDGuideView : UIView<UIScrollViewDelegate>

@property (nonatomic) id<JDGuideDelegate>delegate;
//初始化方法
- (instancetype)initWithImageArray:(NSArray *)imageArray isForFirstOnce:(BOOL)once hasButton:(BOOL)btn;

//便利构造器
+ (id)jdGuideWithImageArray:(NSArray *)imageArray isForFirstOnce:(BOOL)once hasButton:(BOOL)btn;

@end
