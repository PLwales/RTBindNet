//
//  RBDeviceModel.h
//  Pods
//
//  Created by baxiang on 16/11/12.
//
//

#import <Foundation/Foundation.h>
@class RBBabyModel;
@class RBPlayInfoModel;
NS_ASSUME_NONNULL_BEGIN
@interface RBDeviceUser : NSObject<NSCoding>
@property (nonatomic,strong) NSString *userID;//用户的userID
@property (nonatomic,strong) NSString *headimg;// 用户头像
@property (nonatomic,strong) NSString *name;//用户名称
@property (nonatomic,assign) BOOL manager;//YES管理员 NO普通成员
@end
@interface RBBindInfo : NSObject //修改网络或者绑定设备时的结果
@property (nonatomic,strong) NSString *deviceID; // 设备ID
@property (nonatomic,strong) NSString * result; //联网结果（success-成功；failure-失败）注意success 只代表网络连接成功 并不代表当前绑定设备成功
@property (nonatomic,assign) BOOL isFirstBinded; //是否第一次绑定
@property (nonatomic,assign) BOOL isBinded;// 1 代表绑定成功 0 失败
@property (nonatomic,strong) NSString * bindtel; //当前设备已经被绑定时回返回管理员的手机号码
@property (nonatomic,strong) NSString *mainctl;// 设备id
@property (nonatomic,strong) NSString *pid;//用户id
@end


@interface RBDevicesDetail : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) NSString *deviceID; // 设备ID
@property (nonatomic,strong) NSString *name;// 设备的名称
@property (nonatomic,assign) BOOL online;// 是否连接网络
@property (nonatomic,strong) NSString* device_type;//设备类型
@property (nonatomic,assign) NSInteger volume;//音量大小
@property (nonatomic,assign) BOOL power;//是否在充电中
@property (nonatomic,assign) BOOL power_supply;//是否连接电源
@property (nonatomic,assign) NSInteger battery;//设备当前电量
@property (nonatomic,strong) NSString*wifissid;
@property (nonatomic,strong) NSString*index_config;
@property (nonatomic,strong) NSArray <RBDeviceUser*>*users;//绑定当前的设备的用户组
@property (nonatomic,strong) RBBabyModel*growplan;
@property (nonatomic,strong) RBPlayInfoModel*playinfo;
@property (nonatomic,assign) BOOL isEarLightOn;
@property (nonatomic,assign) BOOL isChildLockOn;
@end

@interface RBDeviceModel : NSObject<NSCoding>
@property (nonatomic,strong) NSString *deviceID;//  设备ID
@property (nonatomic,assign) NSInteger battery;//设备当前电量
@property (nonatomic,assign) BOOL manager;// YES管理员 NO普通成员
@property (nonatomic,strong) NSString *name;//设备的名称
@property (nonatomic,assign) BOOL online;//是否连接网络
@property (nonatomic,assign) BOOL power;//是否在充电中
@property (nonatomic,assign) BOOL power_supply;// 是否连接电源
@property (nonatomic,strong) NSString *device_type;// 设备类型
@property (nonatomic,assign) NSInteger volume;// 设备声音
@property (nonatomic,strong) RBDevicesDetail *detail;//当前控制设备的详情
@end

@interface RBHardwareModel : NSObject
@property(nonatomic,strong) NSString *model;// 设备类型
@property(nonatomic,strong) NSString *wifiName;// 连接的wifi名称
@property(nonatomic,strong) NSString *SN;//设备sn
@property(nonatomic,strong) NSString *IP;// 网络ip
@property(nonatomic,strong) NSString *MAC;//硬件mac
@end

@interface RBChatModel : NSObject
@property(nonatomic,strong) NSString *content;//消息内容（文本或音频url）
@property(nonatomic,strong) NSString *created_at;//时间
@property(nonatomic,strong) NSNumber *chatID;// 唯一标识符
@property(nonatomic,assign) NSInteger sendtype;//消息方向： 1-APP发给设备，2-设备发给APP
@property(nonatomic,assign) NSInteger type;// 消息类型：1-文本，2-音频
@property(nonatomic,assign) NSInteger length;
@property(nonatomic,assign) float size;
@end

@interface RBChatList : NSObject
@property(nonatomic,assign) NSInteger total;// 总数量
@property(nonatomic,strong) NSArray <RBChatModel*>*list;// 聊天列表
@end



@interface RBMessageModel : NSObject
@property(nonatomic,strong) NSString *mID;//消息的ID
@property(nonatomic,strong) NSString *masterId;//当前设备端ID
@property(nonatomic,strong) NSString *receiverUserID;
@property(nonatomic,strong) NSString *title;//消息头
@property(nonatomic,strong) NSString *content;//消息内容
@property(nonatomic,strong) NSString *timestamp;
@end

@interface RBAlarmModel : NSObject
@property(nonatomic,strong) NSString *alarmId;// 闹钟ID
@property(nonatomic,assign) NSInteger timer; //闹钟时间 从00：00开始的秒数 如12：10可以转换为12*3600+10*60=43800
@property(nonatomic,strong) NSString *timezone;//时区，GMT(\+|-)[0-9]+ 格式
@property(nonatomic,assign) NSInteger type;//闹钟类型，
@property(nonatomic,strong) NSString *name;//闹钟名称
@property(nonatomic,strong) NSString *sound;//闹钟提示音url
@property(nonatomic,strong) NSString *repeat;//重复类型 1-7代表周一到周日 "-1"代表一次性闹钟
@property(nonatomic,assign) BOOL status;//闹钟状态
@property(nonatomic,strong) NSString *extra;//自定义内容
@property(nonatomic,strong) NSString *week;//1-7分别代表周一到周日，只会在单次闹钟中使用，重复闹钟返回0
@end

@interface RBAlarmList : NSObject
@property(nonatomic,assign) NSInteger total;// 总数量
@property(nonatomic,strong) NSArray <RBAlarmModel*>*alarms;// 闹钟模型
@end

NS_ASSUME_NONNULL_END
