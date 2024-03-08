//
//  authFreeView.h
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getfreeBlock)(NSString*gasPrice,NSString*gsalomt,NSString*free);
@interface authFreeView : UIView
- (instancetype)initWithFrame:(CGRect)frame code:(NSString*)codestr gslit:(NSString*)gaslimt chaid:(NSString*)chaid;
- (void)show;
- (void)hide;

@property(nonatomic,copy)getfreeBlock block;
@end

NS_ASSUME_NONNULL_END
