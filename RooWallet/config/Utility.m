//
//  Utility.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "Utility.h"
#import "blockModel.h"
#import <ethers/ethers.h>

@implementation Utility
//设置文本行高并获取字符串的高度
+ (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(CGFloat)width
{
  
    
        
  
    UIFont *font = fontNum(fontSize);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font ,NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    return sizeToFit.size.height;
    
}
+(UIImage*)vireimg:(NSString*)str hig:(CGFloat)hig{
    
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, hig, hig)];
    view.backgroundColor=cyColor;
  
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    lab.textColor=zyincolor;
    lab.text=str;
    lab.font=fontBoldNum(16);
    lab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:lab];
    
    UIImage*img=[self  convertViewToImage:view];
    return img;
    
}
+(UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}
+ (NSArray*)toArrayOrNSDictionary:(NSString *)jsonData{

    if (jsonData != nil) {

        NSData* data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];

        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];

        if (jsonObject != nil){

            return jsonObject;

        }else{

            // 解析错误

            return nil;

        }

    }

    return nil;

}
+(NSString *)reviseString:(id)str
{
    NSString*strr=[NSString stringWithFormat:@"%@",str];
    //直接传入精度丢失有问题的Double类型
    
//     double conversionValue = [strr doubleValue];
//
//    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
   
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:strr];
    return [decNumber stringValue];
}
+(NSString*)douVale:(id)douv  num:(NSInteger)num {
  
    NSString*ser= [self reviseString:douv];
//    NSLog(@"ssd--%@",ser);
//    NSString*srt=[NSString stringWithFormat:@"%@",ser];
    
    NSString*str;
    if([ser containsString:@"."]){
        NSString*fr=[[ser componentsSeparatedByString:@"."]firstObject];
        NSString*sed=[[ser componentsSeparatedByString:@"."]lastObject];
     
        
        if(sed.length>num){
            sed=[sed substringToIndex:num];
            
            if(sed.length>0){
             str=[NSString stringWithFormat:@"%@.%@",fr,sed];
            }
            else{
               str=[NSString stringWithFormat:@"%@",fr];
            }
           
        }
        else{
            NSString *string = [NSString stringWithFormat:@"%%.%ldf",num];
            
            str = [NSString stringWithFormat:string, [ser doubleValue]];
           
        }
       
       
        
    }
    else{
        NSString *string = [NSString stringWithFormat:@"%%.%ldf",num];
        
        str = [NSString stringWithFormat:string, [ser doubleValue]];
        
        
    }
    //    NSString*str=[NSString stringWithFormat:@"%.7f",[srt doubleValue] ];
    //    str=[str substringToIndex:str.length-1];
    
//    NSString * testNumber = str;
//
//        NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    
    return str;
}
+(NSString*)getnumstr:(NSString*)numstr{
    
    NSString*str=@"--";
    if([numstr doubleValue]>=1){
        str=[Utility douVale:numstr num:2];
    }
    else{
        str=[Utility douVale:numstr num:8];
        
       
    }
//    NSLog(@"sd1--%@",str);
    
    str=[Utility removeFloatAllZero:str];
    
//    NSLog(@"sd2--%@",str);
    
    return str;
}
+ (NSString *)gs_jsonStringCompactFormatForNSArray:(NSArray *)arrJson {

    

    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {

        return nil;

    }

    

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];

    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return strJson;

}



+(NSMutableAttributedString*)getText:(NSString*)titStr colo:(UIColor*)color   font:(id)fontvalue rangText:(id)rangStr{
    NSString*rangStrr=[NSString stringWithFormat:@"%@",rangStr];
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:titStr];
    
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
     
                            value:color
     
                            range:[titStr rangeOfString:rangStrr]];
    [attrDescribeStr addAttribute:NSFontAttributeName value:fontvalue  range:[titStr rangeOfString:rangStrr]];
    
    
    return attrDescribeStr;
    
}


+ (NSString *)changeAsset:(NSString *)amountStr

