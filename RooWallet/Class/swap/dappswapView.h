//
//  dappswapView.h
//  RooWallet
//
//  Created by mac on 2021/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getselswapBlock)(NSInteger indx, NSString*nameStr);
@interface dappswapView : UIView
- (instancetype)initWithFrame:(CGRect)frame  seleindx:(NSInteger)seleindx;
@property(nonatomic,copy)getselswapBlock getselectIndx;
- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
