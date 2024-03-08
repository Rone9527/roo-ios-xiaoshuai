//
//  frsitFWView.h
//  RooWallet
//
//  Created by mac on 2021/9/8.
//

#import <UIKit/UIKit.h>
#import "dapptyModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^getQDFselectBlock)(void);

@interface frsitFWView : UIView

- (instancetype)initWithFrame:(CGRect)frame modell:(dapptyModel*)model;
@property(nonatomic,copy)getQDFselectBlock block;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
