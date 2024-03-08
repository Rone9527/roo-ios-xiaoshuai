//
//  authsmView.h
//  RooWallet
//
//  Created by mac on 2021/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getsmBlock)(void);
@interface authsmView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr;
@property(nonatomic,copy)getsmBlock numblock;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
