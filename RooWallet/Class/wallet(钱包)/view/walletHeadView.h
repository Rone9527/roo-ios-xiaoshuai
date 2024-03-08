//
//  walletHeadView.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface walletHeadView : UIView
- (instancetype)initWithFrame:(CGRect)frame ;
@property(nonatomic,strong)userModel*usModel;
@property(nonatomic,copy)NSArray*allArr;//所有代币

@end

NS_ASSUME_NONNULL_END
