//
//  passdOCRView.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getpassBlock)(NSString*str);
typedef void(^getpaquxBlock)(void);
@interface passdOCRView : UIView
@property(nonatomic,copy)getpassBlock getpass;
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr   typ:(int)type;//type 1验证。 0输入2次,  2 验证输入3次

@property(nonatomic,copy)getpaquxBlock qublock;
- (void)show;
- (void)hide;



@end


NS_ASSUME_NONNULL_END
