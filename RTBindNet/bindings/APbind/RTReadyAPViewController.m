//
//  RTReadyAPViewController.m
//  StoryToy
//
//  Created by roobo on 2018/5/25.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTReadyAPViewController.h"
#import "RTSetupAPNetViewController.h"
#import "RTAddDeviceViewController.h"
#import "UIDevice+RBExtension.h"

@interface RTReadyAPViewController ()

@property(nonatomic,weak) UIButton *nextBtn;

@property (nonatomic,strong) RACDisposable *disposable;

@end

@implementation RTReadyAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *connectImage = [UIImageView new];
    [self.view addSubview:connectImage];
    connectImage.image = [UIImage imageNamed:@"icon_detected_copy"];
    [connectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(220);
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setImage:[UIImage imageNamed:@"icon_ap_tip1"] forState:UIControlStateNormal];
    [button setTitle:@"请前往手机无线局域网界面，连接设备热点" forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0x7d7d7d) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.userInteractionEnabled = NO;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(connectImage.mas_bottom).offset(30);
        make.width.mas_equalTo(290);
    }];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.backgroundColor = UIColorMake(245, 245, 245);
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = UIColorMake(235, 235, 235).CGColor;
    view.layer.borderWidth = 1;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button);
        make.right.equalTo(button);
        make.height.equalTo(@42);
        make.top.equalTo(button.mas_bottom).offset(10);
    }];
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:nameBtn];
    [nameBtn setImage:[UIImage imageNamed:@"icon_ap_wifi"] forState:UIControlStateNormal];
    [nameBtn setTitle:@"名称：robot-xxxx" forState:UIControlStateNormal];
    [nameBtn setTitleColor:UIColorHex(0x4a4a4a) forState:UIControlStateNormal];
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    nameBtn.userInteractionEnabled = NO;
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.left.mas_equalTo(view).offset(10);
        make.width.mas_equalTo(138);
    }];
    nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton *pwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:pwdBtn];
    [pwdBtn setImage:[UIImage imageNamed:@"icon_ap_lock"] forState:UIControlStateNormal];
    [pwdBtn setTitle:@"密码：12345678" forState:UIControlStateNormal];
    [pwdBtn setTitleColor:UIColorHex(0x4a4a4a) forState:UIControlStateNormal];
    pwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    pwdBtn.userInteractionEnabled = NO;
    [pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.left.mas_equalTo(nameBtn.mas_right).offset(8);
        make.width.mas_equalTo(130);
    }];
    pwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button2];
    [button2 setImage:[UIImage imageNamed:@"icon_ap_tip2"] forState:UIControlStateNormal];
    [button2 setTitle:@"成功连接设备热点后请返回继续" forState:UIControlStateNormal];
    [button2 setTitleColor:UIColorHex(0x7d7d7d) forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    button2.userInteractionEnabled = NO;
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(view.mas_bottom).offset(20);
        make.width.mas_equalTo(button);
    }];
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 切换配网按钮
    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:exchangeBtn];
    [exchangeBtn setTitle:@"其他配网方式" forState:UIControlStateNormal];
    [exchangeBtn setImage:[UIImage imageNamed:@"icon_ap_arrow"] forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:UIColorHex(0x7290ff) forState:UIControlStateNormal];
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-36);
    }];
    [exchangeBtn addTarget:self action:@selector(exchangeBindingType) forControlEvents:UIControlEventTouchUpInside];
    exchangeBtn.hidden = self.mode2 == nil || self.mode2.length == 0 ? YES : NO;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageWithColor:RTColorForBackground] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageWithColor: UIColorHex(0xc0c0c1)] forState:UIControlStateDisabled];
    [nextBtn setTitle:@"点击前往" forState:UIControlStateNormal];
    [nextBtn setTitle:@"继续" forState:UIControlStateSelected];
    [nextBtn setTitle:@"继续" forState:UIControlStateSelected | UIControlStateHighlighted];
    nextBtn.layer.cornerRadius = 22.5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(exchangeBtn.mas_top).offset(-77);
    }];
    [nextBtn addTarget:self action:@selector(searchDeviceHandle:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn = nextBtn;
    
    NSString *wifiName = [UIDevice wiFiSSID];
    if ([self isStoryToyWifi:wifiName]) {
        self.nextBtn.selected = YES;
    }else {
        self.nextBtn.selected = NO;
    }
    
    RACSignal *racSignal = [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] timeout:MAXFLOAT onScheduler:[RACScheduler currentScheduler]];
    _disposable = [racSignal subscribeNext:^(id x) {
        NSString *wifiName = [UIDevice wiFiSSID];
        if ([self isStoryToyWifi:wifiName]) {
            self.nextBtn.selected = YES;
        }else {
            self.nextBtn.selected = NO;
        }
    } error:^(NSError *error) {
    }];
    
    if (SCREEN_HEIGHT < 667) {
        [connectImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(220);
        }];
        
        [exchangeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view);
            make.centerX.mas_equalTo(self.view);
            make.bottom.mas_equalTo(-10);
        }];
        [nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(exchangeBtn.mas_top).offset(-10);
        }];
    }
}

-(BOOL) isStoryToyWifi:(NSString*)wifiName
{
    if(wifiName)
        return [wifiName hasPrefix:@"roobo-"] || [wifiName hasPrefix:@"robot-"];
    else
        return NO;
}

- (void)exchangeBindingType {
    [RTAddDeviceViewController launchConfigMode:self mode:self.mode2 mode2:nil ];
    
    NSMutableArray *newVCS = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [newVCS removeObject:self];
    [self.navigationController setViewControllers:newVCS animated:NO];
}

- (void)searchDeviceHandle:(UIButton *)sender {
    if (sender.isSelected) {
        RTSetupAPNetViewController *setupVC = [RTSetupAPNetViewController new];
        [self.navigationController pushViewController:setupVC animated:YES];
    }else {
        NSURL *url = [NSURL URLWithString:@"App-prefs:root"];
        if (@available(iOS 10.0, *)) {
             [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
