//
//  defiDetModel.h
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface defiDetModel : NSObject
@property(nonatomic,copy)NSString* ascription;
@property(nonatomic,copy)NSString*ascriptionIcon;
@property(nonatomic,copy)NSString* baseLogo;
@property(nonatomic,copy)NSString* identity;
@property(nonatomic,copy)NSString* createTimestamp;
@property(nonatomic,copy)NSString* dinitPrice;
@property(nonatomic,copy)NSString* rateOfPrice;
@property(nonatomic,copy)NSString* rateOfReserveUSD;
@property(nonatomic,copy)NSString* rateOfTxCount24;
@property(nonatomic,copy)NSString* rateOfVolume24;
@property(nonatomic,copy)NSString* chainCode;
@property(nonatomic,copy)NSString* reserveUSD;
@property(nonatomic,copy)NSString* token0Id;
@property(nonatomic,copy)NSString* token0Price;
@property(nonatomic,copy)NSString* token0PriceUSD;
@property(nonatomic,copy)NSString* token0Reserve;
@property(nonatomic,copy)NSString* token0Symbol;
@property(nonatomic,copy)NSString* token1Id;
@property(nonatomic,copy)NSString* token1Reserve;
@property(nonatomic,copy)NSString* token1Symbol;
@property(nonatomic,copy)NSString* txCount;
@property(nonatomic,copy)NSString* txCount24;
@property(nonatomic,copy)NSString* url;
@property(nonatomic,copy)NSString* volume24;
@property(nonatomic,copy)NSString*holders;
@property(nonatomic,copy)NSString*logo;
@end

NS_ASSUME_NONNULL_END
