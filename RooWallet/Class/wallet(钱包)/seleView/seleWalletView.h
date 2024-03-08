//
//  seleWalletView.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getseleWalletBlock)(NSInteger indx,NSString*nameStr);
@interface seleWalletView : UIView
@property(nonatomic,copy)getseleWalletBlock getselecwalletBlock;
- (instancetype)initWithFrame:(CGRect)frame  seleindx:(NSInteger)seleindx;
- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
