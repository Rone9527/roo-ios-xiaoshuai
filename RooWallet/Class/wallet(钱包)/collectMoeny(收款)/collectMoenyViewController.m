//
//  collectMoenyViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "collectMoenyViewController.h"
#import "shareView.h"
#import "SGQRCode.h"
#import "mnenBFView.h"
#import "MnemonViewController.h"

@interface collectMoenyViewController ()
@property(nonatomic,strong)UIImageView*codeImg;
@property(nonatomic,strong)UIImageView*codeImg1;
@property(nonatomic,weak)UIView*bgv;
@property(nonatomic,strong)UILabel*addLab;
@property(nonatomic,strong)UILabel*addLab1;
@property(nonatomic,strong)UIView*sreView;
@property(nonatomic,strong)UIImage*shareImg;
@property(nonatomic,strong)mnenBFView*mnenview;

@end

@implementation collectMoenyViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    [self isbenmn];//备份助记词
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        
    } else {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sreView];
    
    self.baseLab.text=getLocalStr(@"wacloo");
    self.baseLab.textColor=[UIColor whiteColor];
    self.navHeadView.backgroundColor=[UIColor clearColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"roobackw"] forState:UIControlStateNormal];
   
  
    [self setUI];
    
    
    
    //
    dispatch_async(dispatch_get_main_queue(), ^{
    self.codeImg.image=[SGQRCodeManager generateQRCodeWithData:self.addreStr size:self.codeImg1.width];
        self.codeImg1.image=[SGQRCodeManager generateQRCodeWithData:self.addreStr size:self.codeImg1.width];
//        NSLog(@"sds----%@ %@",self.codeImg,[SGQRCodeManager generateQRCodeWithData:@"http://www.baidu.com" size:1]);
     
        self.shareImg=[self convertViewToImage:self.sreView];

    });
    
   
    
    
//    [SGQRCodeGenerateManager generateWithLogoQRCodeData:@"" logoImageName:nil logoScaleToSuperView:0.2];

    
    // Do any additional setup after loading the view.
}




-(void)isbenmn{
    
    userModel*usermodell=[userModel bg_findAll:bg_tablename][selewalletIndex];
    if(![usermodell.isbackUps isEqualToString:@"1"]){
        
        _mnenview=[[mnenBFView alloc]initWithFrame:SCREEN_FRAME];
        WeakSelf;
        _mnenview.qublock = ^{
            [weakSelf leftBarBtnClicked];
        };
        
       
        _mnenview.block = ^{

            passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];

            __block passdOCRView*passV=passView;
           
            
            passView.getpass = ^(NSString * _Nonnull str) {
        //        NSLog(@"sf--%@",str);
//                view1=view;
                if([str isEqualToString:UserPassword]){
                    //        if([str integerValue]==123456){

                    //            [weakSelf.view endEditing:YES];
                    [passV hide];
                    [weakSelf.mnenview hide];

                    MnemonViewController*mnvc=[[MnemonViewController alloc]init];
                    mnvc.mnemonics=usermodell.mnemonicPhrase;

                    [mnvc setHidesBottomBarWhenPushed:YES];
                    [weakSelf.navigationController pushViewController:mnvc animated:YES];

                }
                else{

                    [MBProgressHUD showText:getLocalStr(@"cwts1")];
                }

            };

        };
        
        [_mnenview show];
        
    }
}

-(void)setUI{
    
    
    UIView*bgr=[[UIView alloc]initWithFrame:SCREEN_FRAME];
    bgr.backgroundColor=mainColor;
    [self.view addSubview:bgr];
    
    
    self.view.backgroundColor=mainColor;
    
    
    UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(gdValue(18), WD_StatusHight+gdValue(20), SCREEN_WIDTH-gdValue(36), gdValue(512))];
    bgv.backgroundColor=[UIColor whiteColor];
    ViewRadius(bgv, gdValue(10));
    self.bgv=bgv;
    [bgr addSubview:bgv];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(50), gdValue(20), bgv.width-gdValue(100), gdValue(40))];
    if([_iconname isEqualToString:@"ETH"]){
        _iconname=@"Ethereum";
    }
    tlab.text= [NSString stringWithFormat:getLocalStr(@"collt1"),_iconnamed,_iconname] ;
    tlab.font=fontBoldNum(14);
    tlab.textColor=UIColorFromRGB(0xFFAB65);
    tlab.textAlignment=NSTextAlignmentCenter;
    tlab.numberOfLines=2;
    [bgv addSubview:tlab];
    
    [bgv addSubview:self.codeImg];
    
    UIView*fov=[[UIView alloc]initWithFrame:CGRectMake(gdValue(25), _codeImg.bottom+gdValue(20), bgv.width-gdValue(50), gdValue(100))];
    ViewRadius(fov, gdValue(6));
    fov.backgroundColor=cyColor;
    [bgv addSubview:fov];
    
    UILabel*sklab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(15), fov.width, gdValue(23))];
    sklab.text=getLocalStr(@"trawrt1");
    sklab.font=fontMidNum(16);
    sklab.textColor=zyincolor;
    sklab.textAlignment=NSTextAlignmentCenter;
    [fov addSubview:sklab];
    
