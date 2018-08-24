//
//  RTSearchDeviceController.m
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTSearchDeviceController.h"
#if !(TARGET_IPHONE_SIMULATOR)
#import "RTBluetoothManager.h"
#endif
#import "RTSelectNetController.h"

typedef NS_ENUM(NSInteger,RTSearchDeviceType){
    RTSearchDeviceTypeSearch = 0,
    RTSearchDeviceTypeSucc = 1,
    RTSearchDeviceTypeFailed = 2,
};

@interface RTSearchDeviceController ()
@property(nonatomic,strong) NSMutableArray *deviceArray;
@property(nonatomic,strong) RACDisposable *signal;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,weak) UILabel *deviceLabel;
@property(nonatomic,weak) UIImageView *searchImageView;
@property(nonatomic,assign) RTSearchDeviceType searchTypeView;
@end

@implementation RTSearchDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找设备";
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    _scrollView = scrollView;
    
    [self setupSearchView];
    [self setupSussResult];
    [self setupFailedView];
    #if !(TARGET_IPHONE_SIMULATOR)
    @weakify(self);
    [RTBluetoothManager sharedInstance].bleStateBlock = ^(RTBleState bleState) {
        @strongify(self);
        if (bleState == RTBleStateWaitToConnect) {
            self.searchTypeView = RTSearchDeviceTypeSucc;
        }
        if (bleState == RTBleStateNoDevice) {
           self.searchTypeView = RTSearchDeviceTypeFailed;
        }
    };
    #endif
}

-(void)setupSearchView
{
    UIView *searchView = [UIView new];
    [_scrollView addSubview:searchView];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIImageView *waitImage = [UIImageView new];
    [searchView addSubview:waitImage];
    waitImage.image = [UIImage imageNamed:@"icon_search_wait"];
    [waitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchView.mas_centerX);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(25);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(250);
    }];
    
    UIImageView *searchImageView = [UIImageView new];
    [searchView addSubview:searchImageView];
    searchImageView.image = [UIImage imageNamed:@"search_0"];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchView.mas_centerX);
        make.top.mas_equalTo(waitImage.mas_top);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(250);
    }];
    NSMutableArray * searchArray = [NSMutableArray new];
    for(int i =0 ; i <=20 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"search_%d",i]];
        if(image){
            [searchArray addObject:image];
        }
    }
    searchImageView.animationImages = searchArray;
    [searchImageView setAnimationDuration:2];
    [searchImageView setAnimationRepeatCount:-1];
    _searchImageView = searchImageView;
    
    UILabel *titleLabel = [UILabel new];
    [searchView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = UIColorHex(0x4a4a4a);
    titleLabel.text = @"正在查找设备，请耐心等待...";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(waitImage.mas_bottom).offset(40);
    }];
}

-(void)setupSussResult
{
    UIView *succView = [UIView new];
    [_scrollView addSubview:succView];
    succView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *successImage = [UIImageView new];
    [succView addSubview:successImage];
    successImage.image = [UIImage imageNamed:@"icon_detected"];
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(succView.mas_centerX);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(25);
        make.width.mas_equalTo(successImage.image.size.width);
        make.height.mas_equalTo(successImage.image.size.height);
    }];
    
    UILabel *titleLable = [UILabel new];
    [succView addSubview:titleLable];
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"查找到以下设备";
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(successImage.mas_bottom).offset(40);
    }];
    
    UILabel *deviceLabel = [UILabel new];
    [succView addSubview:deviceLabel];
    deviceLabel.font = [UIFont systemFontOfSize:20];
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    [deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLable.mas_bottom).offset(10);
    }];
   
    _deviceLabel = deviceLabel;
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundColor:RTColorForBackground];
    [succView addSubview:nextBtn];
    [nextBtn setTitle:@"继续" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 22.5;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(succView.mas_centerX);
        make.bottom.mas_equalTo(-75);
    }];
    [nextBtn addTarget:self action:@selector(nextStepHandle) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupFailedView
{
    
    UIView *failedView = [UIView new];
    [_scrollView addSubview:failedView];
    failedView.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *failedImageView = [UIImageView new];
    [failedView addSubview:failedImageView];
    failedImageView.image = [UIImage imageNamed:@"icon_not_detected"];
    [failedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(failedView.mas_centerX);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(25);
        make.width.mas_equalTo(failedImageView.image.size.width);
        make.height.mas_equalTo(failedImageView.image.size.height);
    }];
    
    UILabel *failedLabel = [UILabel new];
    [failedView addSubview:failedLabel];
    failedLabel.font = [UIFont systemFontOfSize:18];
    failedLabel.textAlignment = NSTextAlignmentCenter;
    failedLabel.text = @"未检测到设备，请重试";
    [failedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(failedImageView.mas_bottom).offset(40);
    }];
    
    UIButton *rebindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [failedView addSubview:rebindingBtn];
    [rebindingBtn setBackgroundColor:RTColorForBackground];
    [rebindingBtn setTitle:@"重新查找" forState:UIControlStateNormal];
    rebindingBtn.layer.cornerRadius = 22.5;
    [rebindingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(failedView.mas_centerX);
        make.bottom.mas_equalTo(-75);
    }];
    [rebindingBtn addTarget:self action:@selector(reSearchHandle) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setSearchTypeView:(RTSearchDeviceType )searchTypeView
{
    _searchTypeView = searchTypeView;
     #if !(TARGET_IPHONE_SIMULATOR)
    if (searchTypeView == RTSearchDeviceTypeSearch) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [_searchImageView startAnimating];
        [[RTBluetoothManager sharedInstance] cancelAllConnect];
        [[RTBluetoothManager sharedInstance] scanPeripherals];
        if (!self.signal.isDisposed) [self.signal dispose];
        _signal = [[RACScheduler mainThreadScheduler]afterDelay:10 schedule:^{
            [[RTBluetoothManager sharedInstance] stopScanPeripherals];
        }];
    }
    if (searchTypeView == RTSearchDeviceTypeSucc) {
        [_searchImageView stopAnimating];
        self.deviceLabel.text = [RTBluetoothManager sharedInstance].currentdevice.name;
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    if (searchTypeView == RTSearchDeviceTypeFailed) {
         [_searchImageView stopAnimating];
         [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:NO];
    }
  #endif
}

-(void)reSearchHandle{
    self.searchTypeView = RTSearchDeviceTypeSearch;
}

-(void)popViewController
{
     [self.navigationController popViewControllerAnimated:YES];
//    if (_searchTypeView == RTSearchDeviceTypeSearch) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    if (_searchTypeView == RTSearchDeviceTypeSucc) {
//        self.searchTypeView = RTSearchDeviceTypeSearch;
//    }
//    if (_searchTypeView == RTSearchDeviceTypeFailed) {
//       [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(void)nextStepHandle
{
    RTSelectNetController *netVC = [RTSelectNetController new];
    [self.navigationController pushViewController:netVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchTypeView = RTSearchDeviceTypeSearch;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.signal.isDisposed) [self.signal dispose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
