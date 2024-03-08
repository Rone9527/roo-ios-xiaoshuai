//
//  dapptyModel.h
//  RooWallet
//
//  Created by mac on 2021/7/8.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h" //添加该头文件,本类就具有了存储功能.
NS_ASSUME_NONNULL_BEGIN

@interface dapptyModel : NSObject
@property(nonatomic,copy)NSString* chain;
@property(nonatomic,copy)NSString* display;
@property(nonatomic,copy)NSString* hots;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,copy)NSString* links;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* sort;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString*discription;
@property(nonatomic,copy)NSString*officialEmail;
@property(nonatomic,copy)NSString*telegram;
@property(nonatomic,copy)NSString*twitter;
@property(nonatomic,copy)NSString*multis;//0单链，1多链
@property(nonatomic,copy)NSString*identity;//id

@property(nonatomic,copy)NSString* idstr;//主链id
@property(nonatomic,copy)NSString* addres;//钱包地址
@property(nonatomic,copy)NSString* rpcurl;//rpc
@property(nonatomic,copy)NSString* browserUrl;//浏览器
@property(nonatomic,copy)NSString* prived;//私钥

@property(nonatomic,assign)NSInteger num;//排序
@property(nonatomic,assign)NSInteger isColl;//1表示收藏
@property(nonatomic,assign)NSInteger iszjll;//1表示已经最近
@property(nonatomic,copy)NSString* pxnum;//1表示第一

@property(nonatomic,copy)NSString* tyy;//0表示来自搜索 ,1 理财进来


@end

NS_ASSUME_NONNULL_END
