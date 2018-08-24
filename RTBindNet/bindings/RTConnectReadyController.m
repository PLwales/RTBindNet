//
//  RTConnectReadyController.m
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTConnectReadyController.h"
#import "RTSearchDeviceController.h"
#if !(TARGET_IPHONE_SIMULATOR)
#import "RTBluetoothManager.h"
#endif
#import "Masonry.h"
@interface RTConnectReadyController ()
@property(nonatomic,weak) UIButton *nextBtn;
@end

@implementation RTConnectReadyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择设备";
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *connectImage = [UIImageView new];
    [self.view addSubview:connectImage];
    connectImage.image = [UIImage imageNamed:@"icon_close"];
    [connectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(44);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.width.mas_equalTo(179);
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"长按设备联网按钮";
    titleLabel.textColor = UIColorHex(0x4a4a4a);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(connectImage.mas_bottom).offset(25);
    }];
    NSString *tipText = @"1)请确认设备开机\n2)长按联网键\n3)听到提示音后，点击继续";
    NSMutableAttributedString *attributedTip = [[NSMutableAttributedString alloc] initWithString:tipText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedTip addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipText length])];
    UILabel *tipLabel = [UILabel new];
    tipLabel.textColor = UIColorHex(0x6e6e6e);
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.attributedText = attributedTip;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(connectImage.mas_left).offset(-10);
        make.right.mas_equalTo(connectImage.mas_right).offset(10);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(18);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    
    [nextBtn setTitle:@"继续" forState:UIControlStateNormal];
    [nextBtn setTitle:@"蓝牙未打开" forState:UIControlStateDisabled];
    [nextBtn setBackgroundColor:RTColorForBackground];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    nextBtn.layer.cornerRadius = 22.5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-75);
    }];
    [nextBtn addTarget:self action:@selector(searchDeviceHandle) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn = nextBtn;
    
    // 切换配网按钮
   
    #if !(TARGET_IPHONE_SIMULATOR)
//      @weakify(self);
     [RTBluetoothManager sharedInstance].bleStateBlock = ^(RTBleState bleState) {
//        @strongify(self);
        if (bleState == RTBleStatePoweroff) {
            [self.nextBtn setEnabled:NO];
//             [RBToastView showWithText:@"蓝牙为打开" inView:self.view];
        }else{
            [self.nextBtn setEnabled:YES];
        }
    };
    #endif
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO];
     #if !(TARGET_IPHONE_SIMULATOR)
    if ([RTBluetoothManager sharedInstance].blestate== RTBleStatePoweroff) {
         [self.nextBtn setEnabled:NO];
    }else{
        [self.nextBtn setEnabled:YES];
    }
     #endif
}

-(void)searchDeviceHandle
{
    RTSearchDeviceController *searchVC = [RTSearchDeviceController new];
    [self.navigationController pushViewController:searchVC animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
