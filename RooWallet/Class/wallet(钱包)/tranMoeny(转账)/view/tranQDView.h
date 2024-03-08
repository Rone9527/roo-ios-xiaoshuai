//
//  tranQDView.h
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getranqdBlock)(void);
@interface tranQDView : UIView
@property(nonatomic,copy)getranqdBlock getselectIndx;
- (instancetype)initWithFrame:(CGRect)frame  arr:(NSArray*)dataArr comin:(NSString*)comin;
- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