//    [fov addSubview:self.addLab];
    
    UIButton*btny=[UIButton buttonWithType:UIButtonTypeCustom];
    btny.frame=CGRectMake(0, gdValue(40), fov.width, gdValue(48));
    [fov addSubview:btny];
    [btny addTarget:self action:@selector(fzck) forControlEvents:UIControlEventTouchUpInside];
    [btny addSubview:self.addLab];
    
    
    
    
    UIButton*shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake((bgv.width-gdValue(230))/2, gdValue(30)+fov.bottom, gdValue(70), gdValue(30));
    [shareBtn setTitle:getLocalStr(@"collt2") forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    shareBtn.titleLabel.font=fontMidNum(16);
    [shareBtn addTarget:self action:@selector(sharek:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:imageName(@"colect_1") forState:UIControlStateNormal];
    
    
    [shareBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(7)];
    [bgv addSubview:shareBtn];
    
    UIButton*fzBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fzBtn.frame=CGRectMake(gdValue(90)+shareBtn.right, gdValue(30)+fov.bottom, gdValue(70), gdValue(30));
    [fzBtn setTitle:getLocalStr(@"collt3") forState:UIControlStateNormal];
    [fzBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    fzBtn.titleLabel.font=fontMidNum(16);
    [fzBtn addTarget:self action:@selector(fzck) forControlEvents:UIControlEventTouchUpInside];
    [fzBtn setImage:imageName(@"colect_2") forState:UIControlStateNormal];
    
    
    [fzBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(7)];
    [bgv addSubview:fzBtn];
    
  
    UIImageView*lot=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(107))/2, SCREEN_HEIGHT-gdValue(40)-kTabbarSafeBottomMargin, gdValue(107), gdValue(19))];
    lot.image=imageName(@"colect_3");
    [bgr addSubview:lot];
    
    [self.view bringSubviewToFront:self.navHeadView];
}

-(void)sharek:(UIButton*)sender{
    
    
//    NSString *textToShare1 = @"ROO Wallet";
        UIImage *imageToShare = _shareImg;
//        NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
        NSArray *activityItems = @[imageToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

        //去除一些不需要的图标选项
//        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo];

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
    
    
//    shareView*view=[[shareView alloc]initWithFrame:SCREEN_FRAME shaimg:self.shareImg];
//    [view show];
}
-(void)fzck{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = self.addLab.text;
       if (pab == nil) {
         
       } else {
           [MBProgressHUD showText:getLocalStr(@"collt4")];
       }
}
-(UIImageView*)codeImg{
    if(!_codeImg){
        _codeImg=[[UIImageView alloc]initWithFrame:CGRectMake((_bgv.width-gdValue(230))/2, gdValue(80), gdValue(230), gdValue(230))];
        
       
    }
    return _codeImg;
}
-(UIImageView*)codeImg1{
    if(!_codeImg1){
        _codeImg1=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(240))/2, gdValue(104), gdValue(240), gdValue(240))];
       
        
    }
    return _codeImg1;
}

-(UILabel*)addLab{
    if(!_addLab){
        _addLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(18), 0, _bgv.width-gdValue(86), gdValue(48))];
        _addLab.text=_addreStr;
        _addLab.font=fontNum(16);
        _addLab.numberOfLines=2;
        _addLab.textAlignment=NSTextAlignmentCenter;
        _addLab.textColor=ziColor;
    }
    return _addLab;
}

-(UILabel*)addLab1{
    if(!_addLab1){
        _addLab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(60), gdValue(72)+_codeImg1.bottom, SCREEN_WIDTH-gdValue(120), gdValue(48))];
        _addLab1.text=_addreStr;
        _addLab1.font=fontNum(16);
        _addLab1.textAlignment=NSTextAlignmentCenter;
        _addLab1.numberOfLines=2;
        _addLab1.textColor=[UIColor whiteColor];
    }
    return _addLab1;
}

-(UIView*)sreView{
    
    if(!_sreView){
        _sreView=[[UIView alloc]initWithFrame:CGRectMake(0,(SCREEN_HEIGHT-gdValue(598))/2, SCREEN_WIDTH, gdValue(598))];
        
        _sreView.backgroundColor=UIColorFromRGB(0xffffff);
        
        UIView*bgy=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(489))];
        bgy.backgroundColor=mainColor;
        [_sreView addSubview:bgy];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgy.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(gdValue(10), gdValue(10))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame = bgy.bounds;
               maskLayer.path = maskPath.CGPath;
        bgy.layer.mask = maskLayer;
        
        UILabel*tdLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), gdValue(29), SCREEN_WIDTH-gdValue(20), gdValue(28))];
        tdLab.text=getLocalStr(@"share5");
        tdLab.textColor=[UIColor whiteColor];
        tdLab.font=fontMidNum(20);
        tdLab.textAlignment=NSTextAlignmentCenter;
        [_sreView addSubview:tdLab];
        
        UIView*vv=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(280))/2, tdLab.bottom+gdValue(27), gdValue(280), gdValue(280))];
        ViewRadius(vv, gdValue(10));
        vv.backgroundColor=[UIColor whiteColor];
        [_sreView addSubview:vv];
        
        [_sreView addSubview:self.codeImg1];
        
        UILabel*tdLabb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), gdValue(47)+_codeImg1.bottom, SCREEN_WIDTH-gdValue(20), gdValue(23))];
        tdLabb.text=getLocalStr(@"trawrt1");
        tdLabb.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
        tdLabb.font=fontMidNum(16);
        tdLabb.textAlignment=NSTextAlignmentCenter;
        [_sreView addSubview:tdLabb];
        
        [_sreView addSubview:self.addLab1];
        
        UIImageView*imgh=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(191))/2, bgy.bottom+gdValue(34), gdValue(191), gdValue(40))];
        imgh.image=imageName(@"colect_4");
        [_sreView addSubview:imgh];
        
//        _sreView.hidden=YES;
        
    }
    
    return _sreView;
    
}
- (UIImage *)convertViewToImage:(UIView *)view
{
       
        UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        return image;
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
