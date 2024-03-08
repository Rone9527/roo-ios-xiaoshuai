//
//  trxauthView.h
//  RooWallet
//
//  Created by mac on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getTrxauthorBlock)(void);
typedef void(^getTrxquxBlock)(void);
@interface trxauthView : UIView
- (instancetype)initWithFrame:(CGRect)frame modell:(dapptyModel*)model  arr:(NSArray*)dataArr ;
- (void)show;
- (void)hide;
@property(nonatomic,copy) getTrxauthorBlock block;
@property(nonatomic,copy)getTrxquxBlock quxblock;
@end

NS_ASSUME_NONNULL_END
