//
//  jysmarkModel.h
//  RooWallet
//
//  Created by mac on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface jysmarkModel : NSObject
@property(nonatomic,copy)NSString*coinCode;//
@property(nonatomic,copy)NSString*logo;//
@property(nonatomic,copy)NSString*name;//
@property(nonatomic,copy)NSString*nameZh;//
@property(nonatomic,copy)NSString*price;//
@property(nonatomic,copy)NSString*symbolPair;
@property(nonatomic,copy)NSString*vol;
@property(nonatomic,copy)NSString*pair1;
@property(nonatomic,copy)NSString*pair2;

@end

NS_ASSUME_NONNULL_END
