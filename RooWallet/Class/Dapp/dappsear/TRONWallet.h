//
//  TRONWallet.h
//  RooWallet
//
//  Created by mac on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRONWallet : NSObject

//创建钱包
+(void)TRON_createWithPwd:(NSString *)pwd
                    block:(void(^)(NSString *address,NSString *mnemonicPhrase,NSString *privateKey))block;


//助记词导入
+(void)TRON_inportMnemonics:(NSString *)mnemonics
                      pwd:(NSString *)pwd
                    block:(void(^)(NSString *address,NSString *mnemonicPhrase,NSString *privateKey,BOOL suc,HSWalletError error))block;

//私钥导入
+(void)TRON_importWalletForPrivateKey:(NSString *)privateKey
                                pwd:(NSString *)pwd
                              block:(void(^)(NSString *address,NSString *mnemonicPhrase,NSString *privateKey,BOOL suc,HSWalletError error))block;

+(NSData*)publicKeyForPrivateKey: (NSData*)privateKey;
+(NSData *)ownerAddress:(NSData*)publicKey;

@end

NS_ASSUME_NONNULL_END
