//
//  Macro.h
//  AXAEddyStone
//
//  Created by AXAET_APPLE on 16/8/4.
//  Copyright © 2016年 axaet. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import "NSString+Extension.h"
#import "UIView+Toast.h"
#import "MyConst.h"
#import <EddystoneSDK/EddystoneSDK.h>



#define kFuncMethod NSLog(@"%s, %s, %d", __FILE__, __func__, __LINE__)

#define kFONT(key) [UIFont systemFontOfSize:key]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 自定义NSLog 简单版
#ifdef DEBUG
# define CLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
# define CLog(format, ...)
#endif

// 自定义NSLog 详细版
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define DLog(...)
#endif


#endif /* Macro_h */
