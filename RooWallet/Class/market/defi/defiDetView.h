//
//  defiDetView.h
//  RooWallet
//
//  Created by mac on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface defiDetView : UIView
- (instancetype)initWithFrame:(CGRect)frame  type:(int)type;
-(void)updatermb;
-(void)getArrData;
-(void)qiuData;
@end

NS_ASSUME_NONNULL_END
