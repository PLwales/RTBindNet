//
//  RTAddDeviceViewController.h
//  StoryToy
//
//  Created by roobo on 2018/5/31.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RTAddDeviceType) {
    RTAddDeviceTypeAddFirst = 1,// 首次增加
    RTAddDeviceTypeAddMore,// 添加更多设备
    RTAddDeviceTypeUpdateNet,//修改网络
};

@interface RTAddDeviceViewController : UIViewController

@property(nonatomic,assign) RTAddDeviceType addDeviceType;

+(BOOL) parseNetConfigMode:(UIViewController*) viewController netType:(NSArray<NSString *>*) netType;

+(BOOL) launchConfigMode:(UIViewController*) viewController  mode:(NSString*) mode mode2:(NSString*) mode2;

@end
