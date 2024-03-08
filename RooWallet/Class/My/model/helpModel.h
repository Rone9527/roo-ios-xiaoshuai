//
//  helpModel.h
//  RooWallet
//
//  Created by mac on 2021/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface helpDetModel : NSObject
@property(nonatomic,copy)NSString*code;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*remark;
@property(nonatomic,copy)NSString*value;
@end

@interface helpModel : NSObject
@property(nonatomic,copy)NSString*code;
@property(nonatomic,copy)NSString*createDate;
@property(nonatomic,copy)NSString*id;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSArray<helpDetModel*>*value;

@end

NS_ASSUME_NONNULL_END
