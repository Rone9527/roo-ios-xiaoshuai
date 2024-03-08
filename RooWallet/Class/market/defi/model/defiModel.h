//
//  defiModel.h
//  RooWallet
//
//  Created by mac on 2021/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface defiModel : NSObject
@property(nonatomic,copy)NSString* ascription;
@property(nonatomic,copy)NSString* contractId;
@property(nonatomic,copy)NSString* identity;
@property(nonatomic,copy)NSString* logo;
@property(nonatomic,copy)NSString* pairName;
@property(nonatomic,copy)NSString* price;
@property(nonatomic,copy)NSString* priceUSD;
@property(nonatomic,copy)NSString* rateOfPrice;
@property(nonatomic,copy)NSString* volumeUSD;
@property(nonatomic,copy)NSString* chainCode;

@property(nonatomic,copy)NSString*isAdd;//1添加，0没有添加

@end

NS_ASSUME_NONNULL_END
