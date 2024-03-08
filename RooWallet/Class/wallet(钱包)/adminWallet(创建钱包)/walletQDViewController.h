//
//  walletQDViewController.h
//  RooWallet
//
//  Created by mac on 2021/8/5.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^getwatkBlock)(NSString* _Nullable blockStr);
@interface walletQDViewController : BaseViewController
@property(nonatomic,copy) NSString*mnemonicPhrase;
@property(nonatomic,copy)getwatkBlock block;
@end

NS_ASSUME_NONNULL_END
