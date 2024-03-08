//
//  tranDetModel.h
//  RooWallet
//
//  Created by mac on 2021/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface tranDetModel : NSObject
@property(nonatomic,copy)NSString*amount;//数量
@property(nonatomic,copy)NSString*blockHash;
@property(nonatomic,copy)NSString*blockNum;
@property(nonatomic,copy)NSString*contractId;
@property(nonatomic,copy)NSString*convertGasUsed;//手续费
@property(nonatomic,copy)NSString*feeToken;//手续费币种
@property(nonatomic,copy)NSString*fromAddr;//转账地址
@property(nonatomic,copy)NSString*gasLimit;
@property(nonatomic,copy)NSString*gasPrice;
@property(nonatomic,copy)NSString*gasUsed;
@property(nonatomic,copy)NSString*statusType;//FAIL("FAIL", "交易失败"),CONFIRMED("CONFIRMED", "已确认"),PENDING("PENDING", "待处理"),IN_BLOCK("IN_BLOCK", "打包中"),
@property(nonatomic,copy)NSString*timeStamp;
@property(nonatomic,copy)NSString*toAddr;//接受账地址
@property(nonatomic,copy)NSString*token;
@property(nonatomic,copy)NSString*txId;
@property(nonatomic,assign)NSInteger type;//1转账，2收款
@property(nonatomic,assign)NSInteger staues;// //0失败 1，成功，2待处理，打包中

//-------------消息用到，其他没有--------
@property(nonatomic,assign)NSInteger isYdu;// //0没有读，1已读
@property(nonatomic,copy)NSString*chonacode;
@property(nonatomic,copy)NSString*index;
@end

NS_ASSUME_NONNULL_END
