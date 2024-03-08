//
//  defiJYModel.h
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface defiJYModel : NSObject
@property(nonatomic,copy)NSString* timestamp;
@property(nonatomic,copy)NSString*token0Amount;
@property(nonatomic,copy)NSString* token0Symbol;
@property(nonatomic,copy)NSString* token1Amount;
@property(nonatomic,copy)NSString* token1Symbol;
@property(nonatomic,copy)NSString* txid;
@property(nonatomic,copy)NSString* type;//buy(买入)、sell(卖出)、mint(增加流动性)、burn(减少流动性

@end

NS_ASSUME_NONNULL_END
