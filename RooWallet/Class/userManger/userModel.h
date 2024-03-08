//
//  userModel.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface userModel : NSObject
@property(nonatomic,copy)NSString*name;//t用户名字
@property(nonatomic,copy)NSString*sectPassWord;//安全密码
@property(nonatomic,copy)NSString*creatimer;//c创建时间
@property(nonatomic,copy)NSString*mnemonicPhrase;// 助记词;
@property(nonatomic,copy)NSString*privtyKey;// 私钥;

@property(nonatomic,assign) BOOL isHide;//是否隐藏用户的余额 0.不隐藏  1.隐藏
@property(nonatomic,copy) NSString *isSeled;//是否选择 0 不选中 1 选中
@property(nonatomic,copy) NSString *isPort;//是否导入 0 不导入 1 导入
//一个用户有多个钱包
@property(nonatomic,copy) NSArray *walletArray;//钱包数据

@property(nonatomic,copy) NSString *isbackUps;//是否备份 0 不备份 1 备份

@property(nonatomic,copy) NSArray *myAssctArray;//我的资产数据
@property(nonatomic,assign)NSInteger isYD ;//1已读我的资产
@end

NS_ASSUME_NONNULL_END
