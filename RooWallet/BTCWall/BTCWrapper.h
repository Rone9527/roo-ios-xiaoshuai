//
//  BTCWrapper.h
//  BTC_demo
//
//  Created by fk on 2018/9/27.
//  Copyright © 2018年 fk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCMnemonic.h"
#import "CoreBitcoin.h"



@interface BTCWrapper : NSObject


//创建
+(void)createAccountWithBlock:(void(^)(NSString *private,NSString *address,NSString *words))block;

//导入
+(void)importPrivateKey:(NSString *)privateKey
                success:(void(^)(NSString *private,NSString *address))successblock
                  error:(void(^)(void))errorblock;

//助记词导入
+(void)importMnemonicPassphrase:(NSString *)phrase
                      WithBlock:(void(^)(NSString *private,NSString *address,NSString *words))block;



+(BTCMnemonic *)generateMnemonicPassphrase:(NSString *)phrase withPassword:(NSString *)password;



+(NSString *)getPassphraseByMnemonic:(BTCMnemonic *)mnemonic;


//查询余额
+(void)getBalanceWithAddress:(NSString *)address
                       block:(void(^)(NSDictionary *dict,BOOL suc))block;

////查询交易记录
+(void)getTxlistWithAddress:(NSString *)address
                   withPage:(NSInteger)page
                      block:(void(^)(NSArray *array,BOOL suc))block;



//交易
+(void)sendToAddress:(NSString *)toAddress money:(NSString *)money fromAddress:(NSString *)fromAddress privateKey:(NSString *)privateKey fee:(BTCAmount)fee block:(void(^)(NSString *hashStr,BOOL suc))block;



@end

