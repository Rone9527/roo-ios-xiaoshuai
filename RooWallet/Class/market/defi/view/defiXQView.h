//
//  defiDetView.h
//  RooWallet
//
//  Created by mac on 2021/8/7.
//

#import <UIKit/UIKit.h>

@class defiDetModel;
NS_ASSUME_NONNULL_BEGIN

@interface defiXQView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)nameStr;
-(void)getdata:(defiDetModel*)model;
@end

NS_ASSUME_NONNULL_END
