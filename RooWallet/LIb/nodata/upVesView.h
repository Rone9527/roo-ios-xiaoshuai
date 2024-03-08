//
//  upVesView.h
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface upVesView : UIView
- (instancetype)initWithFrame:(CGRect)frame  type:(NSString*)type remark:(NSString*)remark linkUrl:(NSString*)linkUrl vers:(NSString*)verstr;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
