//
//  rightTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import <UIKit/UIKit.h>
@class btokensModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^getaddBtnBlock)(BOOL isSele);
typedef void(^getaddBtnBlockk)(void);
@interface rightTableViewCell : UITableViewCell
@property(nonatomic,copy)getaddBtnBlock getBtnBlock;
@property(nonatomic,copy)getaddBtnBlockk getBtnBlockk;
@property(nonatomic,strong)btokensModel*model;
@property(nonatomic,strong)UIImageView*adBtn;
@end

NS_ASSUME_NONNULL_END