{

if(amountStr && ![amountStr isEqualToString:@""])

{

double num = [amountStr doubleValue];

//    if(num >=1000000000000)
//
//{
//
//NSString *str = [NSString stringWithFormat:@"%.2f",num/1000000000000];
//
////return[NSString stringWithFormat:@"%@万亿",str];
//    return [NSString stringWithFormat:@"%@MB",str];
//
//}
   if(num >=1000000000)

{

NSString *str = [NSString stringWithFormat:@"%.2f",num/1000000000];//10亿

//return[NSString stringWithFormat:@"%@亿",str];
    
    return [NSString stringWithFormat:@"%@B",str];;

}
  else if(num >=1000000)

{

NSString *str = [NSString stringWithFormat:@"%.2f",num/1000000];//百万

//return[NSString stringWithFormat:@"%@千万",str];
    return [NSString stringWithFormat:@"%@M",str];

}
//else if(num >=10000)
//
//{

//NSString *str = [NSString stringWithFormat:@"%.2f",num/10000];
//
////return[NSString stringWithFormat:@"%@万",str];
//
//    return [NSString stringWithFormat:@"%@M",str];
//
//}

}

return amountStr;

}


#pragma mark 获取主币
+(NSString*)Oncechindcode:(NSString*)chincode{
    NSString*symobl;
    NSArray*rt1=@[@"ETH",@"BSC",@"HECO",@"OEC",@"POLYGON",@"TRON",@"FANTOM"];//
    NSArray*rt2=@[@"ETH",@"BNB",@"HT",@"OKT",@"MATIC",@"TRX",@"FTM"];//主币
    
    for(int i=0;i<rt1.count;i++){
        
        NSString*syt=rt1[i];
        if([chincode isEqualToString:syt]){
            symobl=rt2[i];
            
            
        }
        
    }
    

    
    
    return symobl;
}
#pragma mark 获取链主币
+(NSArray*)getChaninCodeStr{
    
    NSMutableArray*morenArr=[NSMutableArray array];
    
    NSArray*art1=@[@"ETH",@"BSC",@"HECO",@"OEC",@"POLYGON",@"TRON",@"FANTOM"];//
    NSString*str1=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"ETH"];
    NSString*str2=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"BNB"];
    NSString*str3=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"HT"];
    NSString*str4=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"OKT"];
    NSString*str5=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"MATIC"];
    NSString*str6=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"TRX"];
    NSString*str7=[NSString stringWithFormat:@"%@:%@",getLocalStr(@"adm25"),@"FTM"];
    
    NSArray*art2=@[str1,str2,str3,str4,str5,str6,str7];
    
    NSArray*art3=@[@"ETH",@"BNB",@"HT",@"OKT",@"MATIC",@"TRX",@"FTM"];
    
    
    for(int i=0;i<art1.count;i++){
        
        btokensModel*model=[[btokensModel alloc]init];
        model.chainCode=art1[i];
        model.name=art2[i];
        model.isRecommend=@"1";
        model.symbol=art3[i];
        model.isCode=@"1";

        [morenArr addObject:model];
        
    }
    
//    morenArr= [[morenArr reverseObjectEnumerator] allObjects];
    
    return [[morenArr reverseObjectEnumerator] allObjects];
    
}
+(BOOL)gettextField:(UITextField *)textField shouldChangeRange:(NSRange)range replString:(NSString *)string num:(NSInteger)num{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toString.length > 0) {
        
        //NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?";//(带正负号的)
        
//        NSString *stringRegex = @"(([0]|(0[.]\\d{0,18}))|([1-9]\\d{0,100}(([.]\\d{0,18})?)))?";//一般格式 d{0,8}
        
        //控制位数

        
        NSString *stringRegex = [NSString stringWithFormat: @"(([0]|(0[.]\\d{0,%ld}))|([1-9]\\d{0,100}(([.]\\d{0,%ld})?)))?",num,num];//一般格式 d{0,8} 控制位数
        
        NSPredicate *money = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        
        BOOL flag = [money evaluateWithObject:toString];
        
        if (!flag) return NO;
        
    }
    
    return YES;
  
}
+(BOOL)judgeETHadrre:(NSString*)addres{
    BOOL result = false;
    
    NSString * regex = @"^(0x)?[0-9a-fA-F]{40}$";//@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:addres];

    return result;
        
//    if (!(preg_match('/^(0x)?[0-9a-fA-F]{40}$/', $address))) {
//        return false; //满足if代表地址不合法
//    }
//
//    // BTC地址合法校验
//    if (!(preg_match('/^(1|3)[a-zA-Z\d]{24,33}$/', $address) && preg_match('/^[^0OlI]{25,34}$/', $address))) {
//        return false; //满足if代表地址不合法
//    }
}
+(BOOL)isTRXAddre:(NSString*)address{
   
    BOOL result = NO;
    if (address.length != 34){
        NSLog(@"没有34");
           return  NO;

    }
   
    NSMutableData*data=BTCDataFromBase58Check(address);
    
    if(data.length!=21){
        NSLog(@"没有21");
        return NO;
    }
    NSString*adret=[SecureData dataToHexString:data];

    if (adret.length != 44){
        NSLog(@"没有44");
            return NO;

    }

    NSString * regex = @"^(0x41)?[0-9a-fA-F]{40}$";//@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:adret];

    return result;

   
    
    
    
    
    
  
}
+(NSString*)removeFloatAllZero:(NSString*)string

