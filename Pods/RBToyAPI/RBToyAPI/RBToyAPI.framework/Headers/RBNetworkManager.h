//
//  RBNetworkManager.h
//  Pods
//
//  Created by baxiang on 16/11/12.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN  NSString * const RBResponseErrorDomain;
/**
 网络请求管理类
 */
@interface RBNetworkManager : NSObject
+ (instancetype)defaultManager;
-(void)setupNetworkConfig;
+(void)get:(NSString*)urlStr parameters:(NSDictionary*) parameters completionBlock:(void (^)(id response,NSError *error)) completionBlock;
+(void)post:(NSString*)urlStr auth:(BOOL)isAuth parameters:(NSDictionary*) parameters completionBlock:(void (^)(id response,NSError *error)) completionBlock;

+(void)upload:(NSString *)urlStr auth:(BOOL)isAuth  parameters:(NSDictionary *)parameters filePath:(NSString*)filePath progressBlock:(void(^)(NSProgress *))progressBlock completionBlock:(void (^)(id, NSError *))completionBlock;

+(void)uploadImage:(NSString *)urlStr auth:(BOOL)isAuth parameters:(NSDictionary *)parameters imageData:(NSData*)imageData progressBlock:(void(^)(NSProgress *))progressBlock completionBlock:(void (^)(id, NSError *))completionBlock;
+(NSError*)customErrorWithCode:(NSInteger)code;
@end
NS_ASSUME_NONNULL_END
