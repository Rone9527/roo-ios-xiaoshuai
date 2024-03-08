//
//  defiDetXqViewController.h
//  RooWallet
//
//  Created by mac on 2021/8/7.
//

#import "BaseViewController.h"
#import "defiModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^getzxeBlock)(NSString*isSed);
@interface defiDetXqViewController : BaseViewController
@property(nonatomic,strong)defiModel*model;
@property(nonatomic,copy)getzxeBlock block;

@end

NS_ASSUME_NONNULL_END
