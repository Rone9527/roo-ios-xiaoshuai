//
(void)hs_createWithPwd:(NSString *)pwd
(void)hs_inportMnemonics:(NSString *)mnemonics
(void)hs_importKeyStore:(NSString *)keyStore
(void)hs_importWalletForPrivateKey:(NSString *)privateKey
(void)hs_getBalanceWithTokens:(NSArray<NSString *> *)arrayToken
(void)hs_sendToAssress:(NSString *)toAddress money:(NSString *)money tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal currentKeyStore:(NSString *)keyStore pwd:(NSString *)pwd gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit block:(void(^)(NSString *hashStr,BOOL suc,HSWalletError error))block;