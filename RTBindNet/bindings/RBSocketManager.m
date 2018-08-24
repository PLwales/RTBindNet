//
//  RBSocketManager.m
//  tcpDemo
//
//  Created by baxiang on 2016/12/5.
//  Copyright © 2016年 baxiang. All rights reserved.
//

#import "RBSocketManager.h"
#import "GCDAsyncSocket.h"

@interface RBSocketManager()<GCDAsyncSocketDelegate>
@end

@implementation RBSocketManager {
    GCDAsyncSocket* socket;
}

+ (RBSocketManager *)defaultSocket {
    // socket只会实例化一次
    static RBSocketManager* socket=nil;
    // 保证线程安全，defaultSocket只执行一次
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        socket=[[RBSocketManager alloc] init];
    });
    return socket;
}

/**
 *  初始化
 *
 *
 *  @return self
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        socket=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}
/**
 *  发送链接请求
 */
- (BOOL)startConnect:(NSString *)host port:(NSString *)port {
    // 先确定断开连接再开始链接
    if (socket.isConnected) {
        [socket disconnect];
    }
    NSError* error;
    if (port == nil) {
        port = @"12811";
    }
    BOOL isSuccess= [socket connectToHost:host onPort:[port integerValue] error:&error];
    if (error) {
        NSLog(@"error.localizedDescription:%@",error.localizedDescription);
    }
    
    return isSuccess;
}

- (void)sendData:(NSData *)data {
    // 连接AP热点之后发送Wi-Fi数据
    NSError* error;
    [socket writeData:self.writeData withTimeout:-1 tag:0];
    // 保持读取的长连接
    [socket readDataWithTimeout:-1 tag:0];
    if (error) {
        NSLog(@"localizedDescription:%@",[error localizedDescription]);
        NSLog(@"localizedFailureReason:%@",[error localizedFailureReason]);
    }
}

#pragma mark - GCDAsyncSocketDelegate
/**
 *  链接成功
 *
 *  @param sock sock实例
 *  @param host IP
 *  @param port 端口
 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host
         port:(uint16_t)port {
    NSLog(@"连接主机成功");
}

/**
 *  发送数据成功
 *
 *  @param sock  sock实例
 *  @param tag  标记sock
 */
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
       NSLog(@"发送数据成功");
}
/**
 *  已经获取到数据
 *
 *  @param sock sock实例
 *  @param data 获取到的数据
 *  @param tag  标记sock
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data
      withTag:(long)tag{
    NSError* error=nil;
    NSDictionary* json=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:&error];
    
    NSLog([NSJSONSerialization isValidJSONObject:json]?@"is ValidJSONObject":@"is't ValidJSONObject");
    if (error)
    {
        NSLog(@"socketError1:%@",[error localizedDescription]);
        NSLog(@"socketError2:%@",[error localizedFailureReason]);
    }
    if (self.didReadDataBlock) {
        self.didReadDataBlock(json);
    }
    [sock disconnect];
}

/**
 *  链接出错
 *
 *  @param sock sock实例
 *  @param err  错误参数
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    //    NSLog(@"%s",__FUNCTION__);
    if (err)
    {
        NSLog(@"socketDidDisconnect:%@",[err localizedDescription]);
        NSLog(@"socketDidDisconnect:%@",[err localizedFailureReason]);
    }
    //    self.didReadData(nil);
}

@end
