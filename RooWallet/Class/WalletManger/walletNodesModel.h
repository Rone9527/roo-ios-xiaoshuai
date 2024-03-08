//
//  walletNodesModel.h
//  RooWallet
//
//  Created by mac on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h" //添加该头文件,本类就具有了存储功能.
NS_ASSUME_NONNULL_BEGIN

@interface walletNodesModel : NSObject
@property(nonatomic,copy)NSString*browserUrl;
@property(nonatomic,copy)NSString*chainCode;
@property(nonatomic,copy)NSString* network;
@property(nonatomic,copy)NSString*rpcUrl;
@property(nonatomic,copy)NSString*txBrowserUrl;
@property(nonatomic,copy)NSString*sort;
@end

NS_ASSUME_NONNULL_END
