//
//  RTBluetoothManager.h
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RTBLEDevice.h"
@class RTOpmodeObject;
typedef NS_ENUM(NSInteger,RTBleState) {
    RTBleStateUnknown = 0,
    RTBleStatePowerOn,
    RTBleStatePoweroff,
    RTBleStateIdle,
    RTBleStateScan,
    RTBleStateCancelConnect,
    RTBleStateNoDevice,// 没有发现设备
    RTBleStateWaitToConnect,
    RTBleStateConnecting,
    RTBleStateConnected,
    RTBleStateWritable,
    RTBleStateDisconnect,
    RTBleStateReConnect,
    RTBleStateConnecttimeout,
    RTBleStateReconnecttimeout,
};

typedef void(^RTBLEStateChangeBlock)(RTBleState bleState);

@interface RTBluetoothManager : NSObject
@property(nonatomic,copy) RTBLEStateChangeBlock bleStateBlock;
@property(nonatomic,assign) RTBleState blestate;
@property(nonatomic,strong)RTBLEDevice *currentdevice;
@property(nonatomic,strong)NSMutableArray *BLEDeviceArray;//扫描周围蓝牙设备集合
+ (RTBluetoothManager *)sharedInstance;
-(void)scanPeripherals;
-(void)stopScanPeripherals;
-(void)cancelAllConnect;
-(void)connectDevice;
-(void)setOpmodeObject:(RTOpmodeObject *)object;
@end
