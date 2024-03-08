//
//  outPriKeyViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "outPriKeyViewController.h"

@interface outPriKeyViewController ()
@property(nonatomic,strong)UILabel*prLab;
@end

@implementation outPriKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.baseLab.text=getLocalStr(@"wadcsy");
    
    
    UIImageView*tsImg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(60))/2, WD_StatusHight+gdValue(82), gdValue(60), gdValue(60))];
    tsImg.image=imageName(@"prcw");
    [self.view addSubview:tsImg];
    
    UILabel*tsalb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), tsImg.bottom+gdValue(16), SCREEN_WIDTH-gdValue(20), gdValue(20))];
    tsalb.text=getLocalStr(@"wapecw");
    tsalb.font=fontNum(14);
    tsalb.textColor=UIColorFromRGB(0xFA6400);
    tsalb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tsalb];
    
    
    
    UIButton*ybView=[UIButton buttonWithType:UIButtonTypeCustom];
    ybView.frame=CGRectMake(gdValue(15), tsalb.bottom+gdValue(68), SCREEN_WIDTH-gdValue(30), gdValue(70));
    
    ViewRadius(ybView, gdValue(6));
    ybView.backgroundColor=cyColor;
    [self.view addSubview:ybView];
    
    [ybView addSubview:self.prLab];
    
    UIImageView*fzimg=[[UIImageView alloc]initWithFrame:CGRectMake(ybView.width-gdValue(38), gdValue(25), gdValue(20), gdValue(20))];
    fzimg.image=imageName(@"prfz");
    
    [ybView addSubview:fzimg];
    [ybView addTarget:self action:@selector(fzckl) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}
-(void)fzckl{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
       pab.string = self.prLab.text;
       if (pab == nil) {
         
       } else {
           [MBProgressHUD showText:getLocalStr(@"wafzcg")];
       }
}
-(UILabel*)prLab{
    if(!_prLab){
        _prLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), gdValue(15), gdValue(260), gdValue(40))];
        _prLab.text=_password;//@"0x04b399462f28d66f52f03e11b92eb406e1a9209662f28d66f52f03e11b92e";
        _prLab.font=fontNum(14);
        _prLab.textColor=ziColor;
        _prLab.numberOfLines=2;
    }
    return _prLab;
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
