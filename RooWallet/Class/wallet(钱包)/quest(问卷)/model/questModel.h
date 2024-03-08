//
//  questModel.h
//  RooWallet
//
//  Created by mac on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface optionModel : NSObject
@property(nonatomic,copy)NSString*option;

@end

@interface questModel : NSObject
@property(nonatomic,copy)NSArray*answer;
@property(nonatomic,copy)NSString*id;
@property(nonatomic,copy)NSArray<optionModel*>*options;
@property(nonatomic,copy)NSString*question;
@property(nonatomic,copy)NSString*type;

@end

NS_ASSUME_NONNULL_END
