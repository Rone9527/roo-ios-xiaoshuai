//
//  DAppSearchView.h
//  RooWallet
//
//  Created by mac on 2021/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol dappsearchDelagate <NSObject>

-(void)getseleindex:(NSString*)str;

@end
@interface DAppSearchView : UIView
- (instancetype)initWithFrame:(CGRect)frame historyArray:(NSMutableArray *)historyArr;


@property(nonatomic,weak)id<dappsearchDelagate>delagate;

-(void)getsearData:(NSArray*)serarr tit:(NSString*)titstr;
-(void)sethisUIArr:(NSArray*)arr ;
@end

NS_ASSUME_NONNULL_END