{
    
  
    
//    NSString * testNumber = string;
//
//    NSString * s = nil;
//
//    NSInteger offset = testNumber.length - 1;
//
//    while (offset)
//
//    {
//
//        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
//
//        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
//
//        {
//
//            offset--;
//
//        }
//
//        else
//
//        {
//
//            break;
//
//        }
//
//    }
//
//    NSString * outNumber = [testNumber substringToIndex:offset+1];
//
//
//
//    return outNumber;
    
    
    NSString *testNumber = string;
       NSString *outNumber  = [NSString
           stringWithFormat:@"%@", [[NSDecimalNumber decimalNumberWithString:testNumber] stringValue]];
       return outNumber;

  
}

+(NSString *)getNowTimeTimestamp{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;

}
+(BOOL) isBlankString:(NSString *)string {

    if (string == nil || string == NULL || [string isEqualToString:@"(null)"]) {

        return YES;

    }

    if ([string isKindOfClass:[NSNull class]]) {

        return YES;

    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {

        return YES;

    }

    return NO;

}
+(NSString*)upTimeHHmm:(id)tiStr{
    
    NSString*timeStampString=[NSString stringWithFormat:@"%@",tiStr];
    if(timeStampString.length>10){
        timeStampString=[timeStampString substringToIndex:timeStampString.length- 3 ];
    }
    
    NSTimeInterval time=[timeStampString doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    if([currentDateStr containsString:@"1970/"]){
        currentDateStr=@"--";
    }
    return  currentDateStr;
}
+(NSString*)upTimeHHmm:(id)tiStr geshi:(NSString*)geshi{
    
    NSString*timeStampString=[NSString stringWithFormat:@"%@",tiStr];
    if(timeStampString.length>10){
        timeStampString=[timeStampString substringToIndex:timeStampString.length- 3 ];
    }
    
    NSTimeInterval time=[timeStampString doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:geshi];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    if([currentDateStr containsString:@"1970/"]){
        currentDateStr=@"--";
    }
    return  currentDateStr;
}
+(NSString *)ToHex:(NSString*)tms
 {
     
     long long int tmpid=[tms longLongValue];
     
     NSString *nLetterValue;
     NSString *str =@"";
     long long int ttmpig;
     for (int i = 0; i<9; i++) {
         ttmpig=tmpid%16;
         tmpid=tmpid/16;
         switch (ttmpig)
         {
            case 10:
                 nLetterValue =@"A";break;
             case 11:
                 nLetterValue =@"B";break;
             case 12:
                 nLetterValue =@"C";break;
             case 13:
                 nLetterValue =@"D";break;
             case 14:
                 nLetterValue =@"E";break;
             case 15:
                 nLetterValue =@"F";break;
             default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];

         }
         str = [nLetterValue stringByAppendingString:str];
         if (tmpid == 0) {
             break;
         }

     }
     return str;
 }
+ (NSString *)getTimeFromTimestamp:(NSString*)toe{

    //将对象类型的时间转换为NSDate类型

    double time =[toe integerValue];

    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];

    //设置时间格式

    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"MM.dd HH:mm"];

    //将时间转换为字符串

    NSString *timeStr=[formatter stringFromDate:myDate];

    return timeStr;

}





+ (BOOL)isIPhonex {
    if (@available(iOS 11.0, *)) {
        // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom >= 34.0) {
            return YES;
            
        } else {
            return NO;
            
        }
        
    } else {
        return NO;
        
    }
    return NO;
    
}
+(BOOL)isIPad{
    NSString *deviceType = [UIDevice currentDevice].model;

  

       if([deviceType isEqualToString:@"iPhone"]) {

           //iPhone

           return NO;

       }

       else if([deviceType isEqualToString:@"iPod touch"]) {

           //iPod Touch

           return NO;

       }

       else if([deviceType isEqualToString:@"iPad"]) {

           //iPad

           return YES;

       }

       return NO;

}


