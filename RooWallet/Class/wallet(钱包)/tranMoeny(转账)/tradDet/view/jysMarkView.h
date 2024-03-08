//
//  jysMarkView.h
//  RooWallet
//
//  Created by mac on 2021/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface jysMarkView : UIView
- (instancetype)initWithFrame:(CGRect)frame baseAsset:(NSString*)namestr;
- (instancetype)initWithFrame:(CGRect)frame defi:(NSString*)ascription conid:(NSString*)conid;
@end

NS_ASSUME_NONNULL_END
