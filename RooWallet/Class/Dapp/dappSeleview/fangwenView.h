//
//  fangwenView.h
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import <UIKit/UIKit.h>
#import "dapptyModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^getQDselectBlock)(BOOL isselet);
@interface fangwenView : UIView
- (instancetype)initWithFrame:(CGRect)frame modell:(dapptyModel*)model;
@property(nonatomic,copy)getQDselectBlock block;

- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
