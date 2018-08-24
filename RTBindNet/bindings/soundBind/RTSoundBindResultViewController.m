//
//  RTSoundBindResultViewController.m
//  StoryToy
//
//  Created by roobo on 2018/6/5.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTSoundBindResultViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RTSoundReadyController.h"
#import "AppDelegate.h"


typedef NS_ENUM(NSInteger,RTDeviceBindResult){
    RTDeviceBindResultStart = 0,
    RTDeviceBindResultTimeout, //超时
    RTDeviceBindResultFirstBinded, //第一次绑定
    RTDeviceBindResultHaveBinded, // 已经绑定
    RTDeviceBindResultHaveBindedByOthers // 已被别人绑定
};

@interface RTSoundBindResultViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) RACDisposable *signal;
@property (nonatomic,assign) RTDeviceBindResult bindResult;
@property (nonatomic,strong) RBBindInfo *currBindInfo;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIButton *reconfigureButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) int retryTimes;
@property (nonatomic, strong) NSString* mode;   // 声波模式
@property (nonatomic, strong) NSMutableArray* searchArray;
@property (nonatomic, strong) NSMutableArray* connectingArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UISlider *volumeSlider;

@end

@implementation RTSoundBindResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"声波配网";
    
    _imageView = [UIImageView new];
    [self.view addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"shengbo_000"];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(25);
        make.width.mas_equalTo(_imageView.image.size.width);
        make.height.mas_equalTo(_imageView.image.size.height);
    }];
    self.searchArray = [NSMutableArray new];
    for(int i = 0 ; i <= 14 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"shengbo_%03d",i]];
        if(image){
            [self.searchArray addObject:image];
        }
    }
    
    self.connectingArray = [NSMutableArray new];
    for(int i = 0 ; i <= 29 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"connecting_%03d",i]];
        if (image) {
            [self.connectingArray addObject:image];
        }
    }
    
    _imageView.animationImages = self.searchArray;
    [_imageView setAnimationDuration:2];
    [_imageView setAnimationRepeatCount:-1];
    
    _titleLabel = [UILabel new];
    [self.view addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = UIColorHex(0x4a4a4a);
    _titleLabel.text = @"正在发送声波，请耐心等待......";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_imageView.mas_bottom).offset(40);
    }];
    
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _retryButton.hidden = YES;
    [_retryButton setTitle:@"发送声波" forState:UIControlStateNormal];
    [_retryButton setTitleColor:RTColorForBackground forState:UIControlStateNormal];
    [_retryButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xffffff)] forState:UIControlStateNormal];
    _retryButton.layer.borderColor = [RTColorForBackground CGColor];
    _retryButton.layer.borderWidth = 1;
    _retryButton.layer.cornerRadius = 45 *0.5;
    _retryButton.layer.masksToBounds = true;
    [_retryButton addTarget:self action:@selector(sendSoundWave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retryButton];
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
    }];
    
    _reconfigureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reconfigureButton.hidden = YES;
    [_reconfigureButton setTitle:@"重新配置" forState:UIControlStateNormal];
    [_reconfigureButton setTitleColor:RTColorForBackground forState:UIControlStateNormal];
    [_reconfigureButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xffffff)] forState:UIControlStateNormal];
    _reconfigureButton.layer.borderColor = [RTColorForBackground CGColor];
    _reconfigureButton.layer.borderWidth = 1;
    _reconfigureButton.layer.cornerRadius = 45 *0.5;
    _reconfigureButton.layer.masksToBounds = true;
    [_reconfigureButton addTarget:self action:@selector(reconfigureSoundWave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reconfigureButton];
    [_reconfigureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(self.view.mas_centerX).offset(-5);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
    }];
    
    UILabel* confirmLabel = [UILabel new];
    confirmLabel.hidden = YES;
    [self.view addSubview:confirmLabel];
    confirmLabel.font = [UIFont systemFontOfSize:17];
    confirmLabel.textColor = UIColorHex(0x4a4a4a);
    confirmLabel.text = @"已听到声波接收成功设备提示音";
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    confirmLabel.numberOfLines = 0;
    [confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_retryButton.mas_bottom).offset(40);
    }];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.hidden = YES;
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:RTColorForBackground] forState:UIControlStateNormal];
    _confirmButton.layer.cornerRadius = 45 *0.5;
    _confirmButton.layer.masksToBounds = true;
    [_confirmButton addTarget:self action:@selector(confirmReceiveSoundWave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(confirmLabel.mas_bottom).offset(20);
    }];
    
    [RACObserve(self.confirmButton, hidden) subscribeNext:^(id hidden){
        confirmLabel.hidden = [hidden boolValue];
    }];
    
    self.retryTimes = 0;
    for (UIViewController* vc in self.navigationController.viewControllers){
        if([vc isKindOfClass:[RTSoundReadyController class]])
            self.mode = ((RTSoundReadyController*)vc).mode;
    }
    // default is v2
    if(!self.mode || self.mode.length == 0)
        self.mode = @"v2";
    NSLog(@"mode %@", self.mode);
    
    [self sendSoundWave];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.volumeSlider setValue:0.8 animated:NO];
}

