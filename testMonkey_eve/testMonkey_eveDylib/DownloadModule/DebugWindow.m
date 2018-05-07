//
//  DebugWindow.m
//  TogetherHomeworkDylib
//
//  Created by john on 2018/4/23.
//  Copyright © 2018 john. All rights reserved.
//

#import "DebugWindow.h"
#import "DebugCenter.h"

@implementation DebugWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && motion == UIEventSubtypeMotionShake) {
        [self detectWindowShake];
    } else {
        [super motionEnded:motion withEvent:event];
    }
    
}

- (void)detectWindowShake {
    if (![[DebugCenter sharedInstance] isShow]) {
        [[DebugCenter sharedInstance] showDebugCenter];
    } else {
        [[DebugCenter sharedInstance] hiddenDebugCenter];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
