//
//  actShootView.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getIndxBlock)(NSInteger indx);
@interface actShootView : UIView
@property(nonatomic,copy)getIndxBlock getIndx;
- (instancetype)initWithFrame:(CGRect)frame  arr:(NSArray*)titArr tis:(NSString*)tishi;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
