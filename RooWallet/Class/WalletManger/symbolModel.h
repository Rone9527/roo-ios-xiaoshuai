//
//  symbolModel.h
//  RooWallet
//
//  Created by mac on 2021/6/26.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h" //添加该头文件,本类就具有了存储功能.
NS_ASSUME_NONNULL_BEGIN

@interface symbolModel : NSObject

@property(nonatomic,copy) NSString *addres;//钱包地址
@property(nonatomic,copy) NSString * chainCode;//主链
@property(nonatomic,copy) NSString *symbol;//代币名字
@property(nonatomic,copy) NSString *icon;//
@property(nonatomic,copy) NSString *contractId;//
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *decimals;
@property(nonatomic,copy) NSString *pricdecimals;//价格位数
@property(nonatomic,copy) NSString *isUp;//是不是置顶 0不置顶，1置顶
@property(nonatomic,copy) NSString*morb;//是不是默认
@property(nonatomic,copy) NSString*numRest;//当前余额
@property(nonatomic,copy) NSString*isCode;
@property(nonatomic,copy)NSArray*tradArr;//本地转账数据;


@property(nonatomic,copy)NSString*rpcUrl;//节点;
@property(nonatomic,copy)NSString*browserUrl;
@property(nonatomic,assign)NSInteger creadCount;//创建ID
@property(nonatomic,copy) NSString* isMarket;// 0没有，1有 是不是有行情

@end

NS_ASSUME_NONNULL_END
