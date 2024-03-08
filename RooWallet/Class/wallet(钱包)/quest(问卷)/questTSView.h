//
//  questTSView.h
//  RooWallet
//
//  Created by mac on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getqsdtBlock)(void);
@interface questTSView : UIView

@property(nonatomic,copy)getqsdtBlock block;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
