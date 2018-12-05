//
//  RBUserModel.h
//  Pods
//
//  Created by baxiang on 16/11/12.
//
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class RBDeviceModel;

//用户基本信息
@interface RBUserModel : NSObject <NSCoding>
@property (nonatomic,strong) NSString *userid;//id
@property (nonatomic,strong) NSString *headimg;//头像
@property (nonatomic,strong) NSString *name;//昵称
@property (nonatomic,strong) NSString *token;//用户token信息
@property (nonatomic,strong) NSArray <RBDeviceModel*> *devices;//用户所拥有的设备
@end

//宝宝信息模型
@interface RBBabyModel : NSObject<NSCoding>
@property(nonatomic,strong) NSString *babyId;
@property(nonatomic,strong) NSString *birthday;//生日 格式"YYYY-MM-dd"
@property(nonatomic,strong) NSString *img;// 头像
@property(nonatomic,strong) NSString *nickname;//昵称
@property(nonatomic,strong) NSString *gender;//性别
@property (nonatomic,strong) NSString *age;//年龄
@property (nonatomic,strong) NSString *tips;//建议
@property (nonatomic,strong) NSArray<NSString*>*tags;//标签
@end

//宝宝标签
@interface RBBabyTagModel :NSObject
@property(nonatomic,assign) NSInteger val; // 标签比重 百分制
@property(nonatomic,strong) NSString *name;//标签名称
@end

//宝宝成长资源
@interface RBBabyResModel :NSObject
@property(nonatomic,copy) NSString *rID;//资源ID
@property(nonatomic,copy) NSString *aID;// 专辑ID
@property(nonatomic,copy) NSString *title;//资源名称
@property(nonatomic,copy) NSString *img;//专辑图片
@property(nonatomic,strong) NSArray<NSString*>*tags;//模块标签
@end

//宝宝心理模块
@interface RBBabyModModel : NSObject
@property(nonatomic,assign) NSInteger score;// 模块比重 百分制
@property(nonatomic,strong) NSString *features;// 模块内容
@property(nonatomic,strong) NSString *name;//模块数组
@property(nonatomic,strong) NSArray<RBBabyResModel*> *resources;//宝宝推荐资源
@property(nonatomic,strong) NSArray<RBBabyTagModel*> *tags;//模块标签
@end

//宝宝成长模型
@interface RBBabyGrowthModel : NSObject
@property(nonatomic,strong) NSString *des;// 阶段特征
@property(nonatomic,strong) NSString *tips;// 早教贴士
@property(nonatomic,strong) NSArray<RBBabyModModel*> *mod;//心理模型模块数组
@end
@interface RBAvatarModel: NSObject
@property(nonatomic,strong) NSString *img;// 图片名
@property(nonatomic,strong) NSString *large;//大图url
@property(nonatomic,strong) NSString *thumb;//小图url
@end

// 宝宝动态资源模型
@interface RBBabyMomentModel: NSObject
@property(nonatomic,strong) NSString *momentID; // 相册资源ID
@property(nonatomic,strong) NSString *type; // 资源类型：1=视频
@property(nonatomic,strong) NSString *content;  //资源详细内容url
@property(nonatomic,strong) NSString *thumb;    //资源小图url
@property(nonatomic,strong) NSString *time; //资源时间戳
@property(nonatomic,strong) NSString *length;   //资源时长
@property(nonatomic,strong) NSString *from; //来源名称
@end
NS_ASSUME_NONNULL_END
