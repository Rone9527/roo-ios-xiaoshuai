//
//  collHeaView.h
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol collheadDelagte <NSObject>

-(void)getReqDataArr:(NSArray*)arr;

@end

typedef void(^getsedata)(NSArray*arr);

@interface collHeaView : UIView
-(void)getuodate;
@property(nonatomic,copy)getsedata getBlock;

@property(nonatomic,weak)id<collheadDelagte>delegate;
@end

NS_ASSUME_NONNULL_END
