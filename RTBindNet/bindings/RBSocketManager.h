//
//  RBSocketManager.h
//  tcpDemo
//
//  Created by baxiang on 2016/12/5.
//  Copyright © 2016年 baxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBSocketManager : NSObject

@property (nonatomic, strong) NSData *writeData;

@property (nonatomic, copy) void(^didReadDataBlock)(NSDictionary *readData);


/**
 *  单例
 */
+ (RBSocketManager*)defaultSocket;
/**
 *  发送链接请求
 */
- (BOOL)startConnect:(NSString *)host port:(NSString *)port;

/**
 发送数据

 @param data 数据data
 */
- (void)sendData:(NSData *)data;

@end
