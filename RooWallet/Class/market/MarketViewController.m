//
//  MarketViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "MarketViewController.h"
#import "marketView.h"

#import "conductView.h"
#import "defiMarkView.h"
#import "defiSearViewController.h"
@interface MarketViewController ()

@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)marketView*makView;

@property(nonatomic,strong)NSMutableArray*btnArr;

@property(nonatomic,strong)conductView*condView;//理财
@property(nonatomic,strong)defiMarkView*defiView;//difi

@property(nonatomic,strong)UIButton*serBtn;


@end

@implementation MarketViewController


-(NSMutableArray*)btnArr{
    if(!_btnArr){
        _btnArr=[NSMutableArray array];
    }
    return _btnArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray*titrr=@[getLocalStr(@"wark1"),getLocalStr(@"wark5"),@"DeFi"];//getLocalStr(@"wafcan")
    
    for(int i=0;i<titrr.count;i++){
        
        UIButton*sebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sebtn.frame=CGRectMake(gdValue(15)+gdValue(70)*i, WDNavHeight, gdValue(50), gdValue(30));
        [sebtn setTitle:titrr[i] forState:UIControlStateNormal];
        [sebtn setTitleColor:UIColorFromRGB(0x666666)  forState:UIControlStateNormal];
        [sebtn setTitleColor:ziColor forState:UIControlStateSelected];
        sebtn.titleLabel.font=fontMidNum(17);
        sebtn.tag=1008+i;
        if(i==0){
            sebtn.selected=YES;
            sebtn.titleLabel.font=fontBoldNum(22);
        }
        [self.btnArr addObject:sebtn];
        [sebtn addTarget:self action:@selector(djik:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headView addSubview:sebtn];
        
        
    }
   
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.makView];
    [self.view addSubview:self.serBtn];
    

    [self.view addSubview:self.condView];
    [self.view addSubview:self.defiView];
            

     
  
//    [self.view addSubview:self.cachView];
//    [self.view addSubview:self.listView];
    
    // Do any additional setup after loading the view.
}

-(void)djik:(UIButton*)sender{
    
    
//    sender.selected=!sender.selected;
    
    if(sender.tag==1008){
        self.makView.hidden=NO;
//        self.cachView.hidden=YES;
//        self.listView.hidden=YES;
        self.condView.hidden=YES;
        self.defiView.hidden=YES;
        self.serBtn.hidden=YES;
    }
//    else if (sender.tag==1009){
//        self.makView.hidden=YES;
//        self.cachView.hidden=NO;
//        self.listView.hidden=NO;
//        self.condView.hidden=YES;
//    }
    else if(sender.tag==1009){
        self.makView.hidden=YES;
//        self.cachView.hidden=YES;
//        self.listView.hidden=YES;
        self.condView.hidden=NO;
        self.defiView.hidden=YES;
        self.serBtn.hidden=YES;
        [self.condView qiuData];
    }
    else{
        self.makView.hidden=YES;
//        self.cachView.hidden=YES;
//        self.listView.hidden=YES;
        self.condView.hidden=YES;
        self.defiView.hidden=NO;
        [self.defiView qiuData];
        self.serBtn.hidden=NO;

    }
    
    
    
    for(UIButton*btn in self.btnArr){
        
        if(btn.tag==sender.tag){
            
            
            btn.selected=YES;
            btn.titleLabel.font=fontBoldNum(22);
            
        }
        else{
            btn.selected=NO;
            btn.titleLabel.font=fontMidNum(17);
        }
    }
    
}

#pragma mark --defi搜索
-(void)sckdefi{
    defiSearViewController*defiVC=[[defiSearViewController alloc]init];
    [defiVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:defiVC animated:YES];
    
}

-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WDNavHeight+gdValue(40))];
        _headView.backgroundColor=[UIColor whiteColor];
    }
    return _headView;
}
-(marketView*)makView{
    if(!_makView){
        _makView=[[marketView alloc]initWithFrame:CGRectMake(0, _headView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_headView.bottom-WD_TabBarHeight)];
       
    
        
    }
    return _makView;
}
-(UIButton*)serBtn{
    if(!_serBtn){
        _serBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _serBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45), WDNavHeight, gdValue(30), gdValue(30));
        [_serBtn setImage:imageName(@"defiser") forState:UIControlStateNormal];
        _serBtn.hidden=YES;
        [_serBtn addTarget:self action:@selector(sckdefi) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _serBtn;
}

-(conductView*)condView{
    if(!_condView){
        _condView=[[conductView alloc]initWithFrame:_makView.frame];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_condView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(15), gdValue(15))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame = _condView.bounds;
               maskLayer.path = maskPath.CGPath;
        _condView.layer.mask = maskLayer;
        _condView.hidden=YES;
        
    }
    return _condView;
}

-(defiMarkView*)defiView{
    if(!_defiView){
        _defiView=[[defiMarkView alloc]initWithFrame:_makView.frame];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_defiView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(15), gdValue(15))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame =_defiView.bounds;
               maskLayer.path = maskPath.CGPath;
        _defiView.layer.mask = maskLayer;
        _defiView.hidden=YES;
    }
    
    return _defiView;
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
