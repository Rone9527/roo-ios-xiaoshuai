//
//  tranMoenyViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface tranMoenyViewController : BaseViewController
//@property(nonatomic,strong)userModel*usmdel;
@property(nonatomic,assign)int type;//1表示从交易记录进来
@property(nonatomic,strong)symbolModel*symodel;
@property(nonatomic,copy)NSString*addrest;//扫码地址

@end

NS_ASSUME_NONNULL_END
