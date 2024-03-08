//
//  h5ViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/24.
//

#import "h5ViewController.h"
#import  <WebKit/WebKit.h>
#import "actShootView.h"
@interface h5ViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView*webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property(nonatomic,strong)UIButton*gbtn;
@property(nonatomic,strong)UIButton*shareBtn;
@property(nonatomic,strong)UIImage*shareImg;
@property(nonatomic,copy)NSString*contUrl;

@property(nonatomic,assign)NSInteger urlType;//0邀请好友，1兑换记录，2 盲盒记录

@end

@implementation h5ViewController

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}


-(WKWebView*)webView{
    if(!_webView){
        _webView=[[WKWebView alloc]initWithFrame:CGRectMake(0,WD_StatusHight,SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) configuration:self.wkConfig];
        
        //        _webView.navigationDelegate=self;
        //        _webView.scrollView.delegate=self;
        //        [_webView setScalesPageToFit:YES];
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        _webView.backgroundColor=viewColor;
        _webView.scrollView.bounces=NO;
        _webView.UIDelegate=self;
        _webView.navigationDelegate=self;
    }
    return _webView;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.baseLab.frame=CGRectMake(80, WDNavHeight, SCREEN_WIDTH-160,gdValue(25));
    
    self.view.backgroundColor=viewColor;
    [self uiConfing];
    
    [self.navHeadView addSubview:self.gbtn];
    [self setnavUI];
    
    if(_type==3){
        [self setNavUI];
        
    }
    
    self.webView.translatesAutoresizingMaskIntoConstraints=NO;
//    
//    NSString*wurl=[_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
   
     [self.webView loadRequest:request];
//        self.rightBtn.hidden=NO;
//          [self.rightBtn setImage:HH_IMAGE(@"hc_pub_fxtb") forState:UIControlStateNormal];
  
    // Do any additional setup after loading the view.
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
    
    [self.view addSubview:self.webView];
}
//-(NSString*)htmlStr1:(NSString*)html{
//    NSString *head = @"<style type=\"text/css\"> img {width:100%;height:auto;}body {margin-right:15px;margin-left:15px;margin-top:15px;font-size:45px;}</style>";
//    NSString*htl=[NSString stringWithFormat:@"<html>%@<body>%@</body></html>",head,html];
//
//    return htl;
//
//}

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
    else  if ([keyPath isEqualToString:@"title"]) {
        
        if(self.type ==2){
            self.baseLab.text=self.webView.title;
            
            if([self.webView.title isEqualToString:@"邀请好友"]){
                [_shareBtn setImage:imageName(@"s_share") forState:UIControlStateNormal];
               
                _urlType=0;
                [self  shareUI:NO];
            }
            
            else if ([self.webView.title isEqualToString:@"奖品兑换"]){
               
                [_shareBtn setImage:imageName(@"s_lidt") forState:UIControlStateNormal];
                _urlType=1;
                [self  shareUI:NO];
            }
            else if ([self.webView.title isEqualToString:@"盲盒抽奖"]){
               
                [_shareBtn setImage:imageName(@"s_lidt") forState:UIControlStateNormal];
                _urlType=2;
                [self  shareUI:NO];
            }
            
            else{
                [self  shareUI:YES];
            }
            
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
    
    self.contUrl=webView.URL.absoluteString;
    
//    if(kStringIsEmpty(_titStr)){
    NSLog(@"title----%@",self.contUrl);
    self.baseLab.text=self.webView.title;
//    }
    
    
    
}

#pragma mark --监听
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL*urlStr=navigationAction.request.URL;
    NSString*schme=[urlStr absoluteString];
    NSLog(@"s---%@ g--%@",urlStr,schme);

    if([schme  hasPrefix:@"roowalletbridge://js.keyboard.up.security"]){//调用密码
       
        WeakSelf;
        passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
        __block   passdOCRView*passV=passView;
        passView.getpass = ^(NSString * _Nonnull str) {
            
            if([str isEqualToString:UserPassword]){
 
                [passV hide];
           
                NSString*hstr=[NSString stringWithFormat:@"{success:'%@'}",[Utility getNowTimeTimestamp]];
                NSString*evstr2=[NSString stringWithFormat:@"native(%@)",hstr];
            
                [weakSelf.webView evaluateJavaScript:evstr2 completionHandler:nil];
           
            }
            else{
                [MBProgressHUD showText:getLocalStr(@"cwts1")];
            }
           
        };
        

         decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([schme  hasPrefix:@"roowalletbridge://js.save.photo.wechat"]){//截屏保存
            
        dispatch_async(dispatch_get_main_queue(), ^{
        self.shareImg=[self convertViewToImage:self.webView];
        
        UIImageWriteToSavedPhotosAlbum(self.shareImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        });
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }
    
    else{
        
        NSLog(@"sdsds---%@",navigationAction.targetFrame);
        
        if(navigationAction.targetFrame ==nil) {
            [webView loadRequest:navigationAction.request];

            }
        decisionHandler(WKNavigationActionPolicyAllow);
    }


}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    
  WKFrameInfo *frameInfo = navigationAction.targetFrame;
//    NSLog(@"sdsds2---%@",navigationAction.targetFrame);
    if(![frameInfo isMainFrame]) {
       
          [webView loadRequest:navigationAction.request];

    }
    
    return nil;
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    [MBProgressHUD showText:msg];
        
    });
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    
    
}
-(void)dealloc{
 
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}

