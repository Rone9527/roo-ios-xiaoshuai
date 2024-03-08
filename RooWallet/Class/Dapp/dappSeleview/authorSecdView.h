//
//  authorSecdView.h
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import <UIKit/UIKit.h>
#import "dapptyModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^getauthorBlock)(NSString*gaspr,NSString*gaslomt,NSString*datasrt);
typedef void(^getquxBlock)(void);
@interface authorSecdView : UIView
- (instancetype)initWithFrame:(CGRect)frame modell:(dapptyModel*)model  dataArrr:(NSArray*)dataArr;
- (void)show;
- (void)hide;
@property(nonatomic,copy) getauthorBlock block;
@property(nonatomic,copy)getquxBlock quxblock;
@end

NS_ASSUME_NONNULL_END
