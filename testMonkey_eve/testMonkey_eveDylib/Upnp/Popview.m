//
//  Popview.m
//  testMonkey_eveDylib
//
//  Created by John on 2018/5/18.
//  Copyright © 2018年 js. All rights reserved.
//

#import "Popview.h"

@interface Popview ()

@property (nonatomic) UIView *contentView;

@end

@implementation Popview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dissmiss {
    
    CGRect destFrame = self.contentView.frame;
    
    destFrame.origin.y += destFrame.size.height;
    destFrame.size.height = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.contentView.frame = destFrame;
        
    } completion:^(BOOL finished) {
        
        [self.contentView removeFromSuperview];
        self.contentView = nil;
        
        [self removeFromSuperview];
    }];
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    
    return YES;
    
}

- (void)popView:(UIView *)view {
    self.contentView = view;
    [self addSubview:view];
}

- (void)showPopViewInView:(UIView *)view atPoint:(CGPoint)localpoint {
    [view addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect frame = self.contentView.frame;
    frame.origin = CGPointMake(localpoint.x - frame.size.width / 2, localpoint.y);
    
    CGFloat height = frame.size.height;
    frame.size.height = 0;
    self.contentView.frame = frame;
    CGRect destRect = frame;
    destRect.origin.y = frame.origin.y  - height;
    destRect.size.height = height;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = destRect;
    } completion:^(BOOL finished) {
        
    }];
    
    
}




@end
