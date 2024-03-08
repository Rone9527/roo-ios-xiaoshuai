//
//  BaseViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property(nonatomic,strong)UIView *navHeadView;
@property(nonatomic,strong)UILabel *baseLab;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIView *lineView;

- (void)leftBarBtnClicked;
- (void)rightBarBtnClicked;
@end

NS_ASSUME_NONNULL_END
