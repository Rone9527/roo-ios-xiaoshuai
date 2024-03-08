//
//  conduModel.h
//  RooWallet
//
//  Created by mac on 2021/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface conduModel : NSObject
@property(nonatomic,copy)NSString*chainCode;//主链
@property(nonatomic,copy)NSString*link;//
@property(nonatomic,copy)NSString*logo;//
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*rateOfReturn;//涨跌幅
@property(nonatomic,copy)NSString*tag;
@property(nonatomic,copy)NSString*ascription;

@end

NS_ASSUME_NONNULL_END
