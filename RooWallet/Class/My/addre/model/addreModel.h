//
//  addreModel.h
//  RooWallet
//
//  Created by mac on 2021/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface addreModel : NSObject
@property(nonatomic,copy)NSString*ChinaCode;//主链名字
@property(nonatomic,copy)NSString*name;//名字
@property(nonatomic,copy)NSString*addreStr;//地址
@property(nonatomic,copy)NSString*subStr;//描述
@property(nonatomic,copy)NSString*creatimer;//c创建时间
@end

NS_ASSUME_NONNULL_END
