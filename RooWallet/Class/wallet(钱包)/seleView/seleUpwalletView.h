//
//  seleUpwalletView.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getseleupBlock)(NSInteger indx,NSString*nameStr);
@interface seleUpwalletView : UIView
@property(nonatomic,copy)getseleupBlock getselectIndx;
- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