+ (CGFloat) higForString:(NSString *)value    fontSize:(CGFloat)fontSize andwit:(CGFloat)wit{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(wit,CGFLOAT_MAX ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font ,NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    
    return sizeToFit.size.height;
}
+ (CGFloat) withForString:(NSString *)value fontSize:(CGFloat)fontSize andhig:(CGFloat)hig
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
 
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,hig ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font ,NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    return sizeToFit.size.width;
    
}
+(CGFloat)getTabHiegt{
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
       
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
    }
  
    return statusBarHeight;
}

+(CGFloat)getTabHiegt1{
    
     CGFloat ff=0.0;
        if([self ispad]){
           
         ff=50;
        }
        else{
            ff=WD_TabBarHeight;
        }
    
    return ff;
}
+(NSString*)strData:(id)responseObject{
    NSData *data =    [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString*str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

#pragma mark - 获取当前屏幕显示的VC
+ (UIViewController *)dc_getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
       
    }
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
       
        
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
     
        
    }else{
        // 根视图为非导航类
        currentVC = rootVC;
        
    }
    return currentVC;
}
+(BOOL)ispad{
    NSString *deviceType = [UIDevice currentDevice].model;

  

       if([deviceType isEqualToString:@"iPhone"]) {

           //iPhone

           return NO;

       }

       else if([deviceType isEqualToString:@"iPod touch"]) {

           //iPod Touch

           return NO;

       }

       else if([deviceType isEqualToString:@"iPad"]) {

           //iPad

           return YES;

       }

       return NO;

}


+(NSString*)getzti{
    
    NSString*str=@"PingFang-SC-Regular";
    
    NSString*ty=[[NSUserDefaults standardUserDefaults]objectForKey:@"setzti"];
   
    if(ty&&ty.length>0){
        str=ty;
    }
    
    return str;
    
}
+(NSString*)getztiBole{
    
    NSString*str=@"Helvetica-Bold";
    
    NSString*ty=[[NSUserDefaults standardUserDefaults]objectForKey:@"setzti"];
    
    if(ty && ty.length>0){
        str=ty;
//        [self ziut:ty];
    }
    
    return str;
    
}

