//
//  tradetModel.h
//  RooWallet
//
//  Created by mac on 2021/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface tradetGFModel : NSObject
@property(nonatomic,copy)NSString*code;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*url;
@end

@interface tradetModel : NSObject
@property(nonatomic,copy)NSString*chainCode;
@property(nonatomic,copy)NSString*contractId;
@property(nonatomic,copy)NSString*detail;
@property(nonatomic,copy)NSString*symbol;
@property(nonatomic,copy)NSString*totalSupply;
@property(nonatomic,copy)NSArray<tradetGFModel*>*resources;



@end

NS_ASSUME_NONNULL_END
