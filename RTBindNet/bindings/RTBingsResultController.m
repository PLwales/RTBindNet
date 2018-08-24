//
//  RTBingsResultController.m
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTBingsResultController.h"
#if !(TARGET_IPHONE_SIMULATOR)
#import "RTBluetoothManager.h"
#import "RTOpmodeObject.h"
#endif
#import "RTConnectReadyController.h"

typedef NS_ENUM(NSInteger,RTDeviceBindResult){
    RTDeviceBindResultStart = 0,
    RTDeviceBindResultTimeout, //超时
    RTDeviceBindResultFirstBinded, //第一次绑定
    RTDeviceBindResultHaveBinded, // 已经绑定
    RTDeviceBindResultHaveBindedByOthers // 已被别人绑定
};

@interface RTBingsResultController ()
@property (nonatomic,assign) RTDeviceBindResult bindResult;
@property (nonatomic,strong) RACDisposable *signal;

@property (nonatomic,strong) UILabel *tipsLabel;
@end

@implementation RTBingsResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *connetImage = [UIImageView new];
    [self.view addSubview:connetImage];
    connetImage.image = [UIImage imageNamed:@"connecting_000"];
    [connetImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
        make.width.mas_equalTo(connetImage.image.size.width);
        make.height.mas_equalTo(connetImage.image.size.height);
    }];
    NSMutableArray * searchArray = [NSMutableArray new];
    for(int i =1 ; i < 29 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"connecting_%03d",i]];
        if(image){
            [searchArray addObject:image];
        }
    }
    connetImage.animationImages = searchArray;
    [connetImage setAnimationDuration:2];
    [connetImage setAnimationRepeatCount:-1];
    [connetImage startAnimating];
    UILabel *titleLabel = [UILabel new];
    [self.view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = UIColorHex(0x4a4a4a);
    titleLabel.text = @"网络连接中，请耐心等待...";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(connetImage.mas_bottom).offset(40);
    }];
    _tipsLabel = titleLabel;
    
#if !(TARGET_IPHONE_SIMULATOR)
    [RTBluetoothManager sharedInstance].bleStateBlock = ^(RTBleState bleState) {
        if (bleState == RTBleStateWritable) {
            RTOpmodeObject *object = [[RTOpmodeObject alloc]init];
            NSString *wifiName = [NSString stringWithFormat:@"%@",_wifiSSid];
            NSString *name64String = [[wifiName dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            object.wifiSSid= name64String;
            if ([_wifiPassword containsString:@"#"]) {
                _wifiPassword = [_wifiPassword stringByReplacingOccurrencesOfString:@"#" withString:@"\\#"];
            }
            object.wifiPassword = [NSString stringWithFormat:@"v1#%@#%@#",_wifiPassword,@"userid"]; // 用户ID
            [[RTBluetoothManager sharedInstance] setOpmodeObject:object];
            [self bindResultCountdown];
        }
    };
    [[RTBluetoothManager sharedInstance] connectDevice];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)bindResultCountdown
{
    RACSignal *racSignal  = [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] timeout:30 onScheduler:[RACScheduler currentScheduler]];
    _signal = [racSignal subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        self.bindResult = RTDeviceBindResultTimeout;
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
#if !(TARGET_IPHONE_SIMULATOR)
    [[RTBluetoothManager sharedInstance] cancelAllConnect];
#endif
}

-(void)setBindResult:(RTDeviceBindResult)bindResult
{
    bindResult = RTDeviceBindResultFirstBinded;
    if (!self.signal.isDisposed) [self.signal dispose];
    if (bindResult == RTDeviceBindResultTimeout) {
        _tipsLabel.text = @"网络配置失败";

        NSLog(@"网络配置失败");
    }
    if (bindResult == RTDeviceBindResultFirstBinded) {
        _tipsLabel.text = @"连接成功";
        NSLog(@"首次绑定成功");
    }
    if (bindResult == RTDeviceBindResultHaveBinded) {
        _tipsLabel.text = @"连接成功";
        NSLog(@"绑定成功");
//        [self popViewController];
    }
    if(bindResult == RTDeviceBindResultHaveBindedByOthers){
        _tipsLabel.text = @"设备已被别人绑定，请联系他邀请你";
        NSLog(@"设备已被别人绑定，请联系他邀请你");
    }
}

-(void)popViewController
{
        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
