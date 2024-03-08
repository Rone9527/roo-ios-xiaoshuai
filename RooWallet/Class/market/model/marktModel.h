//
//  marktModel.h
//  RooWallet
//
//  Created by mac on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface marktModel : NSObject
@property(nonatomic,copy)NSString*baseAsset;//m名称
@property(nonatomic,copy)NSString*decimals;//w位数
@property(nonatomic,copy)NSString*isShow;//是否展示
@property(nonatomic,copy)NSString*price;//价格
@property(nonatomic,copy)NSString*priceChangePercent;//涨跌幅
@property(nonatomic,copy)NSString*quoteAsset;
@property(nonatomic,copy)NSString*symbol;
@property(nonatomic,copy)NSString*volume;
@property(nonatomic,copy)NSString*marketCapUsd;//市值
@end

NS_ASSUME_NONNULL_END
