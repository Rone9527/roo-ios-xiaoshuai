//
//  TRONWallet.m
//  RooWallet
//
//  Created by mac on 2021/8/30.
//

#import "TRONWallet.h"
#import <ethers/ethers.h>
#import "ecdsa.h"
#include "secp256k1.h"

@implementation TRONWallet
+(void)TRON_createWithPwd:(NSString *)pwd
                    block:(void(^)(NSString *address,NSString *mnemonicPhrase,NSString *privateKey))block{
    Account *account = [Account randomMnemonicAccount];
    
//    NSLog(@"a---%@ b--%@ c--%@",account.address,account.privateKey,account.mnemonicPhrase);
    
    
    [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
//        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
//        //地址
//        NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
        //私钥
        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        
        privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];
        
        NSData*addre=[self ownerAddress:account.privateKey];
        NSString *addressStr = BTCBase58CheckStringWithData(addre);
        
        //助记词account.mnemonicPhrase
        //助记keyStore 就是json字符串
        
        block(addressStr,account.mnemonicPhrase,privateKeyStr);
    }];
}

+(void)TRON_inportMnemonics:(NSString *)mnemonics
                      pwd:(NSString *)pwd
                      block:(void(^)(NSString *address,NSString *mnemonicPhrase,NSString *privateKey,BOOL suc,HSWalletError error))block{
    
    if (mnemonics.length < 1) {
        block(@"",@"",@"",NO,0);
        return;
    }
  
    NSArray *arrayMnemonics = [mnemonics componentsSeparatedByString:@" "];
    if (arrayMnemonics.count != 12) {
        block(@"",@"",@"",NO,HSWalletErrorMnemonicsCount);
        return;
    }
    for (NSString *m in arrayMnemonics) {
        if (![Account isValidMnemonicWord:m]) {
            NSString *msg = [NSString stringWithFormat:@"助记词 %@ 有误", m];
            NSLog(@"%@",msg);
            block(@"",@"",@"",NO,HSWalletErrorMnemonicsValidWord);
            return;
        }
    }
    if (![Account isValidMnemonicPhrase:mnemonics]) {
        block(@"",@"",@"",NO,HSWalletErrorMnemonicsValidPhrase);
        return;
    }
    //1 创建
    Account *account = [Account accountWithMnemonicPhrase:mnemonics];
    
   
    
    if (pwd == nil || [pwd isEqualToString:@""]) {
        block(account.address.checksumAddress,account.mnemonicPhrase,@"没有私钥，请传入密码即可生成私钥",YES,HSWalletImportMnemonicsSuc);
    }else{
        
        //2 生成keystore
//        [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
//            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:&err];
            //3 获取地址 （account.address也可以）
//            NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
            //4 获取私钥
//            NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
            
            
            NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
            
            privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];
        
//            NSData*addre=[self ownerAddress:account.privateKey];
            NSData*pub=[self publicKeyForPrivateKey:account.privateKey];
            NSData*addre=[self ownerAddress:pub];
            //TCBase58CheckStringWithData(dat)
            NSString *addressStr = BTCBase58StringWithData(addre);//BTCBase58CheckStringWithData(addre);
//            BTCDataFromBase58Check
        
            
            //5 获取助记词 account.mnemonicPhrase
            //6 获取keyStore 就是json字符串
            //7 block 回调
            block(addressStr,account.mnemonicPhrase,privateKeyStr,YES,HSWalletImportMnemonicsSuc);
            
//        }];
    }
    
}

+(void)TRON_importWalletForPrivateKey:(NSString *)privateKey
                                pwd:(NSString *)pwd
                              block:(void(^)(NSString *address,NSString *mnemonicPhrase,NSString *privateKey,BOOL suc,HSWalletError error))block{
   
    if (privateKey.length < 1) {
        block(@"",@"",@"",NO,HSWalletErrorPrivateKeyLength);
        return;
    }
    if (pwd.length < 1) {
        block(@"",@"",@"",NO,HSWalletErrorPwdLength);
        return;
    }
    //1 解密私钥
  
    Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[privateKey hasPrefix:@"0x"]?privateKey:[@"0x" stringByAppendingString:privateKey]]];
    
//    NSLog(@"s--%@  b--%@  c--%@ d-%@",account.address,account.privateKey,account.mnemonicData,account.mnemonicPhrase);
    
    //2 生成keystore
//    [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
//        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:nil];
//        //3 获取地址 （account.address也可以）
//        NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
//        //4 获取私钥
//        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        
  
        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        

        privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];
      
        NSData*pub=[self publicKeyForPrivateKey:account.privateKey];
    
        NSData*addre=[self ownerAddress:pub];
        NSString *addressStr = BTCBase58StringWithData(addre);//BTCBase58CheckStringWithData(addre);
        
        
        //5 获取助记词 account.mnemonicPhrase
        //6 获取keyStore 就是json字符串
        //7 block 回调
        block(addressStr,account.mnemonicPhrase,privateKeyStr,YES,HSWalletImportPrivateKeySuc);
//    }];
    
}
+(NSData*)publicKeyForPrivateKey: (NSData*)privateKey {


    
    SecureData * priKeyData = [SecureData secureDataWithData:privateKey];
   
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    
    ecdsa_get_public_key65(&secp256k1, priKeyData.bytes, publicKey.mutableBytes);
  
    return [publicKey.data subdataWithRange:NSMakeRange(1, 64)];

}
+(NSData *)ownerAddress:(NSData*)publicKey
{
    
    const uint8_t *pubBytes = (const uint8_t *)[publicKey bytes];
    if (publicKey.length == 65) {
        //remove prefix
        NSData *pubdata = [publicKey subdataWithRange:NSMakeRange(1, 64)];
        pubBytes = (const uint8_t *)[pubdata bytes];
    }
    
    uint8_t l_public[64];
    memcpy(l_public, pubBytes, 64);
    
    NSData *data = [NSData dataWithBytes:l_public length:64];
//    [self printData:data name:@"merge pubkey"];
    
   
    
    NSData *sha256Data = [SecureData KECCAK256:data];
//    [self printData:sha256Data name:@"256 key"];
    
    NSData *subData = [sha256Data subdataWithRange:NSMakeRange(sha256Data.length - 20, 20)];
    
    NSMutableData *mdata = [[NSMutableData alloc]init];
    
    
//    uint8_t pre = 0xa0;
    
    //on line
    uint8_t pre = 0x41;
    
    [mdata appendBytes:&pre length:1];
    
    [mdata appendData:subData];
//    [self printData:mdata name:@" address data "];
    
//    NSLog(@"h0------%@",mdata);
    NSData *hash0 = [SecureData SHA256:mdata]; // [mdata SHA256Hash];
//    [self printData:hash0 name:@" hash 0 "];
//    NSLog(@"h2------%@",hash0);
    NSData *hash1 = [SecureData SHA256:hash0];//[hash0 SHA256Hash];
//    [self printData:hash1 name:@" hash 1 "];
//    NSLog(@"h2------%@",hash1);
    
    [mdata appendData:[hash1 subdataWithRange:NSMakeRange(0, 4)]];
//    [self printData:mdata name:@"address check sum"];
    
    return  mdata;
}
@end