- (UISlider *)volumeSlider {
    if (_volumeSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        for (UIView* newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeSlider = (UISlider*)newView;
                break;
            }
        }
    }
    return _volumeSlider;
}

#pragma mark - 发送声波

NSString * convertString(NSString *string) {
    NSString *result = string;
    if ([string containsString:@"\\"]) {
        result = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    }
    
    if ([string containsString:@"#"]) {
        result = [string stringByReplacingOccurrencesOfString:@"#" withString:@"\\#"];
    }
    return result;
}

-(void) confirmReceiveSoundWave
{
    self.confirmButton.hidden = YES;
    self.retryButton.hidden = YES;
    self.reconfigureButton.hidden = YES;
    
    [_imageView stopAnimating];
    _imageView.image = [self.connectingArray objectAtIndex:0];
    _imageView.animationImages = self.connectingArray;
    [_imageView startAnimating];
    
    // 开启轮询
    [self checkBindingResult];
}

-(void) reconfigureSoundWave
{
    for (UIViewController* vc in self.navigationController.viewControllers){
        if([vc isKindOfClass:[RTSoundReadyController class]])
            [self.navigationController popToViewController:vc animated:YES];
    }
}

- (void)sendSoundWave {
    [_imageView startAnimating];
    self.retryTimes++;
    self.retryButton.hidden = YES;
    self.confirmButton.hidden = YES;
    self.reconfigureButton.hidden = YES;
    self.titleLabel.text = @"正在发送声波，请耐心等待......";
    
//    NSString *waveStr = [NSString stringWithFormat:@"v1#%@#%@#%@##", convertString(self.wifiSSid), convertString(self.wifiPassword),convertString([RBAccessConfig getUserID])];
    [RBDeviceApi getSoundWave:self.wifiSSid wifiPsd:self.wifiPassword block:^(NSString * _Nonnull urlStr, NSError * _Nullable error) {
        if (urlStr) {
            self.urlString = urlStr;
            // 下载声音文件
            NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:self.urlString] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (response && error == nil) {
                    NSData *data = [NSData dataWithContentsOfURL:location];
                    [self playSoundWave:data];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.titleLabel.text = @"声波发送失败，请重试";
                        [_imageView stopAnimating];
                        self.retryButton.hidden = NO;
                    });
                }
            }];
            [task resume];
        }else {
            self.titleLabel.text = @"声波发送失败，请重试";
            [_imageView stopAnimating];
            self.retryButton.hidden = NO;
        }
    }];
}

#pragma mark 播放声波

- (void)playSoundWave:(NSData *)data {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

#pragma mark -------- audio delegate ---------

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
    self.titleLabel.text = @"未听到设备提示音";
    // 用户可以选择重试
    if(self.retryTimes == 3){
        [self.retryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(45);
            make.left.mas_equalTo(self.view.mas_centerX).offset(5);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        }];
        self.reconfigureButton.hidden = NO;
    } else if(self.retryTimes > 3){
        self.reconfigureButton.hidden = NO;
    }
    self.retryButton.hidden = NO;
    self.confirmButton.hidden = NO;
}

#pragma mark --------- 轮询查看绑定结果 -------------

- (void)checkBindingResult {
    self.titleLabel.text = @"声波发送成功，正在绑定设备......";
    
    RACSignal *racSignal = [[RACSignal interval:2.f onScheduler:[RACScheduler currentScheduler]] timeout:30.f onScheduler:[RACScheduler currentScheduler]];
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
    if (self.bindResult == RTDeviceBindResultTimeout) {
        self.titleLabel.text = @"联网失败，请重试";
        [self.reconfigureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
        }];
        [self.reconfigureButton setTitle:@"重试" forState:UIControlStateNormal];
        self.reconfigureButton.hidden = NO;
    }
    if (self.bindResult == RTDeviceBindResultFirstBinded) {
        self.titleLabel.text = @"联网成功";
        if ([self.currBindInfo.deviceID isNotBlank]) {
//            [RTUserMgr saveCurrDeviceID:self.currBindInfo.deviceID];//把当前绑定设成操作设备
        }
//        [RTUserMgr refreshDeviceList:YES];
    }
    if (self.bindResult == RTDeviceBindResultHaveBinded) {
        self.titleLabel.text = @"联网成功";

//        [self popToRootViewController];
    }
    if(self.bindResult == RTDeviceBindResultHaveBindedByOthers){
        self.titleLabel.text = [NSString stringWithFormat:@"设备已被%@绑定，请联系他邀请你",self.currBindInfo.bindtel];

        //设备已被绑定，请联系他邀请你
        NSLog(@"设备已被%@绑定，请联系他邀请你",self.currBindInfo.bindtel);
    }
}

- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
