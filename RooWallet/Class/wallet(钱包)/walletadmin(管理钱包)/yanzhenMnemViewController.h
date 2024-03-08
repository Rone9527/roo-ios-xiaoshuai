//
//  yanzhenMnemViewController.h
//  RooWallet
//
//  Created by mac on 2021/6/29.
//验证助记词

#import "BaseViewController.h"

typedef void(^getyanzisBoupBlock)(NSString* _Nullable blockStr);
NS_ASSUME_NONNULL_BEGIN

@interface yanzhenMnemViewController : BaseViewController
@property(nonatomic,copy)NSArray*mneArr;
@property(nonatomic,copy)NSString*mnemonics;
@property(nonatomic,assign)NSInteger type;//0正常，1创建
@property(nonatomic,copy)getyanzisBoupBlock block;

@end

NS_ASSUME_NONNULL_END
