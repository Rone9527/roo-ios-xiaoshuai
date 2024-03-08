//
//  swapViewController.m
//  RooWallet
//
//  Created by mac on 2021/7/20.
//

#import "swapViewController.h"
#import  <WebKit/WebKit.h>
#import "actShootView.h"
#import "tranQDView.h"
#import "TraGasmodel.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import <ethers/ethers.h>
#import "walletNodesModel.h"
#import "authorSecdView.h"
#import "seleUpwalletView.h"
#import "dappswapView.h"
#import "dapperrView.h"
#import "dappTradView.h"


@interface swapViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)dapptyModel*dappmodel;
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


@property(nonatomic,copy)NSString*Tradidstr;


@end

@implementation swapViewController

-(WKUserContentController*)userContentController{
    if(!_userContentController){
        
        _userContentController = [[WKUserContentController alloc] init];

        NSString*bundlePath=[[NSBundle mainBundle]pathForResource:@"trust-min" ofType:@"js"];
//roo_min  web3.min trust-min  AlphaWallet-min
        
        
        _providerJsUrl=[NSURL fileURLWithPath:bundlePath];;
        NSError*err=nil;
        
        NSString*source=[NSString stringWithContentsOfURL:_providerJsUrl encoding:NSUTF8StringEncoding error:&err];
        
        //RooWallet Trust
        
       
        NSString*scrt=[NSString stringWithFormat:  @"(function(){var config = {address: \"%@\".toLowerCase(),chainId: %ld,rpcUrl:\"%@\"};const provider = new window.Trust(config); window.ethereum = provider;window.web3 = new window.Web3(provider);window.web3.eth.defaultAccount = config.address;window.chrome = {webstore: {}}; })();",self.dappmodel.addres.description,[self.dappmodel.idstr integerValue],self.dappmodel.rpcurl];
        
        
        _providerScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        
        _injectedScript=[[WKUserScript alloc]initWithSource:scrt injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        
        
      
    
        [_userContentController addUserScript:_providerScript];
        [_userContentController addUserScript:_injectedScript];
        
//        [_userContentController addUserScript:_providerScript3];
       
//
       
        
       // signTransaction  TransactionByHash
        NSArray*wer=@[@"signTransaction",@"signTypedMessage",@"signPersonalMessage",@"signMessage",@"requestAccounts"];
        for(NSString *str in wer){
            [_userContentController addScriptMessageHandler:self  name:str];
        
        }
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
        
    }
    return _webView;
}
-(void)getprof{
    if([self.dappmodel.chain isEqualToString:@"ETH"]){
        _code=@"ETH";
        
    }
    else if ([self.dappmodel.chain isEqualToString:@"BSC"]){
        _code=@"BNB";
    }
    else if ([self.dappmodel.chain isEqualToString:@"HECO"]){
        _code=@"HT";
    }
    
    NSLog(@"sdd--%@   dd0-----%@",self.dappmodel.chain,_code);
    
    [self getSymPerice:_code];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
   
//    NSLog(@"主链--%@",self.dappmodel.chain);
    self.baseLab.text=getLocalStr(@"wafcan");
    
    
    self.dappmodel=[self getDAPPModelcina:_nameStr];

    [self getprof];

    [self getGasData];
    
    self.view.backgroundColor=viewColor;
    [self uiConfing];
    
    [self loadNaui];
    
   

    
    // Do any additional setup after loading the view.
}
-(void)loadNaui{
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(75), WDNavHeight, gdValue(60), gdValue(25));
//    [rBtn setImage:imageName(@"dadet") forState:UIControlStateNormal];
    [rBtn setTitle:getLocalStr(@"钱包") forState:UIControlStateNormal];
    [rBtn setTitleColor:mainColor forState:UIControlStateNormal];
    rBtn.titleLabel.font=fontNum(15);
    [self.navHeadView addSubview:rBtn];
    [rBtn addTarget:self action:@selector(dpclk) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --选择钱包
-(void)dpclk{
    WeakSelf;
    dappswapView*view=[[dappswapView alloc]initWithFrame:SCREEN_FRAME seleindx:weakSelf.sendlx];
    view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
        weakSelf.sendlx=indx;
        
        weakSelf.dappmodel=[weakSelf getDAPPModelcina:nameStr];
//        NSLog(@"sssssss---%@",weakSelf.dappmodel.links);
        
        [weakSelf loadData];
    };
    
}

-(void)loadData{
    
    [self getprof];

    [self getGasData];
    NSString*bundlePath=[[NSBundle mainBundle]pathForResource:@"trust-min" ofType:@"js"];
//roo_min  web3.min trust-min  AlphaWallet-min
    
    
    NSURL*providerJsUrl=[NSURL fileURLWithPath:bundlePath];;
    NSError*err=nil;
    
    NSString*source=[NSString stringWithContentsOfURL:providerJsUrl encoding:NSUTF8StringEncoding error:&err];
    
    NSString*scrt=[NSString stringWithFormat:  @"(function(){var config = {address: \"%@\".toLowerCase(),chainId: %ld,rpcUrl:\"%@\"};const provider = new window.Trust(config); window.ethereum = provider;window.web3 = new window.Web3(provider);window.web3.eth.defaultAccount = config.address;window.chrome = {webstore: {}}; })();",self.dappmodel.addres.description,[self.dappmodel.idstr integerValue],self.dappmodel.rpcurl];
    
//    NSLog(@"sduuu---%@  %@  %@",self.dappmodel.addres,self.dappmodel.idstr,self.dappmodel.rpcurl);
    
//    _providerScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    WKUserScript*injectedScriptt=[[WKUserScript alloc]initWithSource:scrt injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    WKUserScript*providerScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
//
    [self.userContentController addUserScript:providerScript];
    
    [self.userContentController addUserScript:injectedScriptt];
 
    
    self.wkConfig.userContentController=self.userContentController;
    
    
    
//    NSLog(@"url----%@",self.dappmodel.links);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dappmodel.links]];
//
    _webView=nil;
////    self.webView.UIDelegate=nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeFromSuperview];
////    self.webView
    [self.view addSubview:self.webView];
  
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//
//
  [self.webView loadRequest:request];
   
    [self.webView evaluateJavaScript:scrt completionHandler:nil];
    
}
-(dapptyModel*)getDAPPModelcina:(NSString*)chain{
    
    dapptyModel*model=[[dapptyModel alloc]init];
    model.chain=chain;
//    model.links=@"https://paraswap.io/#/?network=ethereum";
    
    model.name=@"paraswap";
    model=[self setmodelValue:model];
//    NSLog(@"s---%@   ll--%@",model.name,model.links);
    
    return model;
//    model.links=
}

-(dapptyModel*)setmodelValue:(dapptyModel*)model{
    userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    if([model.chain isEqualToString:@"ETH"]){
        model.idstr=@"1";
       
       
        for(walletModel*wamodel in usModel.walletArray){
         
            if( [wamodel.name isEqualToString:@"ETH"]){
                model.addres=wamodel.addres;
                model.prived=wamodel.password;
               
                walletNodesModel*nodmol=wamodel.nodesArray[0];
                model.rpcurl=nodmol.rpcUrl;
                model.browserUrl=nodmol.browserUrl;
                model.links=@"https://paraswap.io/#/?network=ethereum";
                break;
            }
            
            
        }
        
        
    }
  else  if([model.chain isEqualToString:@"BSC"]){
        model.idstr=@"56";
      for(walletModel*wamodel in usModel.walletArray){


          if( [wamodel.name isEqualToString:@"BSC"]){
              model.addres=wamodel.addres;
              model.prived=wamodel.password;
              walletNodesModel*nodmol=wamodel.nodesArray[0];
              model.rpcurl=nodmol.rpcUrl;
              model.browserUrl=nodmol.browserUrl;
              model.links=@"https://paraswap.io/#/?network=bsc";
              break;
          }

         
      }
    }
   else if([model.chain isEqualToString:@"HECO"]){
        model.idstr=@"128";
       
       for(walletModel*wamodel in usModel.walletArray){
           
           if( [wamodel.name isEqualToString:@"HECO"]){
               model.addres=wamodel.addres;
               model.prived=wamodel.password;
               walletNodesModel*nodmol=wamodel.nodesArray[0];
               model.rpcurl=nodmol.rpcUrl;
               model.browserUrl=nodmol.browserUrl;
               model.links=@"https://paraswap.io/#/?network=heco";
               break;
           }

          
       }
    }
    
    return model;
}


-(NSDictionary*)returnDictionaryWithDataPath:(NSData*)data
{
    NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    
    return jsonDict;
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
    

//
//      NSString*wurl=[@"https://paraswap.io/#/?network=ethereum" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"dddd---%@",_url);
    
    
//    NSLog(@"url  ---%@",self.dappmodel.links);
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
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
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
    
//    self.baseLab.text=self.webView.title;
//    if([Utility isBlankString:self.webView.title]){
//        self.baseLab.text=self.dappmodel.name;
//    }
   
    
}

//-(void)sif{
//    NSDictionary*fg=@{@"1":@"2",@"3":@"4"};
//    NSData*dd=[self compactFormatDataForDictionary:fg];
//    NSData *digest = [SecureData KECCAK256:[RLPSerialization dataWithObject:dd error:nil]];
//    NSDictionary*dic=@{@"method":@"eth_sign",@"params":@[_address,[SecureData dataToHexString:digest]],@"id":@"824"};
//    [Request POST:_rpcUrl parameters:dic success:^(id  _Nonnull responseObject) {
//        NSLog(@"sdsdsdsd----%@",[Utility strData:responseObject]);
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
//}

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


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSLog(@"mesgname--------------------------------------------------%@",message.name);
    NSLog(@"dic===%@",message.body);
    if([message.name isEqualToString:@"requestAccounts"]){//调取钱包
        
        NSDictionary*dic=message.body;
        NSString*idstr=[NSString stringWithFormat:@"%@", dic[@"id"]];
        
        
        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.setAddress(\"%@\");",self.dappmodel.addres];
//        NSLog(@"sd1--%@",evstr);
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@, [\"%@\"])", idstr,self.dappmodel.addres];
//        NSLog(@"sd2--%@",evstr2);
        [self.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [self.webView evaluateJavaScript:evstr2 completionHandler:nil];
        
        
    }
   
    else if ([message.name isEqualToString:@"signTransaction"]){//交易
       
        NSDictionary*dicc=message.body;
        self.Tradidstr=[NSString stringWithFormat:@"%@", dicc[@"id"]];
        
        NSDictionary*dict=message.body[@"object"];
        
        NSString*dataStr=[NSString stringWithFormat:@"%@",dict[@"data"]];
        
        
        if([Utility isBlankString:self.gasprice]){
            [self getGasData];
            
            [MBProgressHUD showText:getLocalStr(@"flsht22")];
            return;;
        }

        if([dataStr  hasSuffix:@"fffffffffffffffffffffffffffffffffffffffffffffffffffffff"]){//授权
            [self shouquan:dict];
            
            
        }
        else{//交易
            
            [self tradndic:dict];
            
        }
        

       
    }
        
       
       
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
    
    double nump=[gast doubleValue]*[_gasprice doubleValue];
    nump=nump/pow(10, 9);

    NSString*numStr=[NSString stringWithFormat:@"%f",nump];

    NSString*outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
//    NSLog(@"sd1---%@",_outNumber);

    outNumber = [Utility removeFloatAllZero:outNumber];
//    NSLog(@"sd2---%@",_outNumber);

    NSString*kef=[NSString stringWithFormat:@"%@ %@",outNumber,_code];
//        NSLog(@"sddddd----%@  f---%@ dddd---%@",kef,_gasprice,numStr);
    
    
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
           
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", weakSelf.Tradidstr,@"error"];
        NSLog(@"sd2--%@",evstr2);
//        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
    };
          [view show];
}

