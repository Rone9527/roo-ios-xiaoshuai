//
//  SLTKeyboardView.h
//  RooWallet
//
//  Created by mac on 2021/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTKeyboardView : UIView
@property (nonatomic,copy) void(^itemActionBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
