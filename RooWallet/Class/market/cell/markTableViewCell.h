//
//  markTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import <UIKit/UIKit.h>
@class marktModel;
NS_ASSUME_NONNULL_BEGIN

@interface markTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel*tsLab;
@property(nonatomic,strong)marktModel*model;
@end

NS_ASSUME_NONNULL_END
