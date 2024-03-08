//
//  trxScouModel.h
//  RooWallet
//
//  Created by mac on 2021/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface trxScouModel : NSObject
@property(nonatomic,copy)NSString*EnergyLimit;//质押获取的总能量

@property(nonatomic,copy)NSString*freeNetLimit;//免费带宽总量
@property(nonatomic,copy)NSString*freeNetUsed;//已使用的免费带宽
@property(nonatomic,copy)NSString*EnergyUsed;//已使用的免费能量
@property(nonatomic,copy)NSString*NetLimit;//质押获得的带宽总量

@property(nonatomic,copy)NSString*TotalEnergyLimit;//全网通过质押获取的能量总量

@property(nonatomic,copy)NSString*TotalEnergyWeight;//全网用于获取能量的质押TRX总量

@property(nonatomic,copy)NSString*TotalNetLimit;//全网通过质押获取的带宽总量

@property(nonatomic,copy)NSString*TotalNetWeight;//全网用于获取带宽的质押TRX总量

@property(nonatomic,copy)NSString*tronPowerLimit;//拥有的投票权


@end

NS_ASSUME_NONNULL_END
