//
//  walletnameViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//用户钱包修改昵称

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol wallxgDelagete <NSObject>

-(void)getWalletName:(NSString*)name;

@end
@interface walletnameViewController : BaseViewController
@property(nonatomic,copy)NSString*nameStr;
@property(nonatomic,strong)userModel*model;
@property(nonatomic,weak)id<wallxgDelagete>delagate;

@end

NS_ASSUME_NONNULL_END
