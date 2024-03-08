//
//  DetTradViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "BaseViewController.h"
@class tranDetModel;
NS_ASSUME_NONNULL_BEGIN

@interface DetTradViewController : BaseViewController
@property(nonatomic,copy)NSString*chonacode;
@property(nonatomic,strong)tranDetModel*model;
@end

NS_ASSUME_NONNULL_END
