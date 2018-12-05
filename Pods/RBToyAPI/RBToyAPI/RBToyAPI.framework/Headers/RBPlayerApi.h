//
//  RBPlayerApi.h
//  Pods
//
//  Created by baxiang on 2017/5/10.
//
//

#import <Foundation/Foundation.h>
#import "RBResourceModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface RBPlayerApi : NSObject

// 分类列表->专辑列表->歌曲列表

/**
 获取分类列表
 @param babyAge 宝宝年龄 未知设置0
 */
+(void)getCategoryList:(NSInteger)babyAge block:(nullable void (^)(RBCategoryList *list,NSError* _Nullable error)) block;

/**
 获取分类专辑列表
 @param cID 模块ID
 @param page 当前页码 起始值 1
 */
+ (void)getAlbumList:(NSString* )cID page:(NSInteger)page block:(nullable void (^)(RBAlbumList* _Nullable list,NSError* _Nullable error)) block;

/**
  获取专辑的资源列表

 @param aID aID 专辑id
 @param page 当前页码 起始值 1
 @param count 每页数据条数，默认为20
 */
+ (void)getResourceList:(NSString*)aID page:(NSInteger)page count:(NSInteger)count block:(nullable void (^)(RBResourceList* _Nullable list,NSError* _Nullable error))block;

/**
 播放当前的资源
 @param type 0 :播放当前资源 1上一首 2 下一首
 @param aID 专辑id
 @param rID 资源ID
 */
+ (void )playResource:(NSInteger)type aID:(NSString *)aID rID:(NSString *)rID block:(void (^)(BOOL isSuccess, NSError * _Nullable))block;

/**
 停止播放
 @param rID 资源的ID
 */
+ (void )stopResource:(NSString*)rID block:(void (^)(BOOL isSuccess, NSError* _Nullable error))block;

/**
 设置播放模式
 @param type 1单曲循环 2顺序播放 3随机播放 4全部循环
 */
+(void)setPlayMode:(NSInteger)type block:(void (^)(BOOL isSuccess, NSError * _Nullable))block;

/**
 获取播放状态
 */
+ (void )getPlayState:(void (^)(RBPlayInfoModel* _Nullable response, NSError* _Nullable error))block;

/**
 获取收藏的资源列表
 @param type 1 收藏的单个音频文件 2 收藏的专辑
 @param page 页数
 @param bindType 绑定类型,可传空字符串@""
 */
+ (void)getCollectionList:(NSInteger)type bindType:(NSString *)bindType page:(NSInteger)page block:(void (^)(RBCollectionList *list ,NSError * _Nullable))block;

/**
 添加资源收藏
 @param bindType 绑定类型,可传空字符串@""
 返回结果字典数组 key 是当前资源rID val 是当前资源的fID 收藏ID
 */
+ (void)addCollection:(NSArray<RBCollectionModel*>*)collectionModels bindType:(NSString *)bindType block:(void (^)(NSArray<NSDictionary*>*ridArray, NSError* _Nullable error))block;

/**
删除收藏
 @param fIDs 当前收藏的ID
 @param bindType 绑定类型,可传空字符串@""
 */
+ (void)deleteCollection:(NSArray<NSString*>*)fIDs bindType:(NSString *)bindType block:(void (^)(BOOL isSuccess, NSError* _Nullable error))block;

/**
 获取播放的历史
 @param rID 起始ID 首次请求 rID = 0
 */
+(void)getPlayHistoy:(NSString*)rID block:(void (^)(RBResHistoryList *list,NSError * error))block;

/**
  删除播放历史
 @param rIDs 资源的id
 */
+(void)deletePlayHistoy:(NSArray <NSString*>*)rIDs block:(void (^)(id _Nullable response,NSError* _Nullable error))block;

/**
  获取用户自定义的歌曲专辑
 */
+(void)getCustomAlbumList:(void (^)(RBAlbumList *list ,NSError * error))block;

/**
 增加歌曲到自定义的歌曲专辑
 @param aID 自定义的专辑ID
 @param rIDs 自定义的歌曲ID
 */
+(void)addCustomResource:(NSArray<NSString*>*)rIDs aID:(NSString *)aID block:(void (^)(BOOL isSuccess,NSError * error))block;

/**
 删除歌曲到自定义的歌曲专辑
 @param aID 自定义的专辑ID
 @param rIDs 自定义的歌曲ID
 */
+(void)delCustomResource:(NSArray<NSString*>*)rIDs aID:(NSString *)aID block:(void (^)(BOOL isSuccess,NSError* error))block;


/**
 资源搜索

 @param keyword 关键字
 @param page 页码，默认1
 @param type type 1：资源|2：歌单|3：全部，默认搜索资源
 */
+(void)searchResource:(NSString*)keyword page:(NSInteger)page type:(NSInteger)type block:(void (^)(RBSearchResultList *searchList,NSError * error))block;

/**
获取搜素推荐词
 */
+(void)getSearchKeyword:(void (^)(NSArray<NSString*> *resources,NSError * error))block;

/**
 重置设备默认专辑
 @param albumID 专辑ID
 */
+(void)resetCustomAlbum:(NSString*)albumID block:(void (^)(BOOL isSuccess,NSError * error))block;

@end
NS_ASSUME_NONNULL_END
