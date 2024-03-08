//
//  trxdkView.h
//  RooWallet
//
//  Created by mac on 2021/9/3.
//

#import <UIKit/UIKit.h>
#import "trxModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface trxdkView : UIView
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
@property(nonatomic,strong)trxModel*model;
@end

NS_ASSUME_NONNULL_END
