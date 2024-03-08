//
//  accsctTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "myAssectModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^getAcaddBtnBlock)(BOOL isSele);

@interface accsctTableViewCell : UITableViewCell
@property(nonatomic,copy)getAcaddBtnBlock getBtnBlock;

@property(nonatomic,strong)myAssectModel*model;
@property(nonatomic,strong)UIImageView*adBtn;
@end

NS_ASSUME_NONNULL_END
