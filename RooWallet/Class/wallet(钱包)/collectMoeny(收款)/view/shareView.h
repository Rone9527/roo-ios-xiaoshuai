//
//  shareView.h
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shareView : UIView
- (instancetype)initWithFrame:(CGRect)frame  shaimg:(UIImage*)img;
- (void)show;
- (void)hide;
-(void)delView;
@end

NS_ASSUME_NONNULL_END