-(void)leftBarBtnClickedd{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)leftBarBtnClicked{
    
    if(_type==1){
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else{
       
        if([self.webView canGoBack]){
            [self.webView goBack];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void)shareUI:(BOOL)ishid{
    
    
        _shareBtn.hidden=ishid;
        
    
    
}
-(void)setnavUI{
    _shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(50), kStatusBarHeight, gdValue(40), gdValue(40));
    
  
    
    [_shareBtn addTarget:self action:@selector(sharek) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.hidden=YES;
    [self.navHeadView addSubview:_shareBtn];
}

#pragma mark --更多点击
-(void)sharek{
    
    if(_urlType==0){//分享
    dispatch_async(dispatch_get_main_queue(), ^{
     
     
        self.shareImg=[self convertViewToImage:self.webView];
        
        UIImage *imageToShare = self.shareImg;
//        NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
        NSArray *activityItems = @[imageToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

        //去除一些不需要的图标选项
//        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo];

        //成功失败的回调block
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {

            if (completed){
                NSLog(@"completed1");
            }else{
                NSLog(@"canceled2");
            }
       };
       activityVC.completionWithItemsHandler = myBlock;

        [self presentViewController:activityVC animated:YES completion:nil];

    });
 
    }
    else if(_urlType==1){//兑换记录
        
        NSString*url=[NSString stringWithFormat:@"https://wap.roo.top/invation-active/redeem-history/?chainCode=bsc&address=%@&platform=ios",_addtrse];
        
        NSString*wurl=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
           NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wurl]];
       
         [self.webView loadRequest:request];
        
    }
    else if(_urlType==2){//盲盒记录
        
        NSString*url=[NSString stringWithFormat:@"https://wap.roo.top/invation-active/history?type=lottery&platform=ios"];
        
        NSString*wurl=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
           NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wurl]];
       
         [self.webView loadRequest:request];
        
    }
}

- (UIImage *)convertViewToImage:(UIView *)view
{
       
        UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    
 
        return image;
    }

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
      
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
          
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
          
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
          
    }
}
-(void)setNavUI{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(36), WDNavHeight, gdValue(25), gdValue(25));
    [rBtn setImage:imageName(@"dadet") forState:UIControlStateNormal];
    [self.navHeadView addSubview:rBtn];
    [rBtn addTarget:self action:@selector(detpclk) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark --banner更多
-(void)detpclk{
    
 
    NSArray*art=@[@"adm6",@"adm7",@"adm8",@"waqux"];
    

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
            
           
            if(![Utility isBlankString:weakSelf.contUrl]){
                pab.string =weakSelf.contUrl;
            }
            else{
                pab.string = weakSelf.url;
            }
               
               if (pab == nil) {
                 
               } else {
                   [MBProgressHUD showText:getLocalStr(@"flsht21")];
               }
            
        }
        else if(indx==2){//分享
            [weakSelf share];
            
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
            url = self.url;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
