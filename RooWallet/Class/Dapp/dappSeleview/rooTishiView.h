//
//  rooTishiView.h
//  RooWallet
//
//  Created by mac on 2021/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^gettshBlock)(void);
@interface rooTishiView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr;
@property(nonatomic,copy)gettshBlock  block;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
