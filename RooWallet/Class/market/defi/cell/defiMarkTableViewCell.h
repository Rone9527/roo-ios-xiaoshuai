//
//  defiMarkTableViewCell.h
//  RooWallet
//
//  Created by mac on 2021/8/3.
//

#import <UIKit/UIKit.h>
//#import "WaterRippleAndView.h"

NS_ASSUME_NONNULL_BEGIN
@class  defiModel;

@interface defiMarkTableViewCell : UITableViewCell
@property(nonatomic,strong)defiModel*model;
//@property (nonatomic, strong) WaterRippleAndView *BackView;
@end

NS_ASSUME_NONNULL_END
