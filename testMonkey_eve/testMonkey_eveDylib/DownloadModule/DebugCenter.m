

//
//  DebugCenter.m
//  TogetherHomeworkDylib
//
//  Created by john on 2018/4/23.
//  Copyright © 2018 john. All rights reserved.
//

#import "DebugCenter.h"
#import "DebugViewController.h"
#import "ZFDownloadViewController.h"

static DebugCenter *intance;

@interface DebugCenter ()

@property (nonatomic) UIWindow *debugWindow;

@end

@implementation DebugCenter

+ (DebugCenter *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        intance = [[DebugCenter alloc] init];
    });
    return intance;
}

- (void)showDebugCenter {
    
    __block CGRect frame = self.debugWindow.frame;
    frame.origin.y = frame.size.height;
    self.debugWindow.frame = frame;

   
    
    ZFDownloadViewController *debugCenterViewController = [[ZFDownloadViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:debugCenterViewController];
    self.debugWindow.rootViewController = nav;
    
    self.debugWindow.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        frame = self.debugWindow.frame;
        frame.origin.y = 0;
        self.debugWindow.frame = frame;
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
    
}

- (void)hiddenDebugCenter {
    
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.debugWindow.frame;
        frame.origin.y = frame.size.height;
        self.debugWindow.frame = frame;
    } completion:^(BOOL finished) {
        self.debugWindow.hidden = YES;
        self.isShow = NO;
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _debugWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _debugWindow.hidden = YES;
        _debugWindow.backgroundColor = [UIColor whiteColor];
        _debugWindow.windowLevel = UIWindowLevelNormal + 1;
    }
    return self;
}

@end
