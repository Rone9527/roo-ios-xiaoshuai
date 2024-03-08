//
//  TraGasmodel.h
//  RooWallet
//
//  Created by mac on 2021/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TraGasmodel : NSObject
@property(nonatomic,copy)NSString*safeGasPrice;
@property(nonatomic,copy)NSString*fastGasPrice;
@property(nonatomic,copy)NSString*proposeGasPrice;
@property(nonatomic,copy)NSString*gasLimit;
@end

NS_ASSUME_NONNULL_END
