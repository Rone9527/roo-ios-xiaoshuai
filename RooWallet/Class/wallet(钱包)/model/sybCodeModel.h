//
//  sybCodeModel.h
//  RooWallet
//
//  Created by mac on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface sybCodeModel : NSObject
@property(nonatomic,copy)NSString*chainCode;
@property(nonatomic,copy)NSString*availableBalance;
@property(nonatomic,copy)NSString*contractId;
@property(nonatomic,copy)NSString* address;
@end

NS_ASSUME_NONNULL_END
