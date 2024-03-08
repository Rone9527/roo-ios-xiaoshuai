//
//  wallDetViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//我的钱包详情

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol wallDetDelagete <NSObject>

-(void)getwallDetWalletName:(NSString*)name;

@end
@interface wallDetViewController : BaseViewController
@property(nonatomic,copy)NSString*nameStr;
@property(nonatomic,strong)userModel*model;

@property(nonatomic,weak)id<wallDetDelagete>delagate;
@end

NS_ASSUME_NONNULL_END
