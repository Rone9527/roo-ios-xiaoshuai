//
//  adminWalletViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "adminWalletViewController.h"
#import "wallDetViewController.h"
#import "AddWalletDetViewController.h"
@interface adminWalletViewController ()<UITableViewDelegate,UITableViewDataSource,wallDetDelagete>
@property(nonatomic,strong)UITableView*setTableView;


@property(nonatomic,copy)NSArray*userArr;
@end

@implementation adminWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
  
    
    self.baseLab.text=getLocalStr(@"wagiwa");
    [self setNaUI];
    
    [self loadUI];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
    _userArr=[userModel bg_findAll:bg_tablename];
    
    
    if(_userArr.count<_selindx+1){
        _selindx=0;
    }else{
        
        
        _selindx=selewalletIndex;
        
    }
    
    [self.setTableView reloadData];
}
-(void)loadUI{
    [self.view addSubview:self.setTableView];
    
}
-(void)setNaUI{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(50), WDNavHeight, gdValue(35), gdValue(25));
    [rBtn setTitle:getLocalStr(@"waddz") forState:UIControlStateNormal];
    [rBtn setTitleColor:ziColor forState:UIControlStateNormal];
    rBtn.titleLabel.font=fontBoldNum(16);
    [rBtn addTarget:self action:@selector(addwaclk) forControlEvents:UIControlEventTouchUpInside];
    [self.navHeadView addSubview:rBtn];
}

#pragma mark --添加钱包
-(void)addwaclk{
    AddWalletDetViewController *waclVc=[[AddWalletDetViewController alloc]init];
    waclVc.seleType=1;
    [self.navigationController pushViewController:waclVc animated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"addwaCellID" forIndexPath:indexPath];
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
    
    if(_userArr.count){
        
        userModel*usmdoel=_userArr[indexPath.row];
   
        
        UIView*ybgv=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(7), gdValue(4), gdValue(41))];
        ybgv.backgroundColor=mainColor;
        [cell.contentView addSubview:ybgv];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:ybgv.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(gdValue(20), gdValue(20))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame = ybgv.bounds;
               maskLayer.path = maskPath.CGPath;
        ybgv.layer.mask = maskLayer;
        ybgv.hidden=YES;
        
        
        if(_selindx==indexPath.row){
       
            ybgv.hidden=NO;
            
        }
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(300), gdValue(25))];
    tlab.text=usmdoel.name;
    tlab.font=fontNum(16);
    tlab.textColor=ziColor;
    [cell.contentView addSubview:tlab];
    
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
    seimg.image=imageName(@"dlad");
    [cell.contentView addSubview:seimg];
  
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(55)-1, SCREEN_WIDTH, 1)];
    col.backgroundColor=UIColorFromRGB(0xf5f6f7);
    [cell.contentView addSubview:col];
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(55);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    return vv;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    return vv;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    _selindx=indexPath.row;
    [self.setTableView reloadData];
    userModel*usmdoel=_userArr[indexPath.row];
    wallDetViewController*walDet=[[wallDetViewController alloc]init];
    walDet.nameStr=usmdoel.name;
    walDet.model=usmdoel;
    walDet.delagate=self;
    [self.navigationController pushViewController:walDet animated:YES];
    
   
}
-(void)getwallDetWalletName:(NSString *)name{
  
    _userArr=[userModel bg_findAll:bg_tablename];
  
    [self.setTableView reloadData];
    
}
-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xffffff);

        UIView*fotView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(80))];
        fotView.backgroundColor=[UIColor whiteColor];
        _setTableView.tableFooterView=fotView;
        
        
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addwaCellID"];
//        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
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
