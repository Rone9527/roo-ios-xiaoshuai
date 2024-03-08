//
//  defiSedView.h
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface defiSedView : UIView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)nameStr ;
-(void)getdatarr:(NSArray*)arr fl:(NSString*)flstr;

@end

NS_ASSUME_NONNULL_END
