//
//  defiSearTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/8/4.
//

#import <UIKit/UIKit.h>
@class  defiModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^getdesearBlock)(BOOL isSeld);
@interface defiSearTableViewCell : UITableViewCell
@property(nonatomic,strong)defiModel*model;
@property(nonatomic,copy)getdesearBlock block;
@end

NS_ASSUME_NONNULL_END
