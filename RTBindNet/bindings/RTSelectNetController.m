//
//  PDConfigNetStepTwoController.m
//  Pudding
//
//  Created by william on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RTSelectNetController.h"
#import "ReactiveObjC.h"
#import "RTBingsResultController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/utsname.h>
@interface RTSelectNetController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;              //   title
@property (nonatomic, weak) UITextField * wifiNameTxtField;
@property (nonatomic, weak) UITextField * wifiPsdTxtField;
@property (nonatomic, weak) UIButton * wifiBtn;
@end

@implementation RTSelectNetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //初始化导航
    self.title = @"配置网络";
    UIImageView *successImage = [UIImageView new];
    [self.view addSubview:successImage];
    successImage.image = [UIImage imageNamed:@"icon_wifi"];
    successImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300 * HeightScale);
    

    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SX(60), SCREEN_HEIGHT, SCREEN_WIDTH - SX(120), 44)];
    self.titleLabel.text = @"配置网络";
    self.titleLabel.textAlignment = NSTextAlignmentCenter ;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [ UIColor clearColor];
    [self.view addSubview:self.titleLabel];
    
    UITextField * wifiNameTxtField = [UITextField new];
    wifiNameTxtField.borderStyle = UITextBorderStyleRoundedRect;
    wifiNameTxtField.placeholder = @"请输入WiFi账号";
    wifiNameTxtField.returnKeyType = UIReturnKeyNext;
    wifiNameTxtField.textColor = [UIColor blackColor];
    wifiNameTxtField.backgroundColor = [UIColor clearColor];
    wifiNameTxtField.font = [UIFont systemFontOfSize:13];

    [self.view addSubview:wifiNameTxtField];
    [wifiNameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(successImage.mas_bottom).offset(10);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(45);
    }];
    _wifiNameTxtField = wifiNameTxtField;
    _wifiNameTxtField.text = [self wiFiSSID];
    _wifiNameTxtField.returnKeyType = UIReturnKeyNext;
    _wifiNameTxtField.delegate=self;

    UITextField * wifiPsdTxtField =[UITextField new];
    wifiPsdTxtField.placeholder = @"请输入WiFi密码";
    wifiPsdTxtField.returnKeyType = UIReturnKeyGo;
    wifiPsdTxtField.secureTextEntry = YES;
    wifiPsdTxtField.keyboardType = UIKeyboardTypeAlphabet;
    wifiPsdTxtField.font = [UIFont systemFontOfSize:13];
    wifiPsdTxtField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:wifiPsdTxtField];
    _wifiPsdTxtField = wifiPsdTxtField;
    _wifiPsdTxtField.returnKeyType = UIReturnKeyDone;
    _wifiPsdTxtField.delegate=self;
    
    [wifiPsdTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wifiNameTxtField.mas_left);
        make.right.mas_equalTo(wifiNameTxtField.mas_right);
        make.height.mas_equalTo(wifiNameTxtField.mas_height);
        make.top.mas_equalTo(wifiNameTxtField.mas_bottom).offset(20);
    }];
    UIButton *secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secBtn setImage:[UIImage imageNamed:@"icon_eyes_close"] forState:UIControlStateNormal];
    [secBtn setImage:[UIImage imageNamed:@"icon_eyes_open"] forState:UIControlStateSelected];
    secBtn.frame = CGRectMake(0, 0, 26, 13);
    wifiPsdTxtField.rightView = secBtn;
    wifiPsdTxtField.rightViewMode = UITextFieldViewModeAlways;
    @weakify(self);
    [[secBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * btn) {
        @strongify(self);
        [btn setSelected:!btn.isSelected];
        self.wifiPsdTxtField.secureTextEntry = !btn.isSelected;
    }];
    
    
    UILabel * alertLab = [UILabel new];
    alertLab.textAlignment = NSTextAlignmentLeft;
    alertLab.textColor = UIColorHex(0xabaeb2);
    alertLab.text = @"注:暂不支持链接5GWiFi";
    alertLab.numberOfLines = 0;
    alertLab.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:alertLab];
    [alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wifiNameTxtField.mas_left);
        make.top.mas_equalTo(wifiPsdTxtField.mas_bottom);
        make.height.mas_equalTo(20);
    }];

    UIButton *wifiBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [wifiBtn setTitle:@"连接WiFi" forState:UIControlStateNormal];
    wifiBtn.layer.cornerRadius = 45 *0.5;
    wifiBtn.layer.masksToBounds = true;
    [wifiBtn addTarget:self action:@selector(checkWifiPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wifiBtn];
    [wifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wifiNameTxtField.mas_left);
        make.right.mas_equalTo(wifiNameTxtField.mas_right);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(-100);
    }];
    
    
}

-(NSString *)wiFiSSID
{
#if TARGET_OS_SIMULATOR
    return @"(simulator)";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;
    
    return ssid;
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)checkWifiPassWord
{
    // 注意 WiFi密码长度限制 32
    NSString *password = self.wifiPsdTxtField.text;
    [self connectWifiAction:password];
}

#pragma mark - action: 连接 wifi点击
- (void)connectWifiAction:(NSString*)password{
    RTBingsResultController *resultVC = [RTBingsResultController new];
    resultVC.wifiSSid = self.wifiNameTxtField.text;
    resultVC.wifiPassword = password;
    [self.navigationController pushViewController:resultVC animated:YES];
}


#pragma mark ------------------- UITextFieldDelegate ------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.wifiNameTxtField) {
        [self.wifiPsdTxtField becomeFirstResponder];
    }else if (textField == self.wifiPsdTxtField){
        [self checkWifiPassWord];
    }
    return YES;
}

@end
