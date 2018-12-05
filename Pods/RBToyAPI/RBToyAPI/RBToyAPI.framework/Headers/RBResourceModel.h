//
//  RBResourceModel.h
//  Pods
//
//  Created by baxiang on 2017/5/9.
//
//

#import <Foundation/Foundation.h>

//播放信息模型
@interface RBPlayInfoModel : NSObject <NSCoding,NSCopying>
@property(nonatomic,strong) NSString *rID;//播放资源ID
@property(nonatomic,strong) NSString *status;//readying准备 start 开始 stop 停止 pause 暂停
@property(nonatomic,strong) NSString *type;// 点播来源
@property(nonatomic,strong) NSString *aID; // 专辑ID
@property(nonatomic,strong) NSString *title;// 资源名称
@property(nonatomic,strong) NSString *aName;// 专辑的ID
@property(nonatomic,strong) NSString *img_large;//图片
@property(nonatomic,assign) NSInteger mode; // 播放模式
@property(nonatomic,strong) NSString *ressrc;
@property(nonatomic,strong) NSString *fid;//收藏id
@property(nonatomic,assign) BOOL online;//设备是否在线
@property(nonatomic,assign) BOOL power;
@property(nonatomic,assign) BOOL power_supply;
@property(nonatomic,assign) BOOL fav_able;//是否可以收藏
@property(nonatomic,assign) NSInteger battery;//电量
@end

//专辑
@interface RBAlbumModel : NSObject
@property(nonatomic,strong) NSString *aID;// 专辑ID
@property(nonatomic,strong) NSString *img;// 专辑大图
@property(nonatomic,strong) NSString *thumb;// 专辑小图
@property(nonatomic,strong) NSString *title;// 专辑名称
@property(nonatomic,assign) NSInteger total;//专辑中资源总数
@property(nonatomic,strong) NSString *act;//专辑类别
@property(nonatomic,strong) NSString *content;//内容主要用于首页banner
@property(nonatomic,strong) NSString *fid;
@property (nonatomic, strong) NSString *templateId;

@end

//第二级 专辑列表
@interface RBAlbumList : NSObject
@property(nonatomic,assign) NSInteger total;// 分类下的专辑的总数量
@property(nonatomic,strong) NSArray<RBAlbumModel*> *albums;
@end

// 资源分类
@interface RBCategoryModel : NSObject
@property(nonatomic,strong) NSString *cID;//资源分类ID
@property(nonatomic,strong) NSString *title;// 分类名称
@property(nonatomic,strong) NSString *desc;// 分类描述
@property(nonatomic,strong) NSString *attr;// 分类属性
@property(nonatomic,strong) NSString *icon;// 分类图标
@property(nonatomic,strong) NSArray<RBAlbumModel*> *albums; // 分类推荐的四个专辑
@end

//第一级分类列表
@interface RBCategoryList : NSObject
@property(nonatomic,assign) NSInteger total;// 分类的总数量
@property(nonatomic,strong) NSArray<RBCategoryModel*> *categories;// 资源分类列表
@end

// 播放资源
@interface RBResourceModel : NSObject
@property(nonatomic,strong) NSString *rID;//资源ID
@property(nonatomic,strong) NSString *name;//名称
@property(nonatomic,strong) NSString *src;// 来源
@property(nonatomic,strong) NSString *size;// 大小
@property(nonatomic,strong) NSString *type;//类型
@property(nonatomic,strong) NSString *length;//音频时长（秒）
@property(nonatomic,strong) NSString *aID;//专辑ID
@property(nonatomic,strong) NSString *aName;//专辑名称
@property(nonatomic,strong) NSString *pic;//专辑大图
@property(nonatomic,strong) NSString *thumb;
@property(nonatomic,strong) NSString *fid;//收藏的资源ID 注意：0 表示当前资源未被收藏
@property(nonatomic,strong) NSString *rbk_url;//播放资源的url
@end

//第三级资源列表
@interface RBResourceList : NSObject
@property(nonatomic,strong) NSString *aID;//专辑ID
@property(nonatomic,assign) NSInteger count;//总数量
@property(nonatomic,strong) NSString* img;//专辑图片
@property(nonatomic,strong) NSString* title;//专辑名称;
@property(nonatomic,assign) NSInteger pages;//专辑页面数量;
@property(nonatomic,strong) NSString *favorites;//专辑是否收藏;
@property(nonatomic,strong) NSArray<RBResourceModel*> *list;
@end

// 收藏模型
@interface RBCollectionModel : NSObject
@property(nonatomic,strong) NSString *rID;// 资源ID  注意rID=0表示收藏专辑
@property(nonatomic,strong) NSString *aID;// 专辑ID
@property(nonatomic,strong) NSString *src;// 资源来源
@property(nonatomic,strong) NSString *fID;// 收藏的ID //取消收藏使用的fid
@property(nonatomic,strong) NSString *length;//资源的时长
@property(nonatomic,strong) NSString *rName;//资源的名称
@property(nonatomic,strong) NSString *pic;// 专辑的图片
@property(nonatomic,strong) NSString *aName;//专辑的名称
@end

// 收藏列表
@interface RBCollectionList : NSObject
@property(nonatomic,assign) NSInteger count;//总数量
@property(nonatomic,strong) NSArray<RBCollectionModel*> *list;
@end

//播放历史记录
@interface RBResHistoryModel : NSObject
@property(nonatomic,strong) NSString *hID;//历史ID
@property(nonatomic,strong) NSString *favorite_id;//收藏ID
@property(nonatomic,strong) NSString *act;//专辑类别
@property(nonatomic,strong) NSString *rID;//资源ID
@property(nonatomic,strong) NSString *name;//
@property(nonatomic,strong) NSString *current_length;// 当前播放的进度
@property(nonatomic,strong) NSString *time;//历史时间
@property(nonatomic,strong) NSString *length;// 资源长度
@property(nonatomic,strong) NSString *album_id;//专辑ID
@property(nonatomic,strong) NSString *album_img;//专辑图片
@property(nonatomic,strong) NSString *res_db;
@end

//播放历史列表
@interface RBResHistoryList : NSObject
@property(nonatomic,assign) BOOL is_more;// 是否存在下一页
@property(nonatomic,strong) NSArray<RBResHistoryModel*>*list;
@end
@interface RBSearchResultList : NSObject
@property(nonatomic,assign) NSInteger resourcesPage;
@property(nonatomic,assign) NSInteger resourcesTotal;
@property(nonatomic,assign) NSInteger albumsPage;
@property(nonatomic,assign) NSInteger albumsTotal;
@property(nonatomic,strong) NSString *resourcesKey;
@property(nonatomic,strong) NSArray<RBResourceModel*> *resources;
@property(nonatomic,strong) NSArray<RBAlbumModel*> *albums;
@end
