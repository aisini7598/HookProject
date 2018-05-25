//
//  PFHostSwitcherURLProtocol.h
//  PFastCalculation
//
//  Created by Aslan on 7/6/16.
//  Copyright © 2016 Knowin. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface PFHostSwitcherURLProtocol : NSURLProtocol

+ (NSString *)switchedURLString:(NSString *)URLString;

+ (void)registerProtocol;

@end

