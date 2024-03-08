//
//  ratesModel.h
//  RooWallet
//
//  Created by mac on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ratesModel : NSObject
@property(nonatomic,copy)NSString*KRW;//韩元汇率
@property(nonatomic,copy)NSString*USD;//美元汇率
@property(nonatomic,copy)NSString*CNY;//人民币汇率
@end

NS_ASSUME_NONNULL_END