#pragma mark  发起交易
-(void)tradndic:(NSDictionary*)dict{
    NSString*value=[NSString stringWithFormat:@"%@",dict[@"value"]];
    
//    NSData*dta=[NSData dataWithData:dict[@"data"]];
    NSString*dataStr=[NSString stringWithFormat:@"%@",dict[@"data"]];
    
    value=[NSString stringWithFormat:@"%.10f" ,  strtoul(value.UTF8String, 0, 16)/ pow(10,18)];
    
   value= [Utility douVale:value num:8];//主币最大8位，到时在配
    
    value = [Utility removeFloatAllZero:value];
    
    NSString*toaddtrs=[NSString stringWithFormat:@"%@",dict[@"to"]];
    
    
    NSString*gast=[NSString stringWithFormat:@"%@",dict[@"gas"]];//limst
    gast=[NSString stringWithFormat:@"%lu",strtoul(gast.UTF8String, 0, 16)];
    
    double nump=[gast doubleValue]*[_gasprice doubleValue];
    nump=nump/pow(10, 9);

    NSString*numStr=[NSString stringWithFormat:@"%f",nump];

    NSString*outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
//    NSLog(@"sd1---%@",_outNumber);

    outNumber = [Utility removeFloatAllZero:outNumber];
//    NSLog(@"sd2---%@",_outNumber);

    NSString*kef=[NSString stringWithFormat:@"%@ %@ ≈ %@",outNumber,_code,[self getALLPrice:numStr]];
//        NSLog(@"sddddd----%@  f---%@ dddd---%@",value,_gasprice,gast);
    
    
//    NSArray*arr=@[value,self.dappmodel.addres,toaddtrs,kef];
    NSArray*arr=@[value,self.dappmodel.addres,toaddtrs,kef,self.dappmodel.name,self.dappmodel.links,_code,gast,self.dappmodel.chain,self.gasprice,self.codeprice,self.codeDecimals];
    
    dappTradView*qdView=[[dappTradView alloc]initWithFrame:SCREEN_FRAME  arr:arr comin:self.dappmodel.icon];
    [qdView show];
    
    
//    tranQDView*qdView=[[tranQDView alloc]initWithFrame:SCREEN_FRAME  arr:arr comin:@""];
//    [qdView show];
    
    WeakSelf;
    qdView.qublock = ^{
        NSLog(@"取消");
//        NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",@""];
           
        NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", weakSelf.Tradidstr,@"error"];
        NSLog(@"sd2--%@",evstr2);
//        [weakSelf.webView evaluateJavaScript:evstr completionHandler:nil];
        
        [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
    };
    
    qdView.getselectIndx = ^(NSString * _Nonnull gaspr, NSString * _Nonnull gaslomt) {
        
        passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
        
        __block passdOCRView*passV=passView;
        passView.getpass = ^(NSString * _Nonnull str) {
            NSLog(@"sf--%@  %@",str,UserPassword);
            
            if([str isEqualToString:UserPassword]){
                [passV hide];
//                    [weakSelf travdf];
                
                [MBProgressHUD showHUD];
//                    NSLog(@"valu====%@",value);
              

                NSLog(@"sd----%@  f----%@",gaspr,gaslomt);
//                if([Utility isBlankString:gaspr]){
//                    gaspr=weakSelf.gasprice;
//                }
//
//                if([Utility isBlankString:gaslomt]){
//                    gaslomt=gast;
//                }
//
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
        //        NSLog(@"data---%@",[Utility strData:responseObject]);
        
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
-(void)getGasData{
    
    NSDictionary*dic=@{@"chain":self.dappmodel.chain};
    
        NSLog(@"dic--%@",dic);
    [Request GET:getGasAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//        NSLog(@"ddd-f-%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            TraGasmodel*gasmodel=[TraGasmodel mj_objectWithKeyValues:responseObject[@"data"]];
            self.gasprice=gasmodel.proposeGasPrice;

            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        [self getGasData];
        
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
                 
                 NSDictionary*dicc=@{@"method":@"eth_getTransactionCount",@"params":@[weakSelf.dappmodel.addres,@"latest"],@"id":@"824"};
                 
                 // 获取交易次数
                 [Request POSTT:weakSelf.dappmodel.rpcurl parameters:dicc success:^(id  _Nonnull responseObject) {
     //                NSLog(@"交易次数--%@",[Utility strData:responseObject]);
                     NSString*rt=responseObject[@"result"];
                     rt=[NSString stringWithFormat:@"%lu",strtoul(rt.UTF8String, 0, 16)];
                     
                     
                     transaction.nonce = [rt integerValue];
                     
//                     transaction.gasPrice = [[BigNumber bigNumberWithDecimalString:gasPrice] mul:[BigNumber bigNumberWithDecimalString:@"1000000000"]];
//
                     NSString*newgasPrice=[NSString stringWithFormat:@"%ld",(NSInteger)([gasPrice doubleValue]*1000000000)];
                     
                     transaction.gasPrice =[BigNumber bigNumberWithDecimalString:newgasPrice];
                     
                     
//                     NSString*
                     transaction.chainId =ChainIdHomestead;
                     
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
             });
            
             
             return;
         }
         else{
             NSString*ret=[NSString stringWithFormat:@"%@",responseObject[@"result"]];

            
          
             NSString*evstr=[NSString stringWithFormat:@"window.ethereum.getTransactionReceipt(\"%@\");",ret];
                
             NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendResponse(%@, [\"%@\"])", self.Tradidstr,ret];
             NSLog(@"sd2--%@",evstr2);
             [self.webView evaluateJavaScript:evstr completionHandler:nil];
             
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
    
    NSDictionary*dic=@{@"jsonrpc":@"2.0",@"method": @"eth_getTransactionReceipt", @"id":@"274",@"params": @[ret]};
    
    
    [Request POST:self.dappmodel.rpcurl parameters:dic success:^(id  _Nonnull responseObject) {
//        NSLog(@"ret----%@",[Utility strData:responseObject]);
        
        NSDictionary*dif=responseObject[@"result"];
        if(dif.count){
        NSString*sts=[NSString stringWithFormat:@"%@",responseObject[@"result"][@"status"]];
        if([sts isEqualToString:@"0x1"]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSLog(@"3秒后执行这个方法");
                [MBProgressHUD showText:getLocalStr(@"交易成功")];
//                [self.webView reload];
            });
           
            
        }
        else{
//            NSLog(@"sbei------");
            NSString*evstr2=[NSString stringWithFormat:@"window.ethereum.sendError(%@, [\"%@\"])", self.Tradidstr,@"error"];
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

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [Request quReaqt];
    NSArray*wer=@[@"signTransaction",@"signTypedMessage",@"signPersonalMessage",@"signMessage",@"requestAccounts"];
    for(NSString *str in wer){
        [self.userContentController removeScriptMessageHandlerForName:str];
    }
}
-(void)dealloc{
 
    NSLog(@"weview销毁");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
 
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
