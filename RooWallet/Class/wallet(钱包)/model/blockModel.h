//
//  blockModel.h
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import <Foundation/Foundation.h>
#import "walletNodesModel.h"

NS_ASSUME_NONNULL_BEGIN
//@interface bnodesModel : NSObject
//@property(nonatomic,copy)NSString*browserUrl;
//@property(nonatomic,copy)NSString*chainCode;
//@property(nonatomic,copy)NSString* network;
//@property(nonatomic,copy)NSString*rpcUrl;
//@property(nonatomic,copy)NSString*sort;
//
//@end

@interface btokensModel : NSObject

@property(nonatomic,copy)NSString*chainCode;
@property(nonatomic,copy)NSString*chainCodenameEn;
@property(nonatomic,copy)NSString*contractId;
@property(nonatomic,copy)NSString* decimals;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,copy)NSString*id;
@property(nonatomic,copy)NSString*isRecommend;
@property(nonatomic,copy)NSString*isScan;
@property(nonatomic,copy)NSString*isSearch;
@property(nonatomic,copy)NSString*nameEn;
@property(nonatomic,copy)NSString*sort;
@property(nonatomic,copy)NSString*morb;//主币选择
@property(nonatomic,copy)NSString*symbol;
@property(nonatomic,copy)NSString*isCode;//是不是主币
@property(nonatomic,copy)NSString*name;//
@property(nonatomic,assign)BOOL isSeled;
@property(nonatomic,copy) NSString* isMarket;//0没有，1有 是不是有行情

@end


@interface blockModel : NSObject
@property(nonatomic,copy)NSString*code;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*nameEn;
@property(nonatomic,strong)NSMutableArray<btokensModel*>*tokens;
@property(nonatomic,strong)NSMutableArray<walletNodesModel*>*nodes;
@end

NS_ASSUME_NONNULL_END
