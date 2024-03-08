//
//  neswModel.h
//  RooWallet
//
//  Created by mac on 2021/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface neswModel : NSObject

@property(nonatomic,copy)NSString*contentUrl;
@property(nonatomic,copy)NSString*id;
@property(nonatomic,copy)NSString*msgContent;
@property(nonatomic,copy)NSString*msgTitle;
@property(nonatomic,assign)NSInteger isYdu;// //0没有读，1已读
@property(nonatomic,copy)NSString*publishTime;


@end

NS_ASSUME_NONNULL_END
