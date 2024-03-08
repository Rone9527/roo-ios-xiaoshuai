//
//  qianingView.h
//  RooWallet
//
//  Created by mac on 2021/8/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getqmquxBlock)(void);

typedef void(^getqmqdBlock)(void);
@interface qianingView : UIView
- (instancetype)initWithFrame:(CGRect)frame  modell:(dapptyModel*)model  qmin:(NSString*)qmingStr ;
- (void)show;
- (void)hide;

@property(nonatomic,copy)getqmquxBlock quxblock;
@property(nonatomic,copy)getqmqdBlock qdblock;
@end

NS_ASSUME_NONNULL_END
