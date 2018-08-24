//
//  RTBindingAPDeviceViewController.m
//  StoryToy
//
//  Created by roobo on 2018/6/1.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTBindingAPDeviceViewController.h"
#import "GCDAsyncUdpSocket.h"

typedef NS_ENUM(NSInteger,RTDeviceBindResult){
    RTDeviceBindResultStart = 0,
    RTDeviceBindResultTimeout, //超时
    RTDeviceBindResultFirstBinded, //第一次绑定
    RTDeviceBindResultHaveBinded, // 已经绑定
    RTDeviceBindResultHaveBindedByOthers // 已被别人绑定
};

@interface RTBindingAPDeviceViewController ()

@property (nonatomic,strong) RACDisposable *signal;
@property (nonatomic,assign) RTDeviceBindResult bindResult;
@property (nonatomic,strong) RBBindInfo *currBindInfo;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UIButton *retryButton;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RTBindingAPDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"连接网络";
//    self.navigationItem.leftBarButtonItem = [RTNavigationButton barButtonItemWithImage:[UIImage imageNamed:@"icon_back"] tintColor:[UIColor whiteColor] position:RTNavigationButtonPositionLeft target:self action:@selector(popToSetupWifiViewController)];
    
    _imageView = [UIImageView new];
    [self.view addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"icon_connect"];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(30);
        make.width.mas_equalTo(_imageView.image.size.width);
        make.height.mas_equalTo(_imageView.image.size.height);
    }];
    NSMutableArray * searchArray = [NSMutableArray new];
    for(int i = 0 ; i <= 29 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"connecting_%03d",i]];
        if (image) {
            [searchArray addObject:image];
        }
    }
    _imageView.animationImages = searchArray;
    [_imageView setAnimationDuration:2];
    [_imageView setAnimationRepeatCount:-1];
    
    [self sendMessage];
}

#pragma mark 懒加载

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        [self.view addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = UIColorHex(0x4a4a4a);
        _titleLabel.text = @"网络连接中，请耐心等待...";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_imageView.mas_bottom).offset(35);
        }];
    }
    return _titleLabel;
}

- (UILabel *)warningLabel {
    if (_warningLabel == nil) {
        _warningLabel = [UILabel new];
        [self.view addSubview:_warningLabel];
        _warningLabel.font = [UIFont systemFontOfSize:12];
        _warningLabel.textColor = UIColorHex(0xa1a1a1);
        _warningLabel.text = @"注：如果您在等待网络时听到机器人配网失败的提示，\n请返回上一页面重试";
        _warningLabel.textAlignment = NSTextAlignmentCenter;
        _warningLabel.numberOfLines = 0;
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-43);
        }];
    }
    return _warningLabel;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setTitle:@"重试" forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x7290ff)] forState:UIControlStateNormal];
        _retryButton.layer.cornerRadius = 45 *0.5;
        _retryButton.layer.masksToBounds = true;
        [_retryButton addTarget:self action:@selector(clickRetry) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_retryButton];
        [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(-75);
        }];
    }
    return _retryButton;
}

- (void)clickRetry {
    [self popToSetupWifiViewController];
}

#pragma mark - 发送消息给AP

NSString * convertWifiString(NSString *string) {
    NSString *result = string;
    if ([string containsString:@"\\"]) {
        result = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    }
    
    if ([string containsString:@"#"]) {
        result = [string stringByReplacingOccurrencesOfString:@"#" withString:@"\\#"];
    }
    
    return result;
}

- (void)sendMessage {
    if (!self.signal.isDisposed) {
        [self.signal dispose];
    }
    [_imageView startAnimating];
    self.retryButton.hidden = YES;
    self.titleLabel.text = @"正在发送消息给设备，请耐心等待......";
    self.warningLabel.hidden = NO;
    
    NSString *waveStr = [NSString stringWithFormat:@"v1#%@#%@#%@##", convertWifiString(self.wifiSSid), convertWifiString(self.wifiPassword), convertWifiString([RBAccessConfig getUserID])];
    [self sendBroadcast:@"224.0.0.1" port:12811 data:[waveStr dataUsingEncoding:NSUTF8StringEncoding]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //查询绑定
        [self checkBindingResult];
    });
}

#pragma mark --------- 轮询查看绑定结果 -------------
- (void)checkBindingResult {
    [self.imageView startAnimating];
    self.titleLabel.text = @"消息发送成功，正在绑定设备......";
    
    RACSignal *racSignal  = [[RACSignal interval:2.f onScheduler:[RACScheduler currentScheduler]] timeout:30.f onScheduler:[RACScheduler currentScheduler]];
    _signal = [racSignal subscribeNext:^(id x) {
        [RBDeviceApi getDeviceBindInfo:^(RBBindInfo*bindInfo, NSError *error) {
            self.currBindInfo = bindInfo;
            if ([bindInfo.deviceID isNotBlank]){
                if(bindInfo.isFirstBinded) {//首次绑定设备
                    self.bindResult = RTDeviceBindResultFirstBinded;
                }else if(bindInfo.isBinded){
                    self.bindResult = RTDeviceBindResultHaveBinded;
                } else{
                    self.bindResult = RTDeviceBindResultHaveBindedByOthers;
                }
            }
        }];
    } error:^(NSError *error) {
        self.bindResult = RTDeviceBindResultTimeout;
    }];
}

- (void)setBindResult:(RTDeviceBindResult)bindResult {
    _bindResult = bindResult;
    [self.imageView stopAnimating];
    
    if (!self.signal.isDisposed) {
        [self.signal dispose];
    }
    if (bindResult == RTDeviceBindResultTimeout) {
        self.titleLabel.text = @"联网失败，请重新配置wifi信息";
        // 重试
        self.retryButton.hidden = NO;
        self.warningLabel.hidden = YES;
    }
    if (bindResult == RTDeviceBindResultFirstBinded) {
        self.titleLabel.text = @"联网成功啦";
        if ([self.currBindInfo.deviceID isNotBlank]) {
//            [RTUserMgr saveCurrDeviceID:self.currBindInfo.deviceID];//把当前绑定设成操作设备
        }
        NSLog(@"联网成功了");
    }
    if (bindResult == RTDeviceBindResultHaveBinded) {
        self.titleLabel.text = @"联网成功啦";
        NSLog(@"联网成功了");
//        [self popToRootViewController];
    }
    if(bindResult == RTDeviceBindResultHaveBindedByOthers){
        // 设备被别人绑定，请联系他邀请你
        self.titleLabel.text = @"设备被别人绑定，请联系他邀请你";

    }
}

- (void)popToSetupWifiViewController {
    NSInteger count = self.navigationController.viewControllers.count;
    [self.navigationController popToViewController:self.navigationController.viewControllers[count-3] animated:YES];
}

- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sendBroadcast:(NSString *)host port:(NSInteger)port data:(NSData *)sendData {
    GCDAsyncUdpSocket *clientSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:nil delegateQueue:dispatch_get_main_queue()];
    NSLog(@"Send data Length is %ld",sendData.length);
    [clientSocket sendData:sendData toHost:host port:port withTimeout:30 tag:0];
}

@end
