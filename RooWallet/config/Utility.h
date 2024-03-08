//
//  Utility.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "dapptyModel.h"
#import "walletNodesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject
+(NSString *)getNowTimeTimestamp;
+(CGFloat)getTabHiegt;
+(BOOL)isIPhonex;
+(BOOL)isIPad;
//+(UIViewController *)getCurrentVC;
+(BOOL) isBlankString:(NSString *)string;
+(CGFloat)getStatusBarHeight;
+ (UIViewController *)dc_getCurrentVC;
+(NSMutableAttributedString*)getText:(NSString*)titStr colo:(UIColor*)color font:(id)fontvalue rangText:(id)rangStr;
//设置文本行高并获取字符串的高度
+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width;
+ (CGFloat) withForString:(NSString *)value fontSize:(CGFloat)fontSize andhig:(CGFloat)hig;
+(NSString*)strData:(id)responseObject;
+(NSString*)upTimeHHmm:(id)tiStr;

+(NSString*)douVale:(id)douv  num:(NSInteger)num;
+ (NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson;
+ (NSArray*)toArrayOrNSDictionary:(NSString *)jsonData;
+(UIImage*)vireimg:(NSString*)str hig:(CGFloat)hig;
+ (NSString *)changeAsset:(NSString *)amountStr;
+(NSString *)ToHex:(NSString*)tms;
+(NSString*)removeFloatAllZero:(NSString*)string;
+(NSString*)upTimeHHmm:(id)tiStr geshi:(NSString*)geshi;
+(dapptyModel*)setmodelValue:(dapptyModel*)model;
+(NSString*)getnumstr:(NSString*)numstr;
+(BOOL)judgeETHadrre:(NSString*)addres;
+(NSArray*)getChaninCodeStr;
+(NSString*)Oncechindcode:(NSString*)chincode;
+(NSString*)getDBName:(NSString*)chincode;
+(NSString*)getChian:(NSString*)chian;
+(BOOL)gettextField:(UITextField *)textField shouldChangeRange:(NSRange)range replString:(NSString *)string num:(NSInteger)num;
+(BOOL)isTRXAddre:(NSString*)address;
+(NSArray*)getNodeCode:(NSString*)chiancode;
@end

NS_ASSUME_NONNULL_END
