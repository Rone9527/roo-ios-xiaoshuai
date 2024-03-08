//
//  serTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import <UIKit/UIKit.h>
@class btokensModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^getserBtnBlock)(BOOL isSele);
@interface serTableViewCell : UITableViewCell
@property(nonatomic,copy)getserBtnBlock getBtnBlock;
@property(nonatomic,strong)btokensModel*model;
@property(nonatomic,strong)UIImageView*adBtn;
@end

NS_ASSUME_NONNULL_END
