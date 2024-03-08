//
//  invtfrindViewController.m
//  RooWallet
//
//  Created by mac on 2021/8/13.
//

#import "invtfrindViewController.h"

@interface invtfrindViewController ()
@property(nonatomic,strong)UIImageView*bgImg;
@property(nonatomic,strong)UIImageView*codeImg;
@property(nonatomic,strong)UIImage*shareImg;


@end

@implementation invtfrindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=getLocalStr(@"邀请好友");
    
    [self setnavUI];
    
   [self.view addSubview:self.bgImg];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.codeImg.image=[SGQRCodeManager generateQRCodeWithData:@"http://www.roo.top" size:gdValue(110) logoImage:imageName(@"mylog") ratio:0.2];
//        NSLog(@"sds----%@ %@",self.codeImg,[SGQRCodeManager generateQRCodeWithData:@"http://www.baidu.com" size:1]);
     
        self.shareImg=[self convertViewToImage:self.bgImg];

    });
    

    
    // Do any additional setup after loading the view.
}

-(void)setnavUI{
    UIButton*shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(50), kStatusBarHeight, gdValue(40), gdValue(40));
    
    [shareBtn setImage:imageName(@"s_share") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(sharek) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navHeadView addSubview:shareBtn];
}


-(UIImageView*)bgImg{
    if(!_bgImg){
        _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight)];
        _bgImg.contentMode=UIViewContentModeScaleAspectFill;
        _bgImg.clipsToBounds=YES;
        _bgImg.image=imageName(@"s_bg");
        
        
        UIImageView*himg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(273))/2, gdValue(38), gdValue(273), gdValue(73))];
        himg.image=imageName(@"s_hed");
        [_bgImg addSubview:himg];
        
        UIImageView*kimg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(130))/2, _bgImg.height-gdValue(180), gdValue(130), gdValue(130))];
        kimg.image=imageName(@"s_ma");
        [kimg addSubview:self.codeImg];
        
        [_bgImg addSubview:kimg];
        
        
        UILabel*nlab=[[UILabel alloc]initWithFrame:CGRectMake(0, kimg.bottom+gdValue(5), SCREEN_WIDTH, gdValue(20))];
        nlab.text=getLocalStr(@"扫一扫下载");
        nlab.font=fontMidNum(14);
        nlab.textColor=[UIColor whiteColor];
        
        nlab.textAlignment=NSTextAlignmentCenter;
        [_bgImg addSubview:nlab];
        
        
        
        
    }
    return _bgImg;
}

-(UIImageView*)codeImg{
    if(!_codeImg){
        _codeImg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(10), gdValue(10), gdValue(110), gdValue(110))];
//        _codeImg.image=[SGQRCodeManager generateQRCodeWithData:@"http://www.roo.top" size:gdValue(110)];
       
        
       
    }
    return _codeImg;
}


-(void)sharek{
   
    
//       NSString *textToShare1 = @"ROO Wallet";
        UIImage *imageToShare = _shareImg;
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
    
    
//    shareView*view=[[shareView alloc]initWithFrame:SCREEN_FRAME shaimg:self.shareImg];
//    [view show];
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
