//
//  MnemonViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//备份助记词

#import "BaseViewController.h"

typedef void(^getisBlukBlock)(NSString* _Nullable blockStr);
NS_ASSUME_NONNULL_BEGIN

@interface MnemonViewController : BaseViewController
@property(nonatomic,copy)NSString*mnemonics;

@property(nonatomic,assign)NSInteger type;//0正常，1创建
@property(nonatomic,copy)getisBlukBlock block;

@end

NS_ASSUME_NONNULL_END
