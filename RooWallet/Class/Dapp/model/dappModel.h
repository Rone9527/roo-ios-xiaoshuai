//
//  dappModel.h
//  RooWallet
//
//  Created by mac on 2021/7/20.
//

#import <Foundation/Foundation.h>
#import "dapptyModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface dappxqModel : NSObject
@property(nonatomic,copy)NSArray<dapptyModel*>*list;
@property(nonatomic,copy)NSString*name;
@end

@interface dappModel : NSObject
@property(nonatomic,copy)NSArray<dappxqModel*>*list;
@property(nonatomic,copy)NSString*name;


@end

NS_ASSUME_NONNULL_END
