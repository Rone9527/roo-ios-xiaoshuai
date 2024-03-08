//
//  addtokenTisView.h
//  RooWallet
//
//  Created by mac on 2021/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getaddTokenBlock)(void);

@interface addtokenTisView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr name:(NSString*)namestr;
@property(nonatomic,copy)getaddTokenBlock   block;
- (void)show;

@end

NS_ASSUME_NONNULL_END
