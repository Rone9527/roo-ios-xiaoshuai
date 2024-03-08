//
//  addrestViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol addresDelage <NSObject>

-(void)getAddrst:(NSString*)addrs;

@end

@interface addrestViewController : BaseViewController
@property(nonatomic,copy)NSString*iconname;
@property(nonatomic,copy)NSString*Chinaname;//链名字
@property(nonatomic,weak)id<addresDelage>delgate;

@end

NS_ASSUME_NONNULL_END
