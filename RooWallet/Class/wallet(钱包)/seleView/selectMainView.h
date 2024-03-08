//
//  selectMainView.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getseleIndxBlock)(NSInteger indx,NSString*nameStr);
@interface selectMainView : UIView
@property(nonatomic,copy)getseleIndxBlock getselectIndx;
- (instancetype)initWithFrame:(CGRect)frame  seleindx:(NSInteger)seleindx arr:(NSArray*)titArr;
@property(nonatomic,copy)NSString*type;//1地址选择

- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
