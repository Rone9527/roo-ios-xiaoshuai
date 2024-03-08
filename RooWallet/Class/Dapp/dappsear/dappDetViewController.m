//
//  dappDetViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import "dappDetViewController.h"
#import  <WebKit/WebKit.h>
#import "actShootView.h"
//#import "tranQDView.h"
#import "dappTradView.h"
#import "TraGasmodel.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import <ethers/ethers.h>
#import "authorSecdView.h"
#import "dapperrView.h"
#import "authsmView.h"
#import "addAsstsViewController.h"
#import "qianingView.h"
#import "trxauthView.h"

@interface dappDetViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
@property(nonatomic,strong)WKWebView*webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) WKUserContentController*userContentController;

@property(nonatomic,copy)NSURL*providerJsBundleUrl;
@property(nonatomic,copy)NSURL*providerJsUrl;

@property(nonatomic,strong)WKUserScript*providerScript;
@property(nonatomic,strong)WKUserScript*injectedScript;



@property(nonatomic,copy)NSURL*providerJsUrl2;

@property(nonatomic,copy)NSURL*providerJsUrl3;
@property(nonatomic,strong)WKUserScript*providerScript3;

@property(nonatomic,copy)NSString*gasprice;
@property(nonatomic,copy)NSString*code;//主币
@property(nonatomic,copy)NSString*codeDecimals;//主币位数
@property(nonatomic,copy)NSString*codeprice;//主币价格
@property (nonatomic, assign) ChainId chainId;
@property(nonatomic,copy)NSString*Tradidstr;

@property(nonatomic,strong)UIButton*gbtn;
@property(nonatomic,copy)NSString*contUrl;

@property(nonatomic,copy)NSString*addchid;
@property(nonatomic,assign)BOOL isReld;

@end

@implementation dappDetViewController
-(WKUserContentController*)userContentController{
    if(!_userContentController){
        
        _userContentController = [[WKUserContentController alloc] init];
        NSString*bundlePath;
        NSString*scrt;
        if([self.dappmodel.chain isEqualToString:@"TRON"]){
            bundlePath=[[NSBundle mainBundle]pathForResource:@"Tron" ofType:@"js"];
            scrt=[NSString stringWithFormat: @"(function(){var config = {address: \"%@\", fullNode:\"%@\", solidityNode: \"%@\", eventServer: \"%@\"};var provider = new window.Roo(config); window.tronLink = provider;})();",self.dappmodel.addres,self.dappmodel.rpcurl,self.dappmodel.rpcurl,self.dappmodel.rpcurl];
//            NSLog(@"sdd---%@",scrt);
        }
        else{//trust_nws trust_min
            bundlePath=[[NSBundle mainBundle]pathForResource:@"trust_nws" ofType:@"js"];
            scrt=[NSString stringWithFormat:@"(function() {var config = { address:\"%@\".toLowerCase(),chainId: %ld,rpcUrl:\"%@\", isDebug: true};window.ethereum = new trustwallet.Provider(config);window.web3 = new trustwallet.Web3(window.ethereum);trustwallet.postMessage = (jsonString) => { webkit.messageHandlers._tw_.postMessage(jsonString) };})();",self.dappmodel.addres,[self.dappmodel.idstr integerValue],self.dappmodel.rpcurl];
        }
        
        //roo_min  web3.min trust-min  AlphaWallet-min
        
        
        _providerJsUrl=[NSURL fileURLWithPath:bundlePath];;
        NSError*err=nil;
        
        NSString*source=[NSString stringWithContentsOfURL:_providerJsUrl encoding:NSUTF8StringEncoding error:&err];
        
        _providerScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        
        
        
        
        
        //        NSLog(@"sdd2----%@",scrt);
        _injectedScript=[[WKUserScript alloc]initWithSource:scrt injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        
        
        
        [_userContentController addUserScript:_providerScript];
        [_userContentController addUserScript:_injectedScript];
        
        
        [_userContentController addScriptMessageHandler:self  name:@"_tw_"];
        [_userContentController addScriptMessageHandler:self  name:@"roowallet"];
        
    }
    return _userContentController;
}

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        _wkConfig.userContentController=self.userContentController;
    }
    return _wkConfig;
}


