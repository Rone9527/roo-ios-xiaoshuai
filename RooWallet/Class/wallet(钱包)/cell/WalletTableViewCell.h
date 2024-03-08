//
//  WalletTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import <UIKit/UIKit.h>

@class symbolModel;

NS_ASSUME_NONNULL_BEGIN

@interface WalletTableViewCell : UITableViewCell
@property(nonatomic,assign)BOOL isYinc;
@property(nonatomic,strong)symbolModel*model;
@end

NS_ASSUME_NONNULL_END
