//
//  SGQRCodeScanVC.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SGQRCodeScanDelegate<NSObject>
-(void)getSGQECodeUrlStr:(NSString*)urlStr;
@end
@interface SGQRCodeScanVC : BaseViewController
@property(nonatomic,weak)id<SGQRCodeScanDelegate>delegate;
@property(nonatomic,assign)NSInteger type;//1地址扫描
@end

NS_ASSUME_NONNULL_END
