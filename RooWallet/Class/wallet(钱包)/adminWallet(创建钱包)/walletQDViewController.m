//
//  walletQDViewController.m
//  RooWallet
//
//  Created by mac on 2021/8/5.
//

#import "walletQDViewController.h"
#import "MnemonViewController.h"



@interface walletQDViewController ()

@end

@implementation walletQDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHeadView.hidden=YES;
    
    UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(60))/2, WD_StatusHight+gdValue(20), gdValue(60), gdValue(60))];
    log.image=imageName(@"zt_1");
    [self.view addSubview:log];
    
    UILabel*nalab=[[UILabel alloc]initWithFrame:CGRectMake(0, log.bottom+gdValue(10), SCREEN_WIDTH, gdValue(23))];
    nalab.text=getLocalStr(@"创建成功");
    nalab.textColor=ziColor;
    nalab.font=fontBoldNum(16);
    nalab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:nalab];
    
    //
    
    UILabel*nalabb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(35), log.bottom+gdValue(200), SCREEN_WIDTH-gdValue(70), gdValue(50))];
    nalabb.text=getLocalStr(@"助记词即私钥，请立即备份助记词，它是恢 复资产的唯一方式");
    nalabb.numberOfLines=2;
    nalabb.textColor=ziColor;
    nalabb.font=fontNum(16);
    nalabb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:nalabb];
    
    
    UIButton*qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    qdBtn.frame=CGRectMake(gdValue(35), nalabb.bottom+gdValue(60), SCREEN_WIDTH-gdValue(70), gdValue(50));
    ViewRadius(qdBtn, gdValue(8));
   
    qdBtn.backgroundColor=mainColor;
    [qdBtn setTitle:getLocalStr(@"立即备份") forState:UIControlStateNormal];
    qdBtn.titleLabel.font=fontNum(16);
    [qdBtn addTarget:self action:@selector(wqdCk) forControlEvents:UIControlEventTouchUpInside];
    [qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:qdBtn];
    
    
    UIButton*xhBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    xhBtn.frame=CGRectMake((SCREEN_WIDTH-gdValue(80))/2, qdBtn.bottom+gdValue(30), gdValue(80), gdValue(30));
    
   
    xhBtn.backgroundColor=[UIColor whiteColor];
    [xhBtn setTitle:getLocalStr(@"waxhbf") forState:UIControlStateNormal];
    xhBtn.titleLabel.font=fontBoldNum(16);
    [xhBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [xhBtn addTarget:self  action:@selector(wxhbeifen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xhBtn];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
          self.navigationController.interactivePopGestureRecognizer.enabled = NO;
      }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
           self.navigationController.interactivePopGestureRecognizer.enabled = YES;
       }
}

#pragma mark 验证
-(void)wqdCk{
    
    MnemonViewController*mnVc=[[MnemonViewController alloc]init];
    mnVc.mnemonics=_mnemonicPhrase;
    mnVc.type=1;
    
    WeakSelf;
    mnVc.block = ^(NSString * _Nullable blockStr) {
        
        if(weakSelf.block){
            weakSelf.block(blockStr);
            
        }
    };
    
    
    [self.navigationController pushViewController:mnVc animated:YES];
}
#pragma mark --稍后备份
-(void)wxhbeifen{

        
    if(self.block){
        self.block(@"0");
        
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
