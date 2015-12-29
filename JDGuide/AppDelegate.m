//
//  AppDelegate.m
//  JDGuide
//
//  Created by 黄景达 on 15/11/2.
//  Copyright © 2015年 youruncle. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "JDGuideView.h"

@interface AppDelegate ()<JDGuideDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *rootVC = [[RootViewController alloc]init];
    UINavigationController *navig = [[UINavigationController alloc]initWithRootViewController:rootVC];
    self.window.rootViewController = navig;
    
    
    
    
    //图片数组
    NSArray *imageArray = [NSArray arrayWithObjects:@"navigationPic01",@"navigationPic02",@"navigationPic03",@"navigationPic04",nil];
    //    NSArray *imageArray = [NSArray arrayWithObjects:@"1.jpg",@"2.jpeg",@"3.png",@"4.jpg",nil];
    //创建引导页
    JDGuideView *guideView = [[JDGuideView alloc]initWithImageArray:imageArray isForFirstOnce:NO hasButton:YES];
    [self.window addSubview:guideView];
    
    
    
    
    
    
    
    
    
    
    //便利构造器
//    JDGuideView *guideView = [JDGuideView jdGuideWithImageArray:imageArray isForFirstOnce:NO hasButton:YES];
    
    
    //重写button点击事件才接受代理,默认进入主界面
    guideView.delegate = self;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)guideButtonAction:(UIButton *)button{
    NSLog(@"点击就送");
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
