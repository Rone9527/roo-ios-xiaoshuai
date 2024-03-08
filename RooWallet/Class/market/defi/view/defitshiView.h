//
//  defitshiView.h
//  RooWallet
//
//  Created by mac on 2021/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface defitshiView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr nr:(NSString*)nstr;

- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