-(WKWebView*)webView{
    if(!_webView){
        _webView=[[WKWebView alloc]initWithFrame:CGRectMake(0,WD_StatusHight,SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) configuration:self.wkConfig];
        
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        _webView.backgroundColor=viewColor;
        _webView.scrollView.bounces=NO;
        _webView.navigationDelegate=self;
        _webView.UIDelegate=self;
    }
    return _webView;
}
-(void)getprof:(NSString*)chain{
    if([chain isEqualToString:@"ETH"]){
        _code=@"ETH";
        _chainId=ChainIdHomestead;
        
    }
    else if ([chain isEqualToString:@"BSC"]){
        _code=@"BNB";
        _chainId=ChainIdBSC;
    }
    else if ([chain isEqualToString:@"HECO"]){
        _code=@"HT";
        _chainId=ChainIdHECO;
    }
    else if ([chain isEqualToString:@"OEC"]){
        _code=@"OKT";
        _chainId=ChainIdOEC;
    }
    else if ([chain isEqualToString:@"POLYGON"]){
        _code=@"MATIC";
        _chainId=ChainIdPoly;
    }
    else if ([chain isEqualToString:@"FANTOM"]){
        _code=@"FTM";
        _chainId=ChainIdFTM;
        
    }
    else if ([chain isEqualToString:@"TRON"]){
        _code=@"TRX";
        //        _chainId=@"";
    }
    
    NSLog(@"sdd--%@   dd0-----%@",chain,_code);
    
    if(![Utility isBlankString:_code]){
        [self getSymPerice:_code];
    }
    
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    NSLog(@"主链--%@",self.dappmodel.chain);
    _isReld=NO;
    
    _addchid=self.dappmodel.idstr;
    
    self.baseLab.frame=CGRectMake(80, WDNavHeight, SCREEN_WIDTH-160,gdValue(25));
    
    [self getprof:self.dappmodel.chain];
    
    if(![Utility isBlankString:self.dappmodel.chain]){
        [self getGasData:self.dappmodel.chain];
    }
    
    
    
    [self.navHeadView addSubview:self.gbtn];
    
    self.view.backgroundColor=viewColor;
    [self uiConfing];
    
    
    [self setNavUI];
    
    [self getdata];//浏览记录
    
    
    NSArray*collArr=[dapptyModel bg_findAll:bg_cooletname];
    
    self.dappmodel.isColl=0;
    
    
    if([self.dappmodel.tyy isEqualToString:@"0"]||[self.dappmodel.tyy isEqualToString:@"1"]){//搜索页面或理财进来
        
        for(dapptyModel* mm in collArr){
            //            NSLog(@"mm--%@ d--%@ f--%@ f--%@",mm.chain,self.dappmodel.chain,mm.name,self.dappmodel.name);
            
            if([mm.chain isEqualToString:self.dappmodel.chain]&&[mm.name isEqualToString:self.dappmodel.name]){
                self.dappmodel.isColl=1;
                break;
            }
        }
    }
    else{
        for(dapptyModel* mm in collArr){
            //            NSLog(@"sd0----%@   sd1--%@",self.dappmodel.identity,mm.identity);
            
            if([mm.identity isEqualToString:self.dappmodel.identity]){
                self.dappmodel.isColl=1;
                break;
            }
        }
    }
    
    
    
    // Do any additional setup after loading the view.
}
-(UIButton*)gbtn{
    if(!_gbtn){
        _gbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        _gbtn.frame = CGRectMake(gdValue(50), WDNavHeight-2, gdValue(40),gdValue(30));
        
        [_gbtn setImage:[UIImage imageNamed:@"dapgbt"] forState:UIControlStateNormal];
        [_gbtn addTarget:self action:@selector(leftBarBtnClickedd) forControlEvents:UIControlEventTouchUpInside];
        _gbtn.imageEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
        
    }
    
    return _gbtn;
}
-(void)leftBarBtnClickedd{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)leftBarBtnClicked{
    
    if([self.webView canGoBack]){
        [self.webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)getdata{
    NSArray*collArr=[dapptyModel bg_findAll:bg_zuijinname];
    
    NSMutableArray*arr1=[NSMutableArray array];
    NSMutableArray*arr2=[NSMutableArray array];
    NSMutableArray*arr3=[NSMutableArray array];
    
    for(dapptyModel*mm in collArr){
        if([mm.chain isEqualToString:self.dappmodel.chain]&&[mm.name isEqualToString:self.dappmodel.name]){
            
            mm.pxnum=@"1";
            [arr3 addObject:mm];
            
            
            
            
        }
        else{
            mm.pxnum=@"0";
            [arr3 addObject:mm];
            
        }
        [arr1 addObject:mm.chain];
        [arr2 addObject:mm.name];
        
        
    }
    
    if(arr3.count){
        [ dapptyModel bg_saveOrUpdateArray:[arr3 copy]];
    }
    
    if(!([arr1 containsObject:self.dappmodel.chain]&&[arr2 containsObject:self.dappmodel.name])){
        self.dappmodel.bg_tableName=bg_zuijinname;
        self.dappmodel.pxnum=@"0";
        [self.dappmodel bg_save];
    }
}

-(NSDictionary*)returnDictionaryWithDataPath:(NSData*)data
{
    NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    
    return jsonDict;
}
-(void)setNavUI{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(36), WDNavHeight, gdValue(25), gdValue(25));
    [rBtn setImage:imageName(@"dadet") forState:UIControlStateNormal];
    [self.navHeadView addSubview:rBtn];
    [rBtn addTarget:self action:@selector(detpclk) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --更多
-(void)detpclk{
    
    NSArray*art;
    
    if(self.dappmodel.isColl ==1){//已经收藏
        art=@[@"adm6",@"adm7",@"adm8",@"flsht27",@"waqux"];
    }
    else{
        art=@[@"adm6",@"adm7",@"adm8",@"adm9",@"waqux"];
    }
    
    //    if([self.dappmodel.multis isEqualToString:@"1"]){//dou
    //
    //    }
    
    actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:art tis:@""];
    
    //
    WeakSelf;
    view.getIndx = ^(NSInteger indx) {
        NSLog(@"a---%ld",indx);
        if(indx==0){//刷新
            [weakSelf.webView reload];
            
        }
        else if (indx==1){//复制
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            
            
            if(![Utility isBlankString:self.contUrl]){
                pab.string =self.contUrl;
            }
            else{
                pab.string = weakSelf.dappmodel.links;
            }
            
            if (pab == nil) {
                
            } else {
                [MBProgressHUD showText:getLocalStr(@"flsht21")];
            }
            
        }
        else if(indx==2){//分享
            [weakSelf share];
            
        }
        else if(indx==3){//收藏
            
            
            if(weakSelf.dappmodel.isColl !=1){
                weakSelf.dappmodel.isColl=1;
                //            if(![collArr containsObject:weakSelf.dappmodel]){
                [MBProgressHUD showText:getLocalStr(@"flsht23")];
                //              weakSelf.dappmodel.num=self.
                weakSelf.dappmodel.bg_tableName=bg_cooletname;
                [weakSelf.dappmodel bg_save];
                
            }
            else{
                NSArray*collArr=[dapptyModel bg_findAll:bg_cooletname];
                for(int i=0;i<collArr.count;i++){
                    dapptyModel*mm=collArr[i];
                    if([mm.chain isEqualToString:self.dappmodel.chain]&&[mm.name isEqualToString:self.dappmodel.name]){
                        weakSelf.dappmodel.isColl=0;
                        [dapptyModel bg_delete:bg_cooletname row:i+1];
                        
                        [MBProgressHUD showText:getLocalStr(@"flsht24")];
                        break;;
                    }
                    
                    
                }
                
                
                
            }
            //            }
            
        }
        
        
        
    } ;
    
    [view show];
}
-(void)share{
    
    
    NSString *textToShare1 = @"ROO Wallet";
    //        UIImage *imageToShare = _shareImg;
    NSString*url;
    if(![Utility isBlankString:self.contUrl]){
        url =self.contUrl;
    }
    else{
        url = self.dappmodel.links;
    }
    
    NSURL *urlToShare = [NSURL URLWithString:url];
    NSArray *activityItems = @[textToShare1, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    //去除一些不需要的图标选项
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo];
    
    //成功失败的回调block
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
        if (completed){
            NSLog(@"completed");
        }else{
            NSLog(@"canceled");
        }
    };
    activityVC.completionWithItemsHandler = myBlock;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
-(void)uiConfing{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, WD_StatusHight, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.progressView.progressTintColor =mainColor;
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    /*
     *3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
     */
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    //
    //      NSString*wurl=[_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"url---%@ 1--%@  2--%@  3--%@",self.dappmodel.links  ,self.dappmodel.addres,self.dappmodel.idstr ,self.dappmodel.rpcurl);
    //    NSString*url=[NSString stringWithFormat:@"%@?utm_source=tokenpocket",self.dappmodel.links];
    //    NSLog(@"url22---%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dappmodel.links]];
    
    
    [self.webView loadRequest:request];
    
    
    
    [self.view addSubview:self.webView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.3f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }
    else  if ([keyPath isEqualToString:@"title"]) {
        self.baseLab.text=self.webView.title;
        
    }
    
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //    if(kStringIsEmpty(_titStr)){
    //    self.titLa.text=self.webView.title;
    //    }
    
    //    webView.URL.absoluteString;
    self.contUrl=webView.URL.absoluteString;
    //    NSLog(@"s---%@",webView.URL.absoluteString);
    
    //    NSString *currentURL = //[webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    self.baseLab.text=self.webView.title;
    if([Utility isBlankString:self.webView.title]){
        self.baseLab.text=self.dappmodel.name;
        
    }
    
    
    if([self.dappmodel.tyy isEqualToString:@"0"]){
        if(![self.webView canGoBack]){
            self.dappmodel.name=self.webView.title;
            [self.dappmodel bg_saveOrUpdate];
        }
       
        
    }
    
    
    
    
}



- (NSData *)compactFormatDataForDictionary:(NSDictionary *)dicJson

{
    
    if (![dicJson isKindOfClass:[NSDictionary class]]) {
        
        return nil;
        
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];
    
    if (![jsonData isKindOfClass:[NSData class]]) {
        
        return nil;
        
    }
    
    return jsonData;
    
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL*urlStr=navigationAction.request.URL;
    NSString*schme= navigationAction.request.URL.absoluteString;
    NSLog(@"sff---%@     ffdd-%@   fg--%@",schme,urlStr,navigationAction.targetFrame);
    
    if(navigationAction.targetFrame==nil){
        //        [self gotoWebPage:URL.absoluteString];
        //        NSLog(@"sd---%@",URL.absoluteString);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr.absoluteString]];
        [self.webView loadRequest:request];
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    //    if([schme isEqualToString:@"hcphhr"]){
    //
    //         decisionHandler(WKNavigationActionPolicyCancel);
    //    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    
    if(![frameInfo isMainFrame]) {
        
        [webView loadRequest:navigationAction.request];
        
    }
    
    return nil;
}

-(dapptyModel*)getDAPPModelcina:(NSString*)chain{
    
    dapptyModel*model=[[dapptyModel alloc]init];
    model.chain=chain;
    //    model.links=@"https://paraswap.io/#/?network=ethereum";
    
    model.name=self.dappmodel.name;
    model.icon=self.dappmodel.icon;
    model.links=self.dappmodel.links;
    model.isColl=self.dappmodel.isColl;
    model.tyy=self.dappmodel.tyy;
    model.identity=self.dappmodel.tyy;
    model.pxnum=self.dappmodel.pxnum;
    model=[Utility setmodelValue:model];
    //    NSLog(@"s---%@   ll--%@",model.name,model.links);
    
    return model;
    //    model.links=
}


-(NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    //  NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
    //                                                        mutabilityOption:NSPropertyListImmutable
    //                                                                  format:NULL
    //                                                        errorDescription:NULL];
    
    NSString*returnStr=[NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:nil];
    
    
    NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"mesgname--------------------------------------------------%@",message.name);
    NSLog(@"dic===%@",message.body);
    NSDictionary*dicc=message.body;
    if([message.name isEqualToString:@"roowallet"]){//波场dapp
        
        [self tronDappDict:dicc];
        
    }
    
    
    else{//ethDapp
        
        [self ethDappDict:dicc];
        
    }
    
}
#pragma mark --波场dapp处理
-(void)tronDappDict:(NSDictionary*)dic{
    
    id tranD=dic[@"transaction"];
    
    NSString*promiseId=dic[@"promiseId"];
    if([tranD isKindOfClass:[NSDictionary class]]){////交易
        NSDictionary*tranDic=(NSDictionary*)tranD;
        
        if(tranDic.count>0){
            NSString*dataStr=[NSString stringWithFormat:@"%@",tranDic[@"raw_data"][@"contract"][0][@"parameter"][@"value"][@"data"]];
            
//            NSString*value=[NSString stringWithFormat:@"%@",tranDic[@"raw_data"][@"contract"][0][@"parameter"][@"value"][@"call_value"]];
////
////
//            value=[NSString stringWithFormat:@"%lu" ,  strtoul(value.UTF8String, 0, 16)];
            
//            NSString*sdf=[dataStr substringToIndex:8];
//            NSLog(@"sdd---%@  df--%@  dfe--%@",dataStr,sdf,[self stringFromHexString:@"095ea7b30"]);
            
            //095ea7b3
            dataStr=[dataStr hasPrefix:@"0x"]?dataStr:[@"0x" stringByAppendingString:dataStr];
            if([dataStr  hasPrefix:@"0x095ea7b3"]){//授权
                
                NSString*toaddtrs=[NSString stringWithFormat:@"0x%@",tranDic[@"raw_data"][@"contract"][0][@"parameter"][@"value"][@"contract_address"]];
                
                
                NSData*data=[SecureData hexStringToData:toaddtrs];
                NSString*headdtrs=BTCBase58CheckStringWithData(data);
                
                NSArray*arr=@[self.dappmodel.addres,headdtrs];
                
                trxauthView*view=[[trxauthView alloc]initWithFrame:SCREEN_FRAME modell:self.dappmodel arr:arr] ;
                
                
                WeakSelf;
                view.block = ^{
                    [weakSelf tronTradmoeny:tranDic  prid:promiseId];
                };
                
                view.quxblock = ^{
                    NSLog(@"取消");
                 
                    NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,null,\"cancle\");",promiseId];
                    NSLog(@"sddd---%@",evstr2);
                    [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
                };
                
                
                
                [view show];
               
                
            }
            else{//交易
                
                [self TronTradQDict:tranDic  prid:promiseId];
                
            }
            
            
            
            
        }
        
    }
    else{//签名授权
        
        
        NSString*dat=dic[@"transaction"];
        if(dat.length>0){
            NSLog(@"签名授权");
          
            Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[_dappmodel.prived hasPrefix:@"0x"]?_dappmodel.prived:[@"0x" stringByAppendingString:_dappmodel.prived]]];
            
            SecureData *data =[SecureData secureDataWithHexString:dat];
            //
            //
            NSLog(@"sdd---%ld",dat.length);
            
            NSString*str=[NSString stringWithFormat:@"TRON Signed Message:\n32"];
            //        NSLog(@"ssds--%@",[self replaceUnicode:str]);
            
            NSData *datae =[str dataUsingEncoding:NSUTF8StringEncoding];
           
            
            SecureData *data1 = [SecureData secureDataWithCapacity:data.data.length+100];
            [data1 appendData:[SecureData hexStringToData:@"0x19"]];   // resolver(bytes32)
            [data1 appendData:datae];
            
            [data1 appendData:data.data];
            
    
            Signature*sig= [accountt signDigest:[data1 KECCAK256].data];
            
            NSLog(@"sdsds--%@",sig);
            
            SecureData *data2 = [SecureData secureDataWithCapacity:128];
            [data2  appendData:sig.r];
            [data2 appendData:sig.s];
            [data2 appendByte:sig.v];
            
            
            SecureData*data3=[data2 subdataFromIndex:64];
            
            NSString*endStr=[SecureData dataToHexString:data3.data];
            
           
            
            endStr=[[endStr componentsSeparatedByString:@"0x"]lastObject];
            
            NSString*string = [NSString stringWithFormat:@"%lu",strtoul([endStr UTF8String],0,16)];
            
            string= [NSString stringWithFormat:@"%ld",[string integerValue]+27];
            string=[NSString stringWithFormat:@"0x%@",[Utility ToHex:string]];
            
            
            
            data2=[data2 subdataToIndex:64];
            
            
            
            [data2 appendData:[SecureData hexStringToData:string]];
            
            
            NSString*jstr=[SecureData dataToHexString:data2.data];
           
            
          
            
            
            qianingView*view=[[qianingView alloc]initWithFrame:SCREEN_FRAME modell:self.dappmodel qmin:dat];
            
            WeakSelf;
            view.quxblock = ^{
                NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,null,\"cancle\");",promiseId];
                
                NSLog(@"sd2--%@",evstr2);
                
                //        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
                
                [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
            };
            
            [view show];
            
//            endStr=@"0xd5b92791cf14f132f9517c2e4d5279e35ee38485e5cff0a6e88c9276916044043e268f29d6d3ede4a0d9309c2d4f38d9aa5c4fd713416ecf0cf2fcde85a879831b";
            
            view.qdblock = ^{
                
              
                
                NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,\"%@\",null);",promiseId,jstr];
                NSLog(@"gddd---%@",evstr2);
                
                [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
                
               
            };
            
        }
        
    }
    
    
}
#pragma mark --ETHdapp处理
-(void)ethDappDict:(NSDictionary*)dicc{
    if([dicc[@"name"] isEqualToString:@"requestAccounts"]){//调取钱包
     
        NSString*idstr=[NSString stringWithFormat:@"%@", dicc[@"id"]];
        
        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.setAddress(\"%@\");",self.dappmodel.addres];
        NSLog(@"sd1--%@",evstr);
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@, [\"%@\"])", idstr,self.dappmodel.addres];
        NSLog(@"sd2--%@",evstr2);
        [self.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
        
//        NSString*evstr3=[NSString stringWithFormat:@"window.ethereum.chainId"];
//
//        [self.webView evaluateJavaScript:evstr3 completionHandler:^(id _Nullable d, NSError * _Nullable error) {
//            NSLog(@"sdsdwer--%@",d);
//
//        }];
      
        
    }//
    else if([dicc[@"name"] isEqualToString:@"signPersonalMessage"]){//签名授权
        
        NSString*idstr=[NSString stringWithFormat:@"%@", dicc[@"id"]];
        NSString*dat=[NSString stringWithFormat:@"%@",dicc[@"object"][@"data"]];
        
        Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[_dappmodel.prived hasPrefix:@"0x"]?_dappmodel.prived:[@"0x" stringByAppendingString:_dappmodel.prived]]];
        
        //
        SecureData *data =[SecureData secureDataWithHexString:dat];
        //
        //
        NSString*str=[NSString stringWithFormat:@"Ethereum Signed Message:\n%ld",data.data.length];
        //        NSLog(@"ssds--%@",[self replaceUnicode:str]);
        
        NSData *datae =[str dataUsingEncoding:NSUTF8StringEncoding];
        
        SecureData *data1 = [SecureData secureDataWithCapacity:data.data.length+100];
        [data1 appendData:[SecureData hexStringToData:@"0x19"]];   // resolver(bytes32)
        [data1 appendData:datae];
        
        [data1 appendData:data.data];
        
        
        Signature*sig= [accountt signDigest:[SecureData KECCAK256:data1.data]];
        
        
        
        SecureData *data2 = [SecureData secureDataWithCapacity:128];
        [data2  appendData:sig.r];
        [data2 appendData:sig.s];
        [data2 appendByte:sig.v];
        
        
        SecureData*data3=[data2 subdataFromIndex:64];
        
        NSString*endStr=[SecureData dataToHexString:data3.data];
        endStr=[[endStr componentsSeparatedByString:@"0x"]lastObject];
        
        NSString*string = [NSString stringWithFormat:@"%lu",strtoul([endStr UTF8String],0,16)];
        
        string= [NSString stringWithFormat:@"%ld",[string integerValue]+27];
        string=[NSString stringWithFormat:@"0x%@",[Utility ToHex:string]];
        
        
        
        data2=[data2 subdataToIndex:64];
        
        
        
        [data2 appendData:[SecureData hexStringToData:string]];
        
        
        NSString*jstr=[SecureData dataToHexString:data2.data];
        
        
        
        
        qianingView*view=[[qianingView alloc]initWithFrame:SCREEN_FRAME modell:self.dappmodel qmin:dat];
        
        WeakSelf;
        view.quxblock = ^{
            NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", idstr,@"Canceled"];
            
            NSLog(@"sd2--%@",evstr2);
            
            //        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
            
            [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
        };
        
        [view show];
        
        view.qdblock = ^{
            NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@,\"%@\")",idstr,jstr];
            [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
            
            NSLog(@"sd2--%@",evstr2);
            [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
        };
        
        
        
        
        
    }
    
    else if([dicc[@"name"] isEqualToString:@"switchEthereumChain"]){//切换主链
  
        NSDictionary*objt=dicc[@"object"];
        
     
        NSString*idstr=[NSString stringWithFormat:@"%@", dicc[@"id"]];
        
        NSString*chidr=[NSString stringWithFormat:@"%@",objt[@"chainId"]];
        NSString*addchid=[NSString stringWithFormat:@"%lu",strtoul(chidr.UTF8String, 0, 16)];
        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.chainId(\"%@\");",addchid];
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@,[\"%@\"])",idstr,addchid];
        [self.webView evaluateJavaScript:evstr completionHandler:nil];
       
        [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
        
        
    }
    else if([dicc[@"name"] isEqualToString:@"addEthereumChain"]){//切换主链
        NSDictionary*objt=dicc[@"object"];
        
        NSString*chidr=[NSString stringWithFormat:@"%@",objt[@"chainId"]];
        NSString*addchid=[NSString stringWithFormat:@"%lu",strtoul(chidr.UTF8String, 0, 16)];
        
        
        if([_addchid isEqualToString:addchid]){
            return;
        }
           
        
        _addchid=addchid;

        
        self.dappmodel=[self getDAPPModelcina:[Utility getChian:addchid]];
        
        NSString*scrt1=[NSString stringWithFormat:@"(function() {var config = { address:\"%@\".toLowerCase(),chainId: %@,rpcUrl:\"%@\", isDebug: true};window.ethereum = new trustwallet.Provider(config);window.web3 = new trustwallet.Web3(window.ethereum);trustwallet.postMessage = (jsonString) => { webkit.messageHandlers._tw_.postMessage(jsonString) };})();",self.dappmodel.addres,addchid,self.dappmodel.rpcurl];
        
//        NSLog(@"sss--%@",scrt1);
        
        if([Utility isBlankString:self.dappmodel.addres]){
//            userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
            WeakSelf;
            authsmView*view=[[authsmView alloc]initWithFrame:SCREEN_FRAME tit:self.dappmodel.chain];
            view.numblock = ^{
                addAsstsViewController*addVc=[[addAsstsViewController alloc]init];
                addVc.typrt=1;
//                addVc.userModel=usModel;
                [addVc setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:addVc animated:YES];
                
            };
            
            return;
        }
        //
        //
        [self getprof:self.dappmodel.chain];
        
        [self getGasData:self.dappmodel.chain];
        
        
        
        WKUserScript*injectedScriptt=[[WKUserScript alloc]initWithSource:scrt1 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [_userContentController addUserScript:injectedScriptt];
        
        [self.webView reload];
      
        
    }
    else if ([dicc[@"name"] isEqualToString:@"signTransaction"]){//交易
        
        self.Tradidstr=[NSString stringWithFormat:@"%@", dicc[@"id"]];
        
        
        //        NSLog(@"tradis---%@",self.Tradidstr);
        
        NSDictionary*dict=dicc[@"object"];
        
        NSString*dataStr=[NSString stringWithFormat:@"%@",dict[@"data"]];
//        NSString*value=[NSString stringWithFormat:@"%@",dict[@"value"]];
//        value=[NSString stringWithFormat:@"%lu" ,  strtoul(value.UTF8String, 0, 16)];
//
        self.gasprice=@"230";
        if([Utility isBlankString:self.gasprice]){
            [self getGasData:self.dappmodel.chain];
            
            [MBProgressHUD showText:getLocalStr(@"flsht22")];
            return;
        }
        
        dataStr=[dataStr hasPrefix:@"0x"]?dataStr:[@"0x" stringByAppendingString:dataStr];
        if([dataStr  hasPrefix:@"0x095ea7b3"]){//授权
            [self shouquan:dict];
            
            
        }
        else{//交易
            
            [self tradndic:dict];
            
        }
        
        
        
    }
}



-(NSString *)stringFromHexString:(NSString *)hexString { //
    
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}
#pragma mark  授权
-(void)shouquan:(NSDictionary*)dict{
    
    
    NSString*value=[NSString stringWithFormat:@"%@",dict[@"value"]];
    NSString*dataStr=[NSString stringWithFormat:@"%@",dict[@"data"]];
    //    NSData*dta=[NSData dataWithData:dict[@"data"]];
    
    value=[NSString stringWithFormat:@"%.10f" ,  strtoul(value.UTF8String, 0, 16)/ pow(10,18)];
    
    value= [Utility douVale:value num:8];//主币最大8位，到时在配
    
    value = [Utility removeFloatAllZero:value];
    
    NSString*toaddtrs=[NSString stringWithFormat:@"%@",dict[@"to"]];
    
    
    NSString*gast=[NSString stringWithFormat:@"%@",dict[@"gas"]];//limst
    gast=[NSString stringWithFormat:@"%lu",strtoul(gast.UTF8String, 0, 16)];
    if([gast integerValue]<=0){
        gast=@"70000";
    }
    
    double nump=[gast doubleValue]*[_gasprice doubleValue];
    nump=nump/pow(10, 9);
    
    NSString*numStr=[NSString stringWithFormat:@"%f",nump];
    
    NSString*outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
    //    NSLog(@"sd1---%@",outNumber);
    
    outNumber = [Utility removeFloatAllZero:outNumber];
    //    NSLog(@"sd2---%@",outNumber);
    
    NSString*kef=[NSString stringWithFormat:@"%@ %@",outNumber,_code];
    //        NSLog(@"sddddd----%@  f---%@ dddd---%@",kef,_gasprice,numStr);
    
    //    NSLog(@"sdprrr---%@",_gasprice);
    
    
    
    NSArray*arr=@[value,kef,toaddtrs,gast,_code,dataStr,value,_gasprice];
    
    authorSecdView*view=[[authorSecdView alloc]initWithFrame:SCREEN_FRAME modell:self.dappmodel dataArrr:arr] ;
    
    
    WeakSelf;
    view.block = ^(NSString * _Nonnull gaspr, NSString * _Nonnull gaslomt, NSString * _Nonnull datasrt) {
        
        [MBProgressHUD showHUD];
        
        gaslomt=[NSString stringWithFormat:@"%ld",[gaslomt integerValue]];
        [weakSelf tradSendToAssress:toaddtrs money:value tokenETH:toaddtrs decimal:@"18" currentKeyStore:weakSelf.dappmodel.prived pwd:ETHWalletPasKey gasPrice:gaspr gasLimit:gaslomt dat:datasrt] ;
        
        
    };
    
    view.quxblock = ^{
        NSLog(@"取消");
        NSLog(@"取消");
        //        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",@""];
        
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", weakSelf.Tradidstr,@"Canceled"];
        NSLog(@"sd2--%@",evstr2);
        //        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
    };
    
    
    
    [view show];
}
#pragma mark  Tron发起交易确认
-(void)TronTradQDict:(NSDictionary*)dict prid:(NSString*)promiseId{
    NSLog(@"sc---%@",[Utility strData:dict]);
    
    NSString*value=[NSString stringWithFormat:@"%@",dict[@"raw_data"][@"contract"][0][@"parameter"][@"value"][@"call_value"]];
    
    //    NSData*dta=[NSData dataWithData:dict[@"data"]];
    //    NSString*dataStr=[NSString stringWithFormat:@"%@",dict[@"raw_data"][@"contract"][@"parameter"][@"value"][@"contract_address"]];
    
    value=[NSString stringWithFormat:@"%.10f" ,  [value doubleValue]/ pow(10,6)];
    
    value= [Utility douVale:value num:6];//主币最大8位，到时在配
    
    value = [Utility removeFloatAllZero:value];
    
    NSString*toaddtrs=[NSString stringWithFormat:@"0x%@",dict[@"raw_data"][@"contract"][0][@"parameter"][@"value"][@"contract_address"]];
    
    
    NSData*data=[SecureData hexStringToData:toaddtrs];
    NSString*headdtrs=BTCBase58CheckStringWithData(data);
    
    NSArray*arr=@[value,self.dappmodel.addres,headdtrs,@"",self.dappmodel.name,self.dappmodel.links,_code,@"",self.dappmodel.chain,@"",self.codeprice,self.codeDecimals];
    
    //    NSLog(@"sd-fffff--%@",gast);
    
    
    dappTradView*qdView=[[dappTradView alloc]initWithFrame:SCREEN_FRAME  arr:arr comin:self.dappmodel.icon];
    
    [qdView show];
    
    WeakSelf;
    
    qdView.qublock = ^{
        NSLog(@"取消");
        //        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",@""];
        
        NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,null,\"cancle\");",promiseId];
        NSLog(@"sd2--%@",evstr2);
        //        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
    };
    
    
    
    qdView.getselectIndx = ^(NSString * _Nonnull gaspr, NSString * _Nonnull gaslomt) {
        
        passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
        
        __block passdOCRView*passV=passView;
        
        passV.qublock = ^{
            NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,null,\"cancle\");",promiseId];
            NSLog(@"sddd---%@",evstr2);
            [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
        };
        
        passView.getpass = ^(NSString * _Nonnull str) {
            
            
            if([str isEqualToString:UserPassword]){
                [passV hide];
                
                
//                [MBProgressHUD showHUD];
                
                
                [weakSelf tronTradmoeny:dict  prid:promiseId];
                
                
                
            }
            else{
                [MBProgressHUD showText:getLocalStr(@"cwts1")];
            }
            
        };
        
    };
}
#pragma mark  ETH发起交易确认
-(void)tradndic:(NSDictionary*)dict {
    NSString*value=[NSString stringWithFormat:@"%@",dict[@"value"]];
    
    //    NSData*dta=[NSData dataWithData:dict[@"data"]];
    NSString*dataStr=[NSString stringWithFormat:@"%@",dict[@"data"]];
    
    value=[NSString stringWithFormat:@"%.10f" ,  strtoul(value.UTF8String, 0, 16)/ pow(10,18)];
    
    value= [Utility douVale:value num:8];//主币最大8位，到时在配
    
    value = [Utility removeFloatAllZero:value];
    
    NSString*toaddtrs=[NSString stringWithFormat:@"%@",dict[@"to"]];
    
    
    NSString*gast=[NSString stringWithFormat:@"%@",dict[@"gas"]];//limst
    gast=[NSString stringWithFormat:@"%lu",strtoul(gast.UTF8String, 0, 16)];
    if([gast integerValue]<=0){
        gast=@"70000";
    }
    
    double nump=[gast doubleValue]*[_gasprice doubleValue];
    nump=nump/pow(10, 9);
    
    NSString*numStr=[NSString stringWithFormat:@"%f",nump];
    
    NSString*outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
    //    NSLog(@"sd1---%@",_outNumber);
    
    outNumber = [Utility removeFloatAllZero:outNumber];
    //    NSLog(@"sd2---%@",_outNumber);
    
    NSString*kef=[NSString stringWithFormat:@"%@ %@ ≈ %@",outNumber,_code,[self getALLPrice:numStr]];
    //        NSLog(@"sddddd----%@  f---%@ dddd---%@",value,_gasprice,gast);
    
    
    
    NSArray*arr=@[value,self.dappmodel.addres,toaddtrs,kef,self.dappmodel.name,self.dappmodel.links,_code,gast,self.dappmodel.chain,self.gasprice,self.codeprice,self.codeDecimals];
    
    //    NSLog(@"sd-fffff--%@",gast);
    dappTradView*qdView=[[dappTradView alloc]initWithFrame:SCREEN_FRAME  arr:arr comin:self.dappmodel.icon];
    [qdView show];
    
    WeakSelf;
    
    qdView.qublock = ^{
        NSLog(@"取消");
        //        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",@""];
        
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", weakSelf.Tradidstr,@"Canceled"];
        NSLog(@"sd2--%@",evstr2);
        //        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
    };
    
    
    
    qdView.getselectIndx = ^(NSString * _Nonnull gaspr, NSString * _Nonnull gaslomt) {
        
        passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
        
        __block passdOCRView*passV=passView;
        
        passV.qublock = ^{
            NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", weakSelf.Tradidstr,@"Canceled"];
            NSLog(@"sddd---%@",evstr2);
            [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
        };
        
        passView.getpass = ^(NSString * _Nonnull str) {
            NSLog(@"sf--%@  %@",str,UserPassword);
            
            if([str isEqualToString:UserPassword]){
                [passV hide];
                //                    [weakSelf travdf];
                
                [MBProgressHUD showHUD];
                //                    NSLog(@"valu====%@",value);
                
                
                
                NSString*gaslimt=[NSString stringWithFormat:@"%ld",[gaslomt integerValue]];
                
                [weakSelf tradSendToAssress:toaddtrs money:value tokenETH:toaddtrs decimal:@"18" currentKeyStore:weakSelf.dappmodel.prived pwd:ETHWalletPasKey gasPrice:gaspr gasLimit:gaslimt dat:dataStr] ;
                
                
                
                
                
                
            }
            else{
                [MBProgressHUD showText:getLocalStr(@"cwts1")];
            }
            
        };
        
    };
    
    
    
}

-(NSString*)getALLPrice:(NSString*)num{
    
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
    
    
    
    //总价=价格*数量
    NSString*atrr=[NSString stringWithFormat:@"%f",[self.codeprice doubleValue]*[tare doubleValue]*[num doubleValue]];
    
    NSString*allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility removeFloatAllZero:[Utility douVale:atrr num:[self.codeDecimals intValue]]]];//总价
    
    return allPrc;
}
#pragma mark 获取主币价格
-(void)getSymPerice:(NSString*)code{
    NSLog(@"sddd----%@",code);
    NSDictionary*dic=@{@"baseAsset":code};
    
    [Request GET:tigetTickAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        //                NSLog(@"data---%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if([cod intValue]==200){
            
            for(NSDictionary *dict in responseObject[@"data"]){
                
                
                self.codeDecimals=[NSString stringWithFormat:@"%@",dict[@"decimals"]];
                
                self.codeprice=[NSString stringWithFormat:@"%@",dict[@"price"]];
            }
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}
#pragma mark 获取gas费用
-(void)getGasData:(NSString*)chain{
    
    NSDictionary*dic=@{@"chain":chain};
    
    NSLog(@"dic--%@",dic);
    [Request GET:getGasAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        NSLog(@"ddd-f-%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            TraGasmodel*gasmodel=[TraGasmodel mj_objectWithKeyValues:responseObject[@"data"]];
            self.gasprice=gasmodel.proposeGasPrice;
            
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        [self getGasData:self.dappmodel.chain];
        
    }];
    
}

-(void)tradSendToAssress:(NSString *)toAddress money:(NSString *)money tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal currentKeyStore:(NSString *)keyStore pwd:(NSString *)pwd gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit dat:(NSString*)dat {
    
    //         __block Account *a;
    //提供3种方式  1 以太坊官方限流配置   2 web3配置  3 infura配置  本方式使用以太坊官方限流配置RCWEX6WYBXMJZHD5FD617NZ99TZADKBEDJ
    //假如你要用 web3 你就新建 __block JsonRpcProvider e = [[JsonRpcProvider alloc]initWithChainId:测试还是正式枚举 url:你公司后台web3地址]
    //同理 infura 用InfuraProvider.h类库新建即可
    
    WeakSelf;
    //    __block EtherscanProvider *e = [[EtherscanProvider alloc]initWithChainId:ChainIdHomestead apiKey:@"RCWEX6WYBXMJZHD5FD617NZ99TZADKBEDJ"];
    
    
    //
    //    NSData *jsonData = [keyStore dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *err;
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    //                                                        options:NSJSONReadingMutableContainers
    //                                                          error:&err];
    //地址
    //    __block NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
    
    __block Transaction *transaction = [Transaction transactionWithFromAddress:[Address addressWithString:weakSelf.dappmodel.addres]];
    //
    //1 account自己解密
    Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[weakSelf.dappmodel.prived hasPrefix:@"0x"]?weakSelf.dappmodel.prived:[@"0x" stringByAppendingString:weakSelf.dappmodel.prived]]];
    NSLog(@"1 开始新建钱包");
    //         [Account decryptSecretStorageJSON:keyStore password:pwd callback:^(Account *account, NSError *NSError) {
    //             if (NSError == nil){
    //                 a = account;
    //                 NSLog(@"2 新建钱包成功 开始获取nonce");
    //
    //
    NSDictionary*dicc=@{@"method":@"eth_getTransactionCount",@"params":@[weakSelf.dappmodel.addres,@"latest"],@"id":@"824"};
    
    // 获取交易次数
    [Request POSTT:weakSelf.dappmodel.rpcurl parameters:dicc success:^(id  _Nonnull responseObject) {
        NSLog(@"交易次数--%@",[Utility strData:responseObject]);
        NSString*rt=responseObject[@"result"];
        
        rt=[NSString stringWithFormat:@"%lu",strtoul(rt.UTF8String, 0, 16)];
        
        
        transaction.nonce = [rt integerValue];
        //                     NSLog(@"22222---%@",gasPrice);
        //                     transaction.gasPrice = [[BigNumber bigNumberWithDecimalString:gasPrice] mul:[BigNumber bigNumberWithDecimalString:@"1000000000"]];
        //
        NSString*newgasPrice=[NSString stringWithFormat:@"%ld",(NSInteger)([gasPrice doubleValue]*1000000000)];
        
        transaction.gasPrice =[BigNumber bigNumberWithDecimalString:newgasPrice];
        
        //                     if(weakSelf.chainId!=ChainIdHECO){
        transaction.chainId =weakSelf.chainId;
        //                     }
        
        transaction.toAddress = [Address addressWithString:toAddress];
        
        //转账金额  原来的方法会越界NSInteger  建议使用Payment转换后 再用BigNumber里面的加减乘除运算方法
        //                            NSInteger i = money.doubleValue * pow(10.0, decimal.integerValue);
        //                            BigNumber *b = [BigNumber bigNumberWithInteger:i];
        //                            transaction.value = b;
        
        transaction.value =[[Payment parseEther:money] div:[BigNumber bigNumberWithInteger:pow(10.0, 18 - decimal.integerValue)]];
        
        NSLog(@"sd-------%@  %ld   ff--%@",transaction.value,decimal.integerValue,tokenETH);
        
        if ([Utility isBlankString:tokenETH]) {//默认主币
            
            if (gasLimit == nil) {
                
                transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"21000"];
            }else{
                
                NSLog(@"主币手动设置了gasLimit = %@",gasLimit);
                transaction.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
            }
            
            
            transaction.data = [SecureData secureDataWithCapacity:0].data;
            
        }else{
            
            if (gasLimit == nil) {
                
                transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"60000"];
            }else{
                
                NSLog(@"代币手动设置了gasLimit = %@",gasLimit);
                transaction.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
            }
            //                         NSString*srt=[NSString stringWithFormat:@"%@",dat];
            SecureData *data =[SecureData secureDataWithHexString:dat]; //[SecureData secureDataWithCapacity:68];
            //                         [data appendData:[SecureData hexStringToData:@"0xa9059cbb"]];
            //
            //                         NSData *dataAddress = transaction.toAddress.data;//转入地址（真实代币转入地址添加到data里面）
            //                         for (int i=0; i < 32 - dataAddress.length; i++) {
            //                             [data appendByte:'\0'];
            //                         }
            //                         [data appendData:dataAddress];
            //
            //                         NSData *valueData = transaction.value.data;//真实代币交易数量添加到data里面
            //                         for (int i=0; i < 32 - valueData.length; i++) {
            //                             [data appendByte:'\0'];
            //                         }
            //                         [data appendData:valueData];
            //
            //                         transaction.value = [BigNumber constantZero];
            //                         NSLog(@"1111-------%@",data.data);
            transaction.data =data.data;
            transaction.toAddress = [Address addressWithString:tokenETH];//合约地址（代币交易 转入地址为合约地址）
            
            
        }
        
        
        
        //签名
        [accountt sign:transaction];
        NSLog(@"targ----%@",transaction);
        //发送
        NSData *signedTransaction = [transaction serialize];
        NSLog(@"6 开始转账");//eth_signTransaction eth_sendRawTransaction eth_sendTransaction
        NSDictionary*dic =@{@"method": @"eth_sendRawTransaction", @"id":@"2374",@"params": @[[SecureData dataToHexString:signedTransaction]]};
        
        [weakSelf reqdatSendRawTransaction:dic];
        
        
        
    }];
    
    //                    NSLog(@"3 获取nonce成功 值为%ld",pro.value);
    
    
    
    
    
    
    //
    //             }else{
    //                 NSLog(@"密码错误%@",NSError);
    //
    //             }
    //         }];
}

