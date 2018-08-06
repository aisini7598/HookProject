//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  testMonkey_eveDylib.m
//  testMonkey_eveDylib
//
//  Created by js on 2017/12/27.
//  Copyright (c) 2017年 js. All rights reserved.
//

#import "testMonkey_eveDylib.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
//#import <CydiaSubstrate/CydiaSubstrate.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DebugWindow.h"

#import <ZFDownload/ZFDownloadManager.h>

#import "Popview.h"
#import "TVList.h"

@interface CustomViewController

-(NSString*)getMyName;

@end

@interface newVideoPlayViewController

- (UIView *)view;

- (NSString *)videoUrl;

- (void)setVideoUrl:(NSString *)url;

- (void)download:(UIButton *)sender;

- (void)showTVList:(UIButton *)sender;

- (void)playerDownload:(NSString *)url withVideoName:(NSString *)videoName;

@property (nonatomic, copy) NSString *videoName;

@end

CHDeclareClass(CustomViewController)

CHOptimizedMethod(0, self, NSString*, CustomViewController,getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    //change the value
    return @"AloneMonkey";
    
}

//CHConstructor{
//    CHLoadLateClass(CustomViewController);
//    CHClassHook(0, CustomViewController, getMyName);
//}
//
//声明AppDelegate类
CHDeclareClass(AppDelegate);

CHMethod(2, void, AppDelegate, application, id, arg1, didFinishLaunchingWithOptions, id, arg2)
{
    //设置进入视频界面
    [[NSUserDefaults standardUserDefaults]  setValue:@"NO" forKey:@"tihuo"];
    //调用原来的AsyncOnAddMsg:MsgWrap:方法
    CHSuper(2, AppDelegate, application, arg1, didFinishLaunchingWithOptions, arg2);
}

CHOptimizedMethod1(self, void, AppDelegate, setWindow, UIWindow *, window) {
    DebugWindow *debugWindow = [[DebugWindow alloc] initWithFrame:window.frame];
    ;
    CHSuper1(AppDelegate, setWindow, debugWindow);
}

CHDeclareClass(UIPasteboard);
CHClassMethod(0, id, UIPasteboard, generalPasteboard) {
    return nil;
}

CHDeclareClass(AD_dataManager);
CHClassMethod(0, id, AD_dataManager, shareInstance) {
    return nil;
}

CHDeclareClass(newVideoPlayViewController);




CHDeclareMethod1(void, newVideoPlayViewController, download, UIButton *, sender) {
    NSLog(@"click me");
    
    id obj = sender;
    
    while (![obj isKindOfClass:[UIViewController class]]) {
        obj = [obj nextResponder];
    }
    
    NSString *videoUrl = [(newVideoPlayViewController *)obj videoUrl];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:videoUrl]];
    
    [self playerDownload:videoUrl withVideoName:self.videoName];
}

CHDeclareMethod1(void, newVideoPlayViewController, showTVList, UIButton *,sender) {
    NSLog(@"");
    
    id obj = sender;
    
    while (![obj isKindOfClass:[UIViewController class]]) {
        obj = [obj nextResponder];
    }
    
    NSString *videoUrl = [(newVideoPlayViewController *)obj videoUrl];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:videoUrl]];
    
//    TVList *list = [[TVList alloc] initWithBounds:CGRectMake(0, 0, 200, 250)];
//
//    id obj = sender;
//
//    while (![obj isKindOfClass:[UIViewController class]]) {
//        obj = [obj nextResponder];
//    }
//
//    UIView *view = [(UIViewController *)obj view];
//
//    Popview *popView = [[Popview alloc] initWithFrame:view.bounds];
//
//    popView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//
//    [popView popView:[list view]];
//
//    [popView showPopViewInView:view atPoint:[view convertPoint:sender.center fromView:sender.superview]];
    
}

CHDeclareMethod2(void, newVideoPlayViewController, playerDownload, NSString *, url, withVideoName, NSString *, fileName) {
    NSString *name = fileName;
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}



CHOptimizedMethod3(self, id, newVideoPlayViewController, initWithUrl, NSString *, arg1, VideoType, id, arg2, data, id, arg3) {
    id obj = CHSuper3(newVideoPlayViewController, initWithUrl, arg1, VideoType, arg2, data, arg3);
    [self setVideoUrl:arg1];
    [self setVideoName:[arg3 title]];
    return obj;
}

CHOptimizedMethod0(self, void, newVideoPlayViewController, viewDidLoad) {
    CHSuper0(newVideoPlayViewController, viewDidLoad);
    UIView *view = (UIView *)[self view];
    UIView *controlView = view.subviews[1];
    if (controlView) {
        
        UIButton *volumeView = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [volumeView setTitle:@"Airplay" forState:UIControlStateNormal];
        volumeView.layer.borderWidth = 1.0f;
        volumeView.layer.borderColor = [UIColor whiteColor].CGColor;
        volumeView.layer.cornerRadius = 4;
        [volumeView addTarget:self action:@selector(showTVList:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:volumeView];

        
//        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
//        volumeView.showsVolumeSlider = NO;
//        [volumeView sizeToFit];
//        [controlView addSubview:volumeView];
        
        
        
        UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        downloadButton.layer.borderWidth = 1.0f;
        downloadButton.layer.borderColor = [UIColor whiteColor].CGColor;
        downloadButton.layer.cornerRadius = 4;
        
        [downloadButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:downloadButton];
        
        
        [controlView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj isKindOfClass:[UIButton class]]) {
                
                UIButton *tmpButton = (UIButton *)obj;
                if ([tmpButton.titleLabel.text isEqualToString:@"高清"]) {
                    downloadButton.titleLabel.font = tmpButton.titleLabel.font;
                    downloadButton.frame = CGRectOffset(tmpButton.frame, -10, 0);
                    volumeView.frame = CGRectOffset(downloadButton.frame, -tmpButton.frame.size.width - 10, 0);
                    *stop = YES;
                }
                
            }
            
        }];
    }
}


CHPropertyCopyNonatomic(newVideoPlayViewController, NSString *, videoName, setVideoName);

static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
//        CYListenServer(6666);
    }];
    
    
//    //删除广告cache(该思路无效)
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    cachePath = [cachePath stringByAppendingPathComponent:@"com.plan.PlanEveryDay"];
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:cachePath]) {
//        [fileManager removeItemAtPath:cachePath error:nil];
//    }
    
    //加载AppDelegate类
    CHLoadLateClass(AppDelegate);
    //hook application:didFinishLaunchingWithOptions:方法
    CHClassHook(2, AppDelegate, application, didFinishLaunchingWithOptions);
    CHClassHook1(AppDelegate, setWindow);
    
    //加载AD_dataManager类
    CHLoadLateClass(AD_dataManager);
    //hook +[AD_dataManager shareInstance]方法
    CHClassHook0(AD_dataManager, shareInstance);
    
    //加载UIPasteboard类
    CHLoadLateClass(UIPasteboard);
    //hook +[UIPasteboard generalPasteboard]方法
    CHClassHook0(UIPasteboard, generalPasteboard);
}

CHConstructor {
    CHLoadLateClass(newVideoPlayViewController);
    CHClassHook0(newVideoPlayViewController, viewDidLoad);
    CHClassHook3(newVideoPlayViewController, initWithUrl, VideoType, data);
    
    CHHook0(newVideoPlayViewController, videoName);
    CHHook1(newVideoPlayViewController, setVideoName);
}


