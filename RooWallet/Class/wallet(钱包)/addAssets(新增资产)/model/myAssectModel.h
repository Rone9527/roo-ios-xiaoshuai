//
//  myAssectModel.h
//  RooWallet
//
//  Created by mac on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface myAsseTokenModel : NSObject
@property(nonatomic,copy)NSString*contractId;
@property(nonatomic,copy)NSString*decimals;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*symbol;
@property(nonatomic,copy)NSString*totalSupply;
@property(nonatomic,copy) NSString* isMarket;//0没有，1有 是不是有行情
@property(nonatomic,copy)NSString*isRead;
@end

@interface myAssectModel : NSObject
@property(nonatomic,copy)NSString*address;
@property(nonatomic,copy)NSString*availableBalance;
@property(nonatomic,copy)NSString*chainCode;
@property(nonatomic,copy)NSString*contractId;
@property(nonatomic,copy)NSString*symbol;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,strong)myAsseTokenModel*tokenVO;

@property(nonatomic,assign)NSInteger isTop;//是否在上面显示 1 不显示
@property(nonatomic,assign)BOOL isSeled;

@end

NS_ASSUME_NONNULL_END
