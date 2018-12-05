//
//  RBAccessConfig.h
//  PuddingAPIDemo
//
//  Created by baxiang on 2017/4/19.
//  Copyright © 2017年 baxiang. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RBDevelopEnv) {
    RBDevelopEnv_Relese = 0,// 发布环境
    RBDevelopEnv_Dedug,// 开发环境
    RBDevelopEnv_Alpha,// 测试环境
};


/**
  roobo sdk 全局配置文件
 */
@interface RBAccessConfig : NSObject

/**
 开发环境   分为开发和发布环境
 */
@property(nonatomic,assign) RBDevelopEnv developEnv;

+(BOOL)saveDevelopEnv:(RBDevelopEnv)developEnv;
+(BOOL)saveAppID:(NSString*)AppID;
+(BOOL)saveAccessToken:(NSString*)accessToken;
+(BOOL)saveUserID:(NSString *)userID;
+(BOOL)saveDeviceID:(NSString *)currDeviceID;

+(RBDevelopEnv)getDevelopEnv;
+(NSString*)getAppID;
+(NSString*)getAccessToken;
+(NSString*)getUserID;
+(NSString*)getDeviceID;

/**
清空登录用户的配置信息
 */
+(void)clearLoginUserData;

@end

NS_ASSUME_NONNULL_END
