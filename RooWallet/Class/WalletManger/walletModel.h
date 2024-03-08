//
//  walletModel.h
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h" //添加该头文件,本类就具有了存储功能.
NS_ASSUME_NONNULL_BEGIN

@interface walletModel : NSObject

@property(nonatomic,copy) NSString * ID;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *addres;//地址
@property(nonatomic,copy) NSString *password;//加密主私钥
@property(nonatomic,copy) NSString *keyStore;//加密文件
@property(nonatomic,copy) NSString *mnemonics;//加密助记词
@property(nonatomic,copy) NSString *belongClass;//属于那个钱包



/**
 *  一个钱包可以有多个币种
 */
@property(nonatomic,copy) NSArray *coinArray;//代币数据

@property(nonatomic,copy) NSArray *nodesArray;//节点数据
@end

NS_ASSUME_NONNULL_END
