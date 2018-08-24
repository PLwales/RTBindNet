//
//  NSString+RBExtension.m
//  RTBindNet
//
//  Created by roobo on 2018/8/22.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "NSString+RBExtension.h"

@implementation NSString (RBExtension)
- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}
@end
