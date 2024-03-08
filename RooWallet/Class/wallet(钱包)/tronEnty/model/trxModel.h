//
//  trxModel.h
//  RooWallet
//
//  Created by mac on 2021/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface trxModel : NSObject
@property(nonatomic,copy)NSString*KDfrozen_balance;//自己带宽的冻结
@property(nonatomic,copy)NSString*ENfrozen_balance;//自己能量的冻结

@property(nonatomic,copy)NSString*KDAcqfrozen_balance;//他人带宽的冻结
@property(nonatomic,copy)NSString*ENAcqfrozen_balance;//他人能量的冻结

@property(nonatomic,copy)NSString*isKDEnd;//是否到期
@property(nonatomic,copy)NSString*isENEnd;//是否到期

@property(nonatomic,copy)NSString*DKfre;//带宽fre
@property(nonatomic,copy)NSString*Enfre;//

@property(nonatomic,copy)NSString*DKall;//
@property(nonatomic,copy)NSString*DKky;//
@property(nonatomic,copy)NSString*DKused;//

@property(nonatomic,copy)NSString*Enall;//
@property(nonatomic,copy)NSString*Enky;//
@property(nonatomic,copy)NSString*ENused;//


@end

NS_ASSUME_NONNULL_END
