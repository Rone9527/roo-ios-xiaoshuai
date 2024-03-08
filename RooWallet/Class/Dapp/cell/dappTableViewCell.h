//
//  dappTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class dapptyModel;
@interface dappTableViewCell : UITableViewCell
@property(nonatomic,strong)dapptyModel*model;
@property(nonatomic,assign)BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
