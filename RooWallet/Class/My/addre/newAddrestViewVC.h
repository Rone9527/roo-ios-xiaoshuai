//
//  newAddrestViewVC.h
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "BaseViewController.h"

@class addreModel;
NS_ASSUME_NONNULL_BEGIN

@interface newAddrestViewVC : BaseViewController
@property(nonatomic,assign)int type; //1编辑，其他添加
@property(nonatomic,strong)addreModel*addModel;


@end

NS_ASSUME_NONNULL_END
