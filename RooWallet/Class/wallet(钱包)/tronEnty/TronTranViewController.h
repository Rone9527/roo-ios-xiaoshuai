//
//  TronTranViewController.h
//  RooWallet
//
//  Created by mac on 2021/9/7.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TronTranViewController : BaseViewController
@property(nonatomic,assign)int type;//1表示从交易记录进来
@property(nonatomic,strong)symbolModel*symodel;
@property(nonatomic,copy)NSString*addrest;//扫码地址
@end

NS_ASSUME_NONNULL_END
