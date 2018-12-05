//
//  Header.h
//  Pods
//
//  Created by baxiang on 2017/11/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __has_include(<RBToyAPI/RBToyAPI.h>)
#import <RBToyAPI/RBAccessConfig.h>
#import <RBToyAPI/RBDeviceApi.h>
#import <RBToyAPI/RBDeviceModel.h>
#import <RBToyAPI/RBPlayerApi.h>
#import <RBToyAPI/RBResourceModel.h>
#import <RBToyAPI/RBUserApi.h>
#import <RBToyAPI/RBUserModel.h>
#else
#import "RBAccessConfig.h"
#import "RBDeviceApi.h"
#import "RBDeviceModel.h"
#import "RBPlayerApi.h"
#import "RBResourceModel.h"
#import "RBUserApi.h"
#import "RBUserModel.h"
#endif


