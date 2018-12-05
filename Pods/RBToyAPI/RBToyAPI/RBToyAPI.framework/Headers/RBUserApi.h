//
//  RBUserApi.h
//  Pods
//
//  Created by baxiang on 2017/8/25.
//
//

#import <Foundation/Foundation.h>
#include "RBUserModel.h"
NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger,RBSendCodeType) {
    RBSendCodeTypeRegister = 1,/**!注册新账号号发送**/
    RBSendCodeTypeResetPhone    = 2,/**!修改手机号发送**/
    RBSendCodeTypeResetPsd      = 3,/**!修改其他发送**/
};

@interface RBUserApi : NSObject

#pragma mark ------------------- 登录 ------------------------
/**
 第三方用户登录
 @param phone 手机号码
 @param passwd 密码
 @param thirdCode 应用ID（ROOBO提供的唯一应用ID
 */
+(void)loginEx:(NSString*)phone passwd:(NSString*)passwd thirdCode:(NSString*)thirdCode block:(void (^)(RBUserModel *user,NSError *error))block;

/**
 账户登录
 @param phone 手机号码
 @param passwd 用户密码
 */
+ (void)login:(NSString*)phone passWord:(NSString*)passwd pushToken:(NSString*)token block:(void (^)(RBUserModel *user,NSError *error))block;

/**
 更改手机号码
 
 @param phone 手机号码
 @param code 验证码
 @param password 手机密码
 */
+ (void)updatePhoneNum:(NSString *_Nonnull)phone  code:(NSString *_Nonnull)code password:(NSString *_Nonnull)password block:(nullable void (^)(BOOL isSuccess,NSError *error)) block;

/**
 修改密码
 
 @param oldPasswd 旧密码
 @param newPasswd 新密码
 */
+ (void)updatePassword:(NSString *)oldPasswd newPsd:(NSString *)newPasswd block:(void (^)(BOOL isSuccess,NSError *error)) block;

/**
 忘记密码重置
 
 @param passwd 新密码
 @param phone 手机号码
 @param code 手机验证码
 
 */
+ (void)resetPassword:(NSString *_Nonnull)passwd phoneNum:(NSString*_Nonnull)phone code:(NSString *_Nonnull)code  completionBlock:(nullable void (^)(BOOL isSuccess,NSError *error)) block;

/**
 退出登录
 */
+ (void)logOut:(void (^)(BOOL isSuccess,NSError *error)) block;
#pragma mark ------------------- 用户注册 ------------------------
/**
 用户手机号码是否注册
 
 @param phone 手机号码
 @param block IsRegist 1 = 注册  0=未注册
 */
+ (void)isRegist:(NSString *)phone block:(void (^)(BOOL isRegist,NSError *error)) block;
/**
 用户注册
 
 @param phone 手机号码
 @param passwd 用户密码
 @param code 验证码
 @param nickName 用户名称
 */
+ (void)regist:(NSString *)phone password:(NSString *)passwd code:(NSString *)code nickName:(NSString *)nickName pushToken:(NSString*)token block:(void (^)(RBUserModel *user,NSError *error)) block;

/**
 发送验证码
 
 @param phone 手机号码
 @param type 验证码类型
 
 */
+ (void)sendCode:(NSString *_Nonnull)phone type:(RBSendCodeType )type completionBlock:(nullable void (^)(BOOL isSend,NSError *error)) completionBlock;


#pragma mark ------------------- 用户权限 ------------------------
/**
 更改用户名称
 @param userID 用户id
 @param name 用户备注
 */
+ (void)updateUserRemark:(NSString *)userID name:(NSString *)name block:(void (^)(BOOL  isSuccess,NSError *error)) block;
/**
 更改管理员 注意：注意当前用户是管理员
 @param userID 用户的ID
 */
+ (void)changeManager:(NSString *)userID block:(void (^)(BOOL isSuccess, NSError* _Nullable error ))block;

/**
 添加用户到成员组 注意：注意当前用户是管理员
 
 @param phone 用户的手机号码
 */
+ (void)inviteUser:(nonnull NSString *)phone block:(void (^)(BOOL isSuccess,NSError*_Nullable error))block;

/**
 从当前设备成员组中删除用户 注意：注意当前用户是管理员
 
 @param userID 用户 id
 */
+ (void)deleteUser:(nonnull NSString *)userID block:(void (^)(BOOL isSuccess,NSError *_Nullable error))block;

#pragma mark ------------------- 宝宝信息 ------------------------

/**
 获取宝宝信息
 */
+(void)getBabyList:(void (^)(NSArray<RBBabyModel*>*babyModels,NSError *error))block;

/**
 增加宝宝信息
 @param babyModel 宝宝数据模型
 */
+(void)addBabyInfo:(RBBabyModel*)babyModel block:(void (^)(RBBabyModel *babyModel,NSError *error))block;

/**
 修改宝宝信息
 @param babyModel 宝宝数据模型
 */
+(void)editBabyInfo:(RBBabyModel*)babyModel block:(void (^)(BOOL isSuccess,NSError *error))block;

/**
 删除宝宝信息
 @param babyIds 宝宝ID数组
 */
+(void)deleteBabyInfo:(NSArray<NSString*>*)babyIds block:(void (^)(BOOL isSuccess,NSError *error))block;

/**
 增加修改宝宝标签
 @param tags 宝宝标签 以/分割标签
 */
+(void)addBabyTags:(NSString*)tags babyID:(NSString*)babyID block:(void (^)(BOOL isSuccess,NSError *error))block;

/**
 获取宝宝心理模型
 @param babyID 宝宝ID
 */
+(void)getGrowthModel:(NSString*)babyID  block:(void (^)(RBBabyGrowthModel *growthModel,NSError *error))block;

/**
 上传宝宝头像资源
 @param avatarImage 图片的数据
 */
+ (void)uploadBabyAvatar:(NSString*)babyID avatarImage:(UIImage *)avatarImage progressBlock:(void(^)(NSProgress *progress))progressBlock resultBlock:(void (^)(NSString *imgURL, NSError * _Nullable))resultBlock;

/**
 上传图片接口
 @param image 图片资源
 */
+ (void)uploadImg:(UIImage *)image progressBlock:(void(^)(NSProgress *progress))progressBlock resultBlock:(void (^)(RBAvatarModel *avatarModel, NSError * _Nullable))resultBlock;

/**
 修改登录用户的昵称
 */
+ (void)updateNickname:(NSString *)name block:(void (^)(BOOL  isSuccess,NSError *error)) block;

/**
 修改其他用户的昵称
 @param userID 用户ID
 @param name 用户名称
 */
+ (void)updateUser:(NSString *)userID name:(NSString *)name block:(void (^)(BOOL  isSuccess,NSError *error)) block;

/**
 上传用户头像
 @param urlStr 图片路径地址
 */
+(void)uploadUserAvatar:(NSString*)urlStr block:(void (^)(BOOL isSuccess,NSError *error))block;


/**
 获取宝宝动态列表

 @param maxID 最大ID
 @param block 返回动态资源列表
 */
+ (void)getBabySharedList:(NSString *)maxID block:(void (^)(NSArray<RBBabyMomentModel *> *response,NSError *error)) block;

@end
NS_ASSUME_NONNULL_END
