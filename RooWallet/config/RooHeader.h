//
//  RooHeader.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#ifndef RooHeader_h
#define RooHeader_h

#ifdef __OBJC__

#import "UIView+Frame.h"
#import "UIButton+EdgeInsets.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
#import "noDataView.h"

#import "passdOCRView.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "Request.h"
#import "MJRefresh.h"
#import "SGQRCode.h"
#import "walletModel.h"

#import "HSEther.h"
#import "BTCWrapper.h"
#import "TRONWallet.h"

#import "XHNetworkCache.h"
#import "MNCacheClass.h"
#import "BGFMDB.h"
#import "userModel.h"
#import "symbolModel.h"
#import "UIImageView+SDCategory.h"

#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]







#define SCREEN_FRAME  ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

#define IS_iPhoneX ( [Utility isIPhonex])
#define IS_iPad ( [Utility isIPad])
#define TabHeight ( [Utility getTabHiegt])
#define  kStatusBarAndNavigationBarHeight  (IS_iPhoneX ? 88.f : 64.f)
#define WD_StatusHight1  (TabHeight+44)
#define WD_TabBarHeight1 (TabHeight>20?83:49)
#define  kStatusBarHeight      (IS_iPhoneX ? 44.f : 20.f)
#define  WDNavHeight     (kStatusBarHeight+10)
#define WD_TabBarHeight ([Utility isIPad]?50:WD_TabBarHeight1)
#define WD_StatusHight  ([Utility isIPad]?TabHeight+50:WD_StatusHight1)
#define  kTabbarSafeBottomMargin        (IS_iPhoneX ? 34.f : 0.f)
#define WD_TopBarHeight  ([Utility isIPad]?TabHeight+50:WD_StatusHight1)
#define WeakSelf __weak typeof(self) weakSelf = self

static inline CGFloat gdValue(CGFloat value){
    if ([Utility isIPad]) {
        return value/475.0f*SCREEN_WIDTH;
    }else{
        return value / 375.0f * SCREEN_WIDTH;
    }
}


//颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif


#define  viewColor  (UIColorFromRGB(0xffffff))
#define   zyincolor  (UIColorFromRGB(0xA8B0BC))
#define  ziColor  (UIColorFromRGB(0x333333))
#define  cyColor (UIColorFromRGB(0xf5f6f9))
#define  mainColor (UIColorFromRGB(0x376AFF))
#define  tanColor (UIColorFromRGB(0xEDEEF3))//弹窗颜色


#define  upColor  (UIColorFromRGB(0x00B464))//涨
#define  outColor (UIColorFromRGB(0xEF5656))//跌
//字体
#define  ZITIRegular     @"PingFang-SC-Regular"
#define  ZITIMedium      @"PingFang-SC-Medium"
#define  ZITIBold      @"Helvetica-Bold"

#define  isYinPrice  @"isYinc"//隐藏价格

#define  ETHWalletPasKey @"Eh123456"//mima

#define  BTCWalletPasKey @"Bc123456"//mm

#define  TRONWalletPasKey @"TRo123456"//mm

#define fontNum(num) ([UIFont fontWithName:ZITIRegular size:gdValue(num)])
#define fontMidNum(num) ([UIFont fontWithName:ZITIMedium size:gdValue(num)])
#define fontBoldNum(num) ([UIFont fontWithName:ZITIBold  size:gdValue(num)])

#define imageName(name) ([UIImage imageNamed:name])
#define Url_Str(name) [NSURL URLWithString:(name)]

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define  isAgrEE ([[NSUserDefaults standardUserDefaults]objectForKey:@"isAgrEE"])//是否同意隐私
#define  UserPassword ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserPassword"])//平台密码

#define  selewalletIndex ([[NSUserDefaults standardUserDefaults]integerForKey:@"selewalletIndx"])//用户当前选择

#define  UserModelDataKey @"UserModelDataKey"

#define  ratesModelDataKey @"ratesModelDataKey"//当前汇率

#define  coinModelDataKey @"coinModelDataKey"//当前计价

#define  coinsIndex ([[NSUserDefaults standardUserDefaults]objectForKey:@"coinsIndex"])//当前选择的计价
#define  isRedvd ([[NSUserDefaults standardUserDefaults]objectForKey:@"isRedvd"])//是否更新

#define  isQuest ([[NSUserDefaults standardUserDefaults]objectForKey:@"isQuest"])//是否答题


#define usdcnyname @"usdcnyname"  //计价变化

#define bg_tablename @"userMangerDB"  //当前数据库名字
#define bg_addresname @"addresMangerDB"  //当前地址名字
#define bg_pushNewname @"pushNewtMangerDB"  //交易消息数据库名字
#define bg_Newtpushname @"xtNewpushMangerDB"  //系统消息数据库名字
#define bg_cooletname @"cooletMangerDB"  //收藏数据库名字
#define bg_zuijinname @"zuijngMangerDB"  //最近名字
#define WalletcountKEY @"WalletcountKEY" //钱包次数
#define sybmolcountKEY @"SymbolcreadCountKEY" //代币次数
#define bg_DeFizxname @"defizxMangerDB"  //defi名字




#define  chinaCodeArr @[@"ETH",@"BSC",@"HECO",@"OEC",@"POLYGON",@"TRON",@"FANTOM"] //主链数组//



//语言
CG_INLINE  NSString*
getLocalStr(NSString*str){
    return NSLocalizedString(str, nil);
}

#endif


#endif /* RooHeader_h */
