//
//  RTAddDeviceViewController.m
//  StoryToy
//
//  Created by roobo on 2018/5/31.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTAddDeviceViewController.h"
#import "RTConnectReadyController.h"
#import "RTAddDeviceCell.h"
#import "RTSoundReadyController.h"
#import "RTReadyAPViewController.h"
#import <RBToyAPI/RBDeviceApi.h>
#import <UserNotifications/UserNotifications.h>


// 配网模式
// 服务器获取的配网模式
#define TYPE_MODE_BT        @"bt"
#define TYPE_MODE_AP        @"ap"
// v1-v99 预留声波配网 v1（布丁S）， v2（48Khz编码）,v3(16Khz编码),v4(不清楚)
#define TYPE_MODE_WAVE_V1   @"v1"
#define TYPE_MODE_WAVE_V2   @"v2"
#define TYPE_MODE_WAVE_V3   @"v3"

// scan_type为1，目前只有二维码这种
#define SCAN_TYPE_QR_CODE   1


typedef NS_ENUM(NSUInteger,RTPrivacyPermissionStatus) {
    RTPrivacyPermissionStatusNotDetermined = 0,//尚未申请
    RTPrivacyPermissionStatusDenied, //拒绝
    RTPrivacyPermissionStatusRestricted,//受限制的
    RTPrivacyPermissionStatusAuthorized, //授权
    RTPrivacyPermissionStatusLocationAlways,//一直可以定位
    RTPrivacyPermissionStatusLocationWhenInUse,// 使用期间可以定位
};

@interface RTAddDeviceViewController ()

@end

@implementation RTAddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = [UIColor whiteColor];

    [self addDebugButton];


    [self bindingPushToken];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"add device view");
}

-(void) addDebugButton{
    // ap
    UIButton *apButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [apButton setBackgroundImage:[UIImage imageWithColor:RTColorForBackground] forState:UIControlStateNormal];
    [apButton setTitle:@"AP" forState:UIControlStateNormal];
    [apButton addTarget:self action:@selector(clickAP) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:apButton];
    [apButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(44);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
    }];
    
    // bt
    UIButton *btButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btButton setBackgroundImage:[UIImage imageWithColor:RTColorForBackground] forState:UIControlStateNormal];
    [btButton setTitle:@"BT" forState:UIControlStateNormal];
    [btButton addTarget:self action:@selector(clickBT) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btButton];
    [btButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(44 * 3);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);

    }];
    
    // sound
    UIButton *v1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [v1Button setBackgroundImage:[UIImage imageWithColor:RTColorForBackground] forState:UIControlStateNormal];
    [v1Button setTitle:@"Sound" forState:UIControlStateNormal];
    [v1Button addTarget:self action:@selector(clickV1) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:v1Button];
    [v1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(44 *5);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
    }];
    
}



#pragma mark AP配网
- (void)clickAP {
    RTReadyAPViewController *controller = [[RTReadyAPViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 蓝牙配网
- (void)clickBT {
    RTConnectReadyController *controller = [RTConnectReadyController new];
    [self.navigationController pushViewController:controller animated:YES];
}

// v1-v99 预留声波配网
#pragma mark 声波配网
- (void)clickV1 {
    RTSoundReadyController *controller = [[RTSoundReadyController alloc] init];
    controller.mode = TYPE_MODE_WAVE_V1;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshDeviceList {
//    [RTUserMgr refreshDeviceList:YES];
}

- (void)bindingPushToken {
    RTPrivacyPermissionStatus status = [self remoteNotificationsPermissionStatus];
    if (status == RTPrivacyPermissionStatusNotDetermined) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"绑定设备消息" message:@"我们需要开启通知权限来获取绑定设备消息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 去注册通知
                NSLog(@"去注册通知");
                if (@available(iOS 10.0, *)){
                    [UNUserNotificationCenter currentNotificationCenter].delegate = [UIApplication sharedApplication].delegate;
                    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound| UNAuthorizationOptionAlert  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (granted) {
                            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                });
                            }
                        }
                    }];
                }else if ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
                    }
                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RTPermissionsDidAskForPushNotifications];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
    }else if (status == RTPrivacyPermissionStatusDenied){
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"RTRemoteNotificationsAlter"];
        if (!lastDate||[lastDate compare:[NSDate date]]== NSOrderedAscending) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"绑定设备消息被关闭" message:@"我们需要在设置中打开通知来获取绑定设备消息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] dateByAddingTimeInterval:3600*24*5] forKey:@"RTRemoteNotificationsAlter"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) { }];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)popViewController {
   
}

+(BOOL) parseNetConfigMode:(UIViewController*) viewController netType:(NSArray<NSString *>*) netType
{
    if (netType == nil || [netType count] == 0)
        return false;
    NSString * mode1 = [netType firstObject];
    NSString * mode2 = nil;
    if ([netType count] >= 2)
        mode2 = [netType objectAtIndex:1];
    
    return [RTAddDeviceViewController launchConfigMode:viewController mode:mode1 mode2:mode2];
}

+(BOOL) launchConfigMode:(UIViewController*) viewController mode:(NSString*) mode mode2:(NSString*) mode2
{
    if ([TYPE_MODE_AP isEqualToString:mode]) {
        RTReadyAPViewController *controller = [[RTReadyAPViewController alloc] init];
        controller.mode2 = mode2;
        [viewController.navigationController pushViewController:controller animated:YES];
        return true;
    } else if ([TYPE_MODE_BT isEqualToString:mode]) {
        RTConnectReadyController *controller = [RTConnectReadyController new];
        controller.mode2 = mode2;
        [viewController.navigationController pushViewController:controller animated:YES];
        return true;
    } else if ( [RTAddDeviceViewController isSoundWaveMode:mode] ) {
        RTSoundReadyController *controller = [[RTSoundReadyController alloc] init];
        controller.mode = mode;
        controller.mode2 = mode2;
        [viewController.navigationController pushViewController:controller animated:YES];
        return true;
    } else
        return false;
}

+(BOOL) isSoundWaveMode:(NSString *)mode
{
    NSString *pattern = @"^v[0-9]{1,2}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:mode];
}

NSString *const RTPermissionsDidAskForPushNotifications = @"RTPermissionsDidAskForPushNotifications";
- (RTPrivacyPermissionStatus) remoteNotificationsPermissionStatus
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block RTPrivacyPermissionStatus status = RTPrivacyPermissionStatusAuthorized;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *  settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                status = RTPrivacyPermissionStatusNotDetermined;
            }else if (settings.authorizationStatus== UNAuthorizationStatusDenied){
                status = RTPrivacyPermissionStatusDenied;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return status;
    } else {
        BOOL didAskForPermission = [[NSUserDefaults standardUserDefaults] boolForKey:RTPermissionsDidAskForPushNotifications];
        if (didAskForPermission) {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
                if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
                    return RTPrivacyPermissionStatusAuthorized;
                } else {
                    return RTPrivacyPermissionStatusDenied;
                }
            }
        }
        
    }
    return RTPrivacyPermissionStatusNotDetermined;
}

@end
