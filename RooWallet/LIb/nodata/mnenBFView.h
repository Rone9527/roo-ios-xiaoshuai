//
//  mnenBFView.h
//  RooWallet
//
//  Created by mac on 2021/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getmnebBlock)(void);
typedef void(^getmnebcanBlock)(void);
@interface mnenBFView : UIView
@property(nonatomic,copy)getmnebBlock block;
@property(nonatomic,copy)getmnebcanBlock qublock;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
