//
//  coinsModel.h
//  RooWallet
//
//  Created by mac on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface coinsModel : NSObject
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*symbol;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,copy)NSString*decimals;


@end

NS_ASSUME_NONNULL_END
