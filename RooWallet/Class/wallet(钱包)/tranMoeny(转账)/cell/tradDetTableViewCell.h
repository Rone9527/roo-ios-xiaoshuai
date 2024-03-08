//
//  tradDetTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import <UIKit/UIKit.h>
#import "LLGifImageView.h"
@class tranDetModel;
NS_ASSUME_NONNULL_BEGIN

@interface tradDetTableViewCell : UITableViewCell
@property(nonatomic,strong)LLGifImageView*ztimg;
@property(nonatomic,strong)tranDetModel*model;
@end

NS_ASSUME_NONNULL_END
