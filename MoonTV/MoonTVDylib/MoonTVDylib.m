//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MoonTVDylib.m
//  MoonTVDylib
//
//  Created by john on 2018/5/25.
//  Copyright (c) 2018 john. All rights reserved.
//

#import "MoonTVDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import "PFHostSwitcherURLProtocol.h"

CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}

CHDeclareClass(NSUserDefaults)

CHMethod2(void, NSUserDefaults, setBool, BOOL, value, forKey, NSString *, defaultName) {
    
    if ([defaultName isEqualToString:@"firstUse"]) {
        value = NO;
    }
    
    CHSuper2(NSUserDefaults, setBool, value, forKey, defaultName);
}

CHMethod1(BOOL, NSUserDefaults, boolForKey, NSString *, defaultName)  {
    
    if ([defaultName isEqualToString:@"firstUse"]) {
        return NO;
    }
    
    return CHSuper1(NSUserDefaults, boolForKey, defaultName);
}
//integerForKey
CHMethod1(NSInteger, NSUserDefaults, integerForKey, NSString *, defaultName) {
    
    if ([defaultName isEqualToString:@"scenariotype"]) {
        return 1;
    }
    
    return CHSuper1(NSUserDefaults, integerForKey, defaultName);
}

CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"john";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
    
    CHLoadLateClass(NSUserDefaults);
    CHClassHook2(NSUserDefaults, setBool, forKey);
    CHClassHook1(NSUserDefaults, boolForKey);
    CHClassHook1(NSUserDefaults, integerForKey);
}