+(NSString*)getChian:(NSString*)chian{
    NSString*chaid;
    
    if([chian isEqualToString:@"1"]){
        chaid=@"ETH";
    }
    else if([chian isEqualToString:@"56"]){
        chaid=@"BSC";
    }
    else if([chian isEqualToString:@"128"]){
        chaid=@"HECO";
    }
    else if( [chian isEqualToString:@"66"]){
        chaid=@"OEC";
    }
    else if( [chian isEqualToString:@"137"]){
        chaid=@"POLYGON";
    }
    else if( [chian isEqualToString:@"250"]){
        chaid=@"FANTOM";
    }
    
    return  chaid;
}
+(dapptyModel*)setmodelValue:(dapptyModel*)model{
    userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    if([model.chain containsString:@"ETH"]){
        model.idstr=@"1";
       
       
        for(walletModel*wamodel in usModel.walletArray){
         
            if( [wamodel.name  isEqualToString:@"ETH"]){
                model.addres=wamodel.addres;
                model.prived=wamodel.password;
                walletNodesModel*nodmol=wamodel.nodesArray[0];
                model.rpcurl=nodmol.rpcUrl;
                model.browserUrl=nodmol.browserUrl;
                break;
            }
            
            
        }
        
        
    }
    else  if([model.chain containsString:@"BSC"]){
        model.idstr=@"56";
      for(walletModel*wamodel in usModel.walletArray){


          if( [wamodel.name isEqualToString:@"BSC"]){
              model.addres=wamodel.addres;
              model.prived=wamodel.password;
              walletNodesModel*nodmol=wamodel.nodesArray[0];
              model.rpcurl=nodmol.rpcUrl;
              model.browserUrl=nodmol.browserUrl;
              break;
          }

         
      }
    }
    else if([model.chain containsString:@"HECO"]){
        model.idstr=@"128";
       
       for(walletModel*wamodel in usModel.walletArray){
           
           if( [wamodel.name isEqualToString:@"HECO"]){
               model.addres=wamodel.addres;
               model.prived=wamodel.password;
               walletNodesModel*nodmol=wamodel.nodesArray[0];
               model.rpcurl=nodmol.rpcUrl;
               model.browserUrl=nodmol.browserUrl;
               break;
           }

          
       }
    }
    else if([model.chain containsString:@"OEC"] || [model.chain containsString:@"OKExChain"]|| [model.chain containsString:@"OK"]){
        model.idstr=@"66";
       
       for(walletModel*wamodel in usModel.walletArray){
           
           if( [wamodel.name isEqualToString:@"OEC"]){
               model.addres=wamodel.addres;
               model.prived=wamodel.password;
               walletNodesModel*nodmol=wamodel.nodesArray[0];
               model.rpcurl=nodmol.rpcUrl;
               model.browserUrl=nodmol.browserUrl;
               break;
           }

          
       }
    }
    else if([model.chain containsString:@"POLYGON"] || [model.chain containsString:@"Polygon"]){
        model.idstr=@"137";
       
       for(walletModel*wamodel in usModel.walletArray){
           
           if( [wamodel.name isEqualToString:@"POLYGON"]){
               model.addres=wamodel.addres;
               model.prived=wamodel.password;
               walletNodesModel*nodmol=wamodel.nodesArray[0];
               model.rpcurl=nodmol.rpcUrl;
               model.browserUrl=nodmol.browserUrl;
               break;
           }

          
       }
    }
    else if([model.chain containsString:@"TRON"]){
        model.idstr=@"";
       
       for(walletModel*wamodel in usModel.walletArray){
           
           if( [wamodel.name isEqualToString:@"TRON"]){
               model.addres=wamodel.addres;
               model.prived=wamodel.password;
               walletNodesModel*nodmol=wamodel.nodesArray[0];
               model.rpcurl=nodmol.rpcUrl;
               model.browserUrl=nodmol.browserUrl;
               break;
           }

          
       }
    }
    else if([model.chain containsString:@"FANTOM"]){
        model.idstr=@"250";
       
       for(walletModel*wamodel in usModel.walletArray){
           
           if( [wamodel.name isEqualToString:@"FANTOM"]){
               model.addres=wamodel.addres;
               model.prived=wamodel.password;
               walletNodesModel*nodmol=wamodel.nodesArray[0];
               model.rpcurl=nodmol.rpcUrl;
               model.browserUrl=nodmol.browserUrl;
               break;
           }

          
       }
    }
    
    return model;
}
+(NSArray*)getNodeCode:(NSString*)chiancode{
    
    NSArray*nodArr;
    NSDictionary*dic;
    if([chiancode isEqualToString:@"ETH"]){
        dic=@{@"browserUrl":@"https://cn.etherscan.com/",@"rpcUrl":@"https://mainnet.infura.io/v3/1f1db6b4fbbc451a902f418a10095e2c",@"txBrowserUrl":@"https://cn.etherscan.com/tx/${txid}"};

    }
    else if ([chiancode isEqualToString:@"BSC"]){
        dic=@{@"browserUrl":@"https://www.bscscan.com/",@"rpcUrl":@"https://bsc-dataseed1.binance.org/",@"txBrowserUrl":@"https://www.bscscan.com/tx/${txid}"};
    }
    else if ([chiancode isEqualToString:@"HECO"]){
        dic=@{@"browserUrl":@"https://www.hecoinfo.com/",@"rpcUrl":@"https://http-mainnet.hecochain.com/",@"txBrowserUrl":@"https://www.bscscan.com/tx/${txid}"};
    }
    else if ([chiancode isEqualToString:@"OEC"]){
        dic=@{@"browserUrl":@"https://www.oklink.com/okexchain/",@"rpcUrl":@"https://exchainrpc.okex.org/",@"txBrowserUrl":@"https://www.oklink.com/okexchain/tx/${txid}"};
    }
    else if ([chiancode isEqualToString:@"POLYGON"]){
        dic=@{@"browserUrl":@"https://polygonscan.com/",@"rpcUrl":@"https://polygon-rpc.com/",@"txBrowserUrl":@"https://polygonscan.com/tx/${txid}"};
    }
    else if ([chiancode isEqualToString:@"TRON"]){
        dic=@{@"browserUrl":@"https://tronscan.org/#/",@"rpcUrl":@"https://api.trongrid.io/",@"txBrowserUrl":@"https://tronscan.org/#/transaction/${txid}"};
    }
    else if ([chiancode isEqualToString:@"FANTOM"]){
        dic=@{@"browserUrl":@"https://ftmscan.com/",@"rpcUrl":@"https://rpc.ftm.tools/",@"txBrowserUrl":@"https://ftmscan.com/tx/${txid}"};
    }
    
    walletNodesModel*nodmol=[walletNodesModel mj_objectWithKeyValues:dic];
    
    nodArr=@[nodmol];
    
    
    return nodArr;
}
@end
