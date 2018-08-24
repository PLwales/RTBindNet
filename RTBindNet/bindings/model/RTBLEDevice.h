//
//  RTBLEDevice.h
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface RTBLEDevice : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)CBPeripheral *Peripheral;
@end
