//
//  BaseViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "BaseViewController.h"
#import "UIViewController+HBD.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.extendedLayoutIncludesOpaqueBars = YES;
   
    self.view.backgroundColor=[UIColor whiteColor];
    self.hbd_barHidden=YES;
    self.navigationController.navigationBar.hidden=YES;
    
    [self.view addSubview:self.navHeadView];
     [self setavConfin];

    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:true animated:NO];
//}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
-(UIView*)navHeadView{
    if(!_navHeadView){
        _navHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WD_StatusHight)];
        _navHeadView.backgroundColor=UIColorFromRGB(0xFFffff);
        
    }
    return _navHeadView;
}
-(UILabel*)baseLab{
    if(!_baseLab){
        _baseLab=[[UILabel alloc]initWithFrame:CGRectMake(55,WDNavHeight, SCREEN_WIDTH-110,gdValue(25))];
        
        _baseLab.textAlignment=NSTextAlignmentCenter;
        _baseLab.font=fontBoldNum(17);
//        if(IS_iPad){
//            _baseLab.frame =CGRectMake(55,gdValue(10), SCREEN_WIDTH-110,gdValue(20));
//        }
        _baseLab.textColor=ziColor;

    }
    return  _baseLab;
}

-(void)setavConfin{

    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(gdValue(10), WDNavHeight-2, gdValue(40),gdValue(30));
//    _leftBtn.backgroundColor=[UIColor redColor];
//    if(IS_iPad){
//        _leftBtn.frame = CGRectMake(gdValue(20), gdValue(10), gdValue(40),gdValue(30));
//    }
    [_leftBtn setImage:[UIImage imageNamed:@"rooback"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
//    _leftBtn.backgroundColor=[UIColor  redColor];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(SCREEN_WIDTH-80, WDNavHeight, 80,gdValue(30));
//    if(IS_iPad){
//        _rightBtn.frame = CGRectMake(SCREEN_WIDTH-gdValue(80), gdValue(10),gdValue(80),gdValue(30));
//    }
    [_rightBtn addTarget:self action:@selector(rightBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font=fontNum(15);
    _rightBtn.hidden=YES;

    [self.navHeadView addSubview:_leftBtn];
    [self.navHeadView addSubview:self.baseLab];
    [self.navHeadView addSubview:_rightBtn];
   
    

    
}
-(void)rightBarBtnClicked{
    
}
-(void)dealloc{
    NSLog(@"vc___-hui");
}
-(void)leftBarBtnClicked{
   
    [self.navigationController popViewControllerAnimated:YES];
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
