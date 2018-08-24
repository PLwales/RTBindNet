//
//  RTSoundSendController.m
//  StoryToy
//
//  Created by roobo on 2018/5/8.
//  Copyright © 2018年 roobo. All rights reserved.
//

#import "RTSoundSendController.h"
#import "RTSoundBindResultViewController.h"

@interface RTSoundSendController ()

@end

@implementation RTSoundSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"声波配网";
    UIImageView *connectImage = [UIImageView new];
    [self.view addSubview:connectImage];
    connectImage.image = [UIImage imageNamed:@"icon_sound_send"];
    [connectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(19);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(220);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"点击发送声波";
    titleLabel.textColor = UIColorHex(0x4a4a4a);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(connectImage.mas_bottom).offset(30);
    }];
    
    UIView *borderView = [[UIView alloc] init];
    [self.view addSubview:borderView];
    borderView.layer.borderColor = UIColorHex(0xdedede).CGColor;
    borderView.layer.borderWidth = 0.5;
    borderView.layer.cornerRadius = 5;
    borderView.layer.masksToBounds = YES;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(100);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setImage:[UIImage imageNamed:@"icon_sound_tip1"] forState:UIControlStateNormal];
    [button setTitle:@"将手机靠近设备" forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0x7d7d7d) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.userInteractionEnabled = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(borderView).offset(20);
        make.top.mas_equalTo(borderView).offset(15);
        make.right.mas_equalTo(borderView);
        make.height.mas_equalTo(14);
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button2];
    [button2 setImage:[UIImage imageNamed:@"icon_sound_tip2"] forState:UIControlStateNormal];
    [button2 setTitle:@"尽量选择安静的环境" forState:UIControlStateNormal];
    [button2 setTitleColor:UIColorHex(0x7d7d7d) forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    button2.userInteractionEnabled = NO;
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button);
        make.top.mas_equalTo(button.mas_bottom).offset(14);
        make.width.mas_equalTo(button);
        make.height.mas_equalTo(button);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button3];
    [button3 setImage:[UIImage imageNamed:@"icon_sound_tip3"] forState:UIControlStateNormal];
    [button3 setTitle:@"机器人成功接收声波后会语音提示" forState:UIControlStateNormal];
    [button3 setTitleColor:UIColorHex(0x7d7d7d) forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    button3.userInteractionEnabled = NO;
    button3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button);
        make.top.mas_equalTo(button2.mas_bottom).offset(14);
        make.width.mas_equalTo(button);
        make.height.mas_equalTo(button);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x7290ff)] forState:UIControlStateNormal];
    [nextBtn setTitle:@"发送声波" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 22.5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view).offset(-57);
    }];
    [nextBtn addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    
    if (SCREEN_HEIGHT < 667) {
        [connectImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(15);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(220);
        }];
        
        [nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view).offset(-15);
        }];
    }
}

- (void)clickNext {
    RTSoundBindResultViewController *setupVC = [RTSoundBindResultViewController new];
    setupVC.wifiSSid = self.wifiSSid;
    setupVC.wifiPassword = self.wifiPassword;
    [self.navigationController pushViewController:setupVC animated:YES];
}
@end
