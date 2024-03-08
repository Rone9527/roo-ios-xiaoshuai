//
//  h5ViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/24.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface h5ViewController : BaseViewController
@property(nonatomic,copy)NSString*url;
@property(nonatomic,assign)int type;//1 prse,2活动中心 ,3 banner进来,4 转账查询txid

@property(nonatomic,copy)NSString*addtrse;//活动中心 地址
@end

NS_ASSUME_NONNULL_END
