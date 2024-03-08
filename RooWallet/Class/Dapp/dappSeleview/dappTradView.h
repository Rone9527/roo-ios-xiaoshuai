//
//  dappTradView.h
//  RooWallet
//
//  Created by mac on 2021/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^getDappTradQDBlock)(NSString*gaspr,NSString*gaslomt);
typedef void(^getdappquxBlock)(void);
@interface dappTradView : UIView
@property(nonatomic,copy)getDappTradQDBlock getselectIndx;
- (instancetype)initWithFrame:(CGRect)frame  arr:(NSArray*)dataArr comin:(NSString*)comin;

- (void)show;
- (void)hide;
-(void)delView;

@property(nonatomic,copy)getdappquxBlock qublock;
@end

NS_ASSUME_NONNULL_END
