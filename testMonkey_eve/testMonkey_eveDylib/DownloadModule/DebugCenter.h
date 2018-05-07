//
//  DebugCenter.h
//  TogetherHomeworkDylib
//
//  Created by john on 2018/4/23.
//  Copyright © 2018 john. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DebugCenter : NSObject

@property (nonatomic) BOOL isShow;

+ (DebugCenter *)sharedInstance;

- (void)showDebugCenter;

- (void)hiddenDebugCenter;

@end
