//
//  RTSetupAPNetViewController.m
//  StoryToy
//
//  Created by roobo on 2018/5/30.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTSetupAPNetViewController.h"
#import "RTBindingAPDeviceViewController.h"
#import "UIDevice+RBExtension.h"
#import "ReactiveObjC.h"
#import "UIImage+RBExtension.h"

@interface RTSetupAPNetViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField * wifiNameTxtField;
@property (nonatomic, weak) UITextField * wifiPsdTxtField;
@property (nonatomic, weak) UIButton * wifiBtn;

@end

@implementation RTSetupAPNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //初始化导航
    self.title = @"配置网络";
    UIImageView *successImage = [UIImageView new];
    [self.view addSubview:successImage];
    successImage.image = [UIImage imageNamed:@"icon_wifi"];
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(25);
        make.width.mas_equalTo(successImage.image.size.width);
        make.height.mas_equalTo(successImage.image.size.height);
    }];
    
    UITextField * wifiNameTxtField = [UITextField new];
    wifiNameTxtField.placeholder = @"请输入WiFi账号";
    wifiNameTxtField.returnKeyType = UIReturnKeyNext;
    wifiNameTxtField.borderStyle = UITextBorderStyleRoundedRect;
    wifiNameTxtField.textColor = [UIColor blackColor];
    wifiNameTxtField.backgroundColor = [UIColor clearColor];
    wifiNameTxtField.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:wifiNameTxtField];
    [wifiNameTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(250);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(45);
    }];
    _wifiNameTxtField = wifiNameTxtField;
    _wifiNameTxtField.returnKeyType = UIReturnKeyNext;
    _wifiNameTxtField.delegate=self;
    
    UITextField * wifiPsdTxtField =[UITextField new];
    wifiPsdTxtField.placeholder = @"请输入WiFi密码";
    wifiPsdTxtField.returnKeyType = UIReturnKeyGo;
    wifiPsdTxtField.borderStyle = UITextBorderStyleRoundedRect;
    wifiPsdTxtField.secureTextEntry = YES;
    wifiPsdTxtField.keyboardType = UIKeyboardTypeAlphabet;
    wifiPsdTxtField.font = [UIFont systemFontOfSize:13];
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
    alertLab.text = @"暂不支持5G频段以及隐藏的WIFI";
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
    [wifiBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x7290ff)] forState:UIControlStateNormal];
    [wifiBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xc0c0c1)] forState:UIControlStateDisabled];
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
    
    RAC(wifiBtn,enabled) = [RACSignal combineLatest:@[wifiNameTxtField.rac_textSignal] reduce:^id (NSString *ssid){
        return @([ssid isNotBlank]);
    }];
}

-(void)checkWifiPassWord {
    // 注意 WiFi密码长度限制 32

    NSString *password = self.wifiPsdTxtField.text;
    if (password.length > 0) {
        [self connectWifiAction:password];
    }else{
        UIAlertController *alerView = [UIAlertController alertControllerWithTitle:nil message:@"是否确定WiFi密码为空？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self connectWifiAction:@"123456"];

        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alerView addAction:doneAction];
        [alerView addAction:cancleAction];
        [self presentViewController:alerView animated:YES completion:nil];
    }
}

#pragma mark - action: 连接 wifi点击
- (void)connectWifiAction:(NSString*)password{
    RTBindingAPDeviceViewController *resultVC = [RTBindingAPDeviceViewController new];
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
