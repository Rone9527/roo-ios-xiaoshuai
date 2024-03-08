//
//  authorDetView.h
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getndetumBlock)(NSString*str);
@interface authorDetView : UIView
- (instancetype)initWithFrame:(CGRect)frame bore:(NSString*)browUrl addre:(NSString*)addrest;
- (void)show;
- (void)hide;
@property(nonatomic,copy)getndetumBlock block;
@end

NS_ASSUME_NONNULL_END
