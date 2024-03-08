//
//  seleBiView.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getseleBIinxxBlock)(NSInteger indx,NSString*nameStr);
@interface seleBiView : UIView
- (instancetype)initWithFrame:(CGRect)frame  type:(NSInteger) typ Tokenarr:(NSArray*)dataArr;//0转账，1收款，2闪兑
@property(nonatomic,copy)getseleBIinxxBlock getselectIndx;
@property(nonatomic,copy)NSString*addrs;
- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
