//
//  authNumView.h
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getnumBlock)(NSString*str);
@interface authNumView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr;
@property(nonatomic,copy)getnumBlock numblock;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
