//
//  JDGuideView.m
//  JDGuide
//
//  Created by 黄景达 on 15/11/2.
//  Copyright © 2015年 youruncle. All rights reserved.
//

//当前屏幕的宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "JDGuideView.h"
#import "AppDelegate.h"


@interface JDGuideView ()

@property (nonatomic,retain) UIViewController *rootViewController;
@property (nonatomic,retain) UIPageControl *page;
@property (nonatomic,retain) NSArray *imageArray;//图片数组
@property (nonatomic) BOOL isWrite;
@property (nonatomic) BOOL hasButton;


@end
@implementation JDGuideView

- (instancetype)initWithImageArray:(NSArray *)imageArray isForFirstOnce:(BOOL)once hasButton:(BOOL)btn{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        //获取根视图
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.window.backgroundColor = [UIColor whiteColor];
        self.rootViewController = app.window.rootViewController;
        
        self.rootViewController.view.hidden = YES;
        self.rootViewController.view.alpha = 0;
        //如果没有图片,直接进入主界面
        if (imageArray.count == 0) {
            [self goMain];
            return self;
        }
        self.isWrite = once;
        self.hasButton = btn;
        self.imageArray = imageArray;
    }
    return self;
}

+ (id)jdGuideWithImageArray:(NSArray *)imageArray isForFirstOnce:(BOOL)once hasButton:(BOOL)btn{
    JDGuideView *guide = [[JDGuideView alloc]initWithImageArray:imageArray isForFirstOnce:once hasButton:btn];
    
    return guide;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    
    //判断userDefaults存的版本号是否是当前版本号 从而判断是否需要进入引导页
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [userDefaults valueForKey:@"login"];
    
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([version isEqualToString:currentVersion]) {
        [self goMain];//进入主界面
    }else{
        [self goGuide];//进入引导页
    }
}

//进入主界面
- (void)goMain{
    
    [UIView animateWithDuration:0.8 animations:^{
        //主界面取消隐藏
        self.rootViewController.view.hidden = NO;
        self.rootViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        //判断是否需要写入userdefaults 第二次进入不用在进入引导页
        if (self.isWrite == YES) {
            [self writeToUserdefaults];
        }
        [self removeFromSuperview];//移除本身
    }];
}

//进入引导页
- (void)goGuide{
    //通过scrollView 将这些图片添加在上面，从而达到滚动这些图片
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollV.contentSize = CGSizeMake(kScreenWidth*(self.imageArray.count+1),0);//加1是因为最后一张给他空图
    scrollV.pagingEnabled=YES;
    //隐藏滚动条
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.delegate=self;
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imageV.image = [UIImage imageNamed:self.imageArray[i]];
        imageV.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight);
        [scrollV addSubview:imageV];
    }
    if (self.hasButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth/2 - 100/375.0*kScreenWidth, 530/667.0*kScreenHeight, 200/375.0*kScreenWidth, 50);
        [btn setTitle:@"点击进入" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.layer.cornerRadius = 8;
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [scrollV addSubview:btn];
    }
    [self addSubview:scrollV];
    //page
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 90/375.0*kScreenWidth, kScreenHeight-30, 180/375.0*kScreenWidth, 20)];
    self.page.numberOfPages = self.imageArray.count;
    [self addSubview:self.page];
}

//点击button事件
- (void)action:(UIButton *)button{
    //如果代理存在且响应方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideButtonAction:)]) {
        [self goMain];
        [self.delegate guideButtonAction:button];
    }else{
        //如果不存在代理,则默认进入主页面
        [self goMain];
    }
    
}

#pragma mark scrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滚动到倒数第二张,开始根据偏移量来控制scrollview的透明度
    if (scrollView.contentOffset.x > (self.imageArray.count-1)*kScreenWidth) {
        //偏移量
        CGFloat offset = scrollView.contentOffset.x - (self.imageArray.count-1)*kScreenWidth;
        //渐变效果
        CGFloat alpha = offset/kScreenWidth;
        scrollView.alpha = 1 - alpha;
        
    }
    
    if (scrollView.contentOffset.x == self.imageArray.count*kScreenWidth) {
        
        [self goMain];//进入主界面
        
    }
    
}
//写入userDefaults
- (void)writeToUserdefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取当前app版本号
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [userDefaults setObject:version forKey:@"login"];
}

//停止减速后切换page值
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.page.currentPage = scrollView.contentOffset.x/kScreenWidth;
}

@end