#pragma mark ---交易
-(void)reqdatSendRawTransaction:(NSDictionary*)dic{
    
    
    //    NSLog(@"dic-----%@",dic);
    [Request POST:self.dappmodel.rpcurl parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"交易--%@",[Utility strData:responseObject]);
        
        
        NSDictionary*dictt=responseObject[@"error"];
        if(dictt.count){
            [MBProgressHUD hideHUD];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
                dapperrView*view=[[dapperrView alloc]initWithFrame:SCREEN_FRAME tits:dictt[@"message"]];
                [view  show];
                
                //                NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",@"0x000000"];
                
                NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@, [\"%@\"])", self.Tradidstr,@"0x000000"];
                NSLog(@"sd2--%@",evstr2);
                //                [self.webView evaluateJavaScript:evstr completionHandler:nil];
                
                [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
                
            });
            
            
            return;
        }
        else{
            NSString*ret=[NSString stringWithFormat:@"%@",responseObject[@"result"]];
            
            
            
            //            NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",ret];
            
            NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@, [\"%@\"])", self.Tradidstr,ret];
            NSLog(@"sd2--%@",evstr2);
            //            [self.webView evaluateJavaScript:evstr completionHandler:nil];
            
            [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
                [self getTransactionReceipt:ret];
            });
            
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
}
#pragma mark 查询交易
-(void)getTransactionReceipt:(NSString *)ret{
    
    [MBProgressHUD hideHUD];
    
    NSDictionary*dic=@{@"jsonrpc":@"2.0",@"method": @"eth_getTransactionReceipt", @"id":@"274",@"params": @[ret]};
    
    
    [Request POST:self.dappmodel.rpcurl parameters:dic success:^(id  _Nonnull responseObject) {
        //        NSLog(@"ret----%@",[Utility strData:responseObject]);
        
        NSDictionary*dif=responseObject[@"result"];
        if(dif.count){
            NSString*sts=[NSString stringWithFormat:@"%@",responseObject[@"result"][@"status"]];
            if([sts isEqualToString:@"0x1"]){
                [MBProgressHUD hideHUD];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSLog(@"3秒后执行这个方法");
                    [MBProgressHUD showText:getLocalStr(@"成功")];
                    //                [self.webView reload];
                });
                
                
            }
            else{
                //            NSLog(@"sbei------");
                NSLog(@"取消");
                //        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",@""];
                
                NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", self.Tradidstr,@"Canceled"];
                NSLog(@"sd2--%@",evstr2);
                //        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
                
                [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
                
                dapperrView*view=[[dapperrView alloc]initWithFrame:SCREEN_FRAME tits:@"unknown error"];
                [view  show];
                [self.webView reload];
                
            }
            [MBProgressHUD hideHUD];
        }
        else{
            [self getTransactionReceipt:ret];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
    
}

#pragma mark --波场转账

-(void)tronTradmoeny:(NSDictionary*)responseObject prid:(NSString*)promiseId{
    
    
    
    
    
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]initWithDictionary:responseObject];
    
    
    //            NSLog(@"sf--%@",dty);
    NSString*dty=[NSString stringWithFormat:@"0x%@",responseObject[@"raw_data_hex"]];
    NSData*dtu=[SecureData hexStringToData:dty];
    dtu=[SecureData SHA256:dtu];
    
    Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[self.dappmodel.prived hasPrefix:@"0x"]?self.dappmodel.prived:[@"0x" stringByAppendingString:self.dappmodel.prived]]];
    
    Signature*dg=[accountt signDigest:dtu];
    
    SecureData *data2 = [SecureData secureDataWithCapacity:228];
    [data2  appendData:dg.r];
    [data2 appendData:dg.s];
    [data2 appendByte:dg.v];
    
    
    NSString*endStr=[SecureData dataToHexString:data2.data];
    endStr=[[endStr componentsSeparatedByString:@"0x"]lastObject];
    
    
    [dict setObject:@[endStr] forKey:@"signature"];
    
    NSString*jsondic= [Utility strData:dict];
    
    NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,%@,null);",promiseId,jsondic];
    NSLog(@"gddd---%@",evstr2);
    
    [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
    [MBProgressHUD hideHUD];
//    [self tradsuccdic:dict  prid:promiseId];
    
    
    
    
    
}
#pragma mark --广播
-(void)tradsuccdic:(NSDictionary*)dic prid:(NSString*)promiseId{
    
    NSString*url=[NSString stringWithFormat:@"%@wallet/broadcasttransaction",self.dappmodel.rpcurl];
    
    
    
    //    NSLog(@"sddic-----%@",dic);
    
    [Request POST:url  parameters:dic success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD hideHUD];
        
        NSLog(@"assss---%@",[Utility strData:responseObject]);
        NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString*rest =[NSString stringWithFormat:@"%@",responseObject[@"result"]];
        //        NSLog(@"sdd--%@",rest);
        if([ert isEqualToString:@"SIGERROR"]){
            
            //            NSString*str=[self stringFromHexString:responseObject[@"message"]];
            [MBProgressHUD showText:@"error"];
            
            return;
        }
        
        if([rest isEqualToString:@"1"]){
            
            [MBProgressHUD showText:getLocalStr(@"flsht7")];
           NSString*jsondic= [Utility strData:dic];
//            NSLog(@"json--%@",jsondic);
            
            NSString*evstr2=[NSString stringWithFormat: @"window.resolvePromise(%@,%@,null);",promiseId,jsondic];
            NSLog(@"gddd---%@",evstr2);
            
            [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    [self.userContentController removeScriptMessageHandlerForName:@"_tw_"];
    [self.userContentController removeScriptMessageHandlerForName:@"roowallet"];
    
    
}

-(void)dealloc{
    
    NSLog(@"weview销毁");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
