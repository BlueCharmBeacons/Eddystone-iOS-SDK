//
//  NSString+Extension.m
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/18.
//  Copyright © 2016年 axaet. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)hasChinese {
    for (int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if (a >= 0x4e00 && a<= 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
