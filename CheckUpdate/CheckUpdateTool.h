//
//  CheckUpdateTool.h
//  CheckUpdate
//
//  Created by lihuanzhou on 2017/1/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#ifdef DEBUG
#define XcodeLevel @"debug"
#else
#define XcodeLevel @"release"
#endif


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CheckUpdateTool : NSObject
+(void)checkUpdateWithURL:(NSString *)url;

@end
