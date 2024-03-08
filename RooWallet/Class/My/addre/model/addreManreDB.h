//
//  addreManreDB.h
//  RooWallet
//
//  Created by mac on 2021/6/26.
//

#import <Foundation/Foundation.h>
#import "addreModel.h"
#import "FMDB.h"
//#import <fmdb/FMDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface addreManreDB : NSObject
+ (void)creatsHomeInfoDB;

+ (void)saveInfoModel:(addreModel *)model;

+ (void)updateUser:(addreModel *)model;

+ (void)removeInfoModel:(addreModel *)model;

+ (void)deleteAllUser;

+ (NSMutableArray *)getUserInfoArray;
@end

NS_ASSUME_NONNULL_END
