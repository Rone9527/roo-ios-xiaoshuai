//
//  defiDetXqViewController.m
//  RooWallet
//
//  Created by mac on 2021/8/7.
//

#import "defiDetXqViewController.h"
#import "defiDetTableViewCell.h"
#import "defiXQView.h"
#import "defiPoolView.h"
#import "defiSedView.h"
#import "defiKLineView.h"
#import "defiDetModel.h"
#import "defiJYModel.h"
#import "dapptyModel.h"
#import "dappDetViewController.h"
#import "walletNodesModel.h"
#import "authsmView.h"
#import "addAsstsViewController.h"
#import "fangwenView.h"
#import "frsitFWView.h"


@interface defiDetXqViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)defiXQView*fristView;
@property(nonatomic,strong)defiPoolView*poolView;
@property(nonatomic,strong)defiSedView*dfoneView;
@property(nonatomic,strong)defiSedView*dftwoView;
@property(nonatomic,strong)defiSedView*dfthreeView;
@property(nonatomic,strong)defiKLineView*KLineView;
@property(nonatomic,strong)defiDetModel*detModel;
@property(nonatomic,strong)UIView*sxView;
@property(nonatomic,strong)UIButton*djBtn;


@end

@implementation defiDetXqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=self.model.pairName;
    
    
    [self.view addSubview:self.djBtn];
    
    [self.view addSubview:self.setTableView];
//    [self.view addSubview:self.noView];
//
//
    [self setnaUI];
    [MBProgressHUD showHUD];
    
    [self priGetadata];
    [self getdefiTrad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noKline) name:@"noKline" object:nil];
    
    
    // Do any additional setup after loading the view.
}
-(void)dealloc{
   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    NSLog(@"vhui");
}
-(void)noKline{
    
    CGRect rect=self.headView.frame;
    rect.size.height=gdValue(768);
    
    self.headView.frame=rect;
    self.KLineView.hidden=YES;
    self.setTableView.tableHeaderView=self.headView;
    
}
-(void)setnaUI{
    NSArray*arr=[defiModel bg_findAll:bg_DeFizxname];
    
   
   
    UIButton*serBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    serBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45),WDNavHeight, gdValue(30), gdValue(30));
    [serBtn setImage:imageName(@"defnor") forState:UIControlStateNormal];
    [serBtn setImage:imageName(@"defisele") forState:UIControlStateSelected];
   
    [serBtn addTarget:self action:@selector(seardefi:) forControlEvents:UIControlEventTouchUpInside];
    [self.navHeadView addSubview:serBtn];
    
    [arr enumerateObjectsUsingBlock:^(defiModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
        if([model.identity isEqualToString:self.model.identity]){
            serBtn.selected=YES;
            
            *stop=YES;
        
        }
        
    }];
    
}

#pragma mark  添加自选
-(void)seardefi:(UIButton*)sender{
    
    sender.selected=!sender.selected;
    if(sender.selected){
       
        if(self.block){
            self.block(@"1");
        }
        _model.bg_tableName=bg_DeFizxname;
        [_model bg_save];
        [MBProgressHUD showText:getLocalStr(@"添加成功")];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"zxmarkdefi" object:nil];

    }
    else{//取消
        if(self.block){
            self.block(@"0");
        }
//
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"identity"),bg_sqlValue(_model.identity)];
        [defiModel bg_delete:bg_DeFizxname where:where];

        [MBProgressHUD showText:getLocalStr(@"sccg")];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"zxmarkdefi" object:nil];
//
//
        
    }
    
}


#pragma mark  详情
-(void)priGetadata{
//    defpargetAPI
    
    
    NSDictionary*dic=@{@"ascription":_model.ascription,@"id":_model.identity};
    
    [Request GET:defpargetAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
            
        NSLog(@"sd--%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            NSDictionary*dict=responseObject[@"data"];
            
            self.detModel=[defiDetModel mj_objectWithKeyValues:dict];
            
            [self.fristView getdata:self.detModel];
            [self.poolView getdata:self.detModel];
            
            
            NSString*prt=[NSString stringWithFormat:@"1:%@",[Utility getnumstr:self.detModel.token0Price]];
            NSString*fls=[NSString stringWithFormat:@"≈ $%@",[Utility douVale:self.detModel.token0PriceUSD num:2]];
            NSArray*art1=@[prt,self.detModel.rateOfPrice];
            
            [self.dfoneView getdatarr:art1 fl:fls];
            
            NSString*prt2=[NSString stringWithFormat:@"$ %@",[Utility douVale:self.detModel.volume24 num:2]];
            NSArray*art2=@[prt2, self.detModel.rateOfVolume24];
            
            [self.dftwoView getdatarr:art2 fl:@""];
            
            NSString*prt3=[NSString stringWithFormat:@"%@",self.detModel.txCount24];
            NSArray*art3=@[prt3,self.detModel.rateOfTxCount24    ];
            
            [self.dfthreeView getdatarr:art3 fl:@""];
            
            
        }
        
        [MBProgressHUD hideHUD];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error------%@",[error localizedDescription]);
            [MBProgressHUD hideHUD];
        }] ;
}

-(void)sxink{
    [MBProgressHUD showHUD];
    [self getdefiTrad];
    
}
#pragma mark --最近交易对
-(void)getdefiTrad{
    
    NSDictionary*dic=@{@"ascription":_model.ascription,@"id":_model.identity};
    [Request GET:defransactionAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        NSLog(@"as--%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            NSArray*dart=responseObject[@"data"];
            if(dart.count){
                [self.dataArr removeAllObjects];
                
            for(NSDictionary*dict in dart){
                
                defiJYModel*model=[defiJYModel mj_objectWithKeyValues:dict];
                [self.dataArr addObject:model];
            }
                
                [self.setTableView reloadData];
                
                
            }
            
        }
        
        
        //defiJYModel
//        [MBProgressHUD hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    defiDetTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"defidetID" forIndexPath:indexPath];

    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(60);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return gdValue(48);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return gdValue(60);
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=cyColor;
    UIView*sxView=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15),0, SCREEN_WIDTH-gdValue(30), gdValue(30))];
    sxView.backgroundColor=[UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sxView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(gdValue(8), gdValue(8))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sxView.bounds;
           maskLayer.path = maskPath.CGPath;
    sxView.layer.mask = maskLayer;
    
    [vv addSubview:sxView];
    
    return vv;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=cyColor;
    
    [vv addSubview:self.sxView];
    
    
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   

}




-(UIButton*)djBtn{
    if(!_djBtn){
        _djBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _djBtn.frame=CGRectMake(gdValue(35), SCREEN_HEIGHT-gdValue(60)-kTabbarSafeBottomMargin, SCREEN_WIDTH-gdValue(70), gdValue(50));
        
        ViewRadius(_djBtn, gdValue(8));
        
        [_djBtn setTitle:getLocalStr(@"开始交易") forState:UIControlStateNormal];
        [_djBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_djBtn addTarget:self action:@selector(dappjy) forControlEvents:UIControlEventTouchUpInside];
        _djBtn.backgroundColor=mainColor;
        _djBtn.titleLabel.font=fontMidNum(16);
        
    }
    
    return _djBtn;
}
#pragma mark --开始交易
-(void)dappjy{
    
   
    
    dapptyModel*model=[[dapptyModel alloc]init];
    
    model.name=self.detModel.ascription;
  
    model.links=self.detModel.url;
    model.icon=self.detModel.ascriptionIcon;
    model.chain=self.detModel.chainCode;
    model.tyy=@"1";
    model.discription=self.detModel.ascription;
    
       
        model= [Utility setmodelValue:model];
        
        [self notModel:model];
    
}
-(void)notModel:(dapptyModel*)model{
//    NSLog(@"sdeeeeee---%@",model.addres);
    
    if([Utility isBlankString:model.addres]){
        userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
//        WeakSelf;
        authsmView*view=[[authsmView alloc]initWithFrame:SCREEN_FRAME tit:model.chain];
        view.numblock = ^{
            addAsstsViewController*addVc=[[addAsstsViewController alloc]init];
            addVc.typrt=1;
//            addVc.userModel=usModel;
            
            [addVc setHidesBottomBarWhenPushed:YES];
            [[Utility dc_getCurrentVC].navigationController pushViewController:addVc animated:YES];
            
        };
        
        return;
    }
    
    
    if(![Utility isBlankString:model.officialEmail]||![Utility isBlankString:model.telegram]||![Utility isBlankString:model.twitter]){
        WeakSelf;
        frsitFWView*frstVc=[[frsitFWView alloc]initWithFrame:SCREEN_FRAME modell:model];
        frstVc.block = ^{
            dappDetViewController*depVc=[[dappDetViewController alloc]init];
            [depVc setHidesBottomBarWhenPushed:YES];
            depVc.dappmodel=model;

            [depVc setHidesBottomBarWhenPushed:YES];

            [weakSelf.navigationController pushViewController:depVc animated:YES];
        };
        
        
        [frstVc show];
        return;
        
    }
    
    
  
       
//        WeakSelf;
    fangwenView*view=[[fangwenView alloc]initWithFrame:SCREEN_FRAME modell:model];
    view.block = ^(BOOL isselet) {
    
   
       
        
        dappDetViewController*depVc=[[dappDetViewController alloc]init];
        [depVc setHidesBottomBarWhenPushed:YES];
        depVc.dappmodel=model;

        [depVc setHidesBottomBarWhenPushed:YES];

        [[Utility dc_getCurrentVC].navigationController pushViewController:depVc animated:YES];
 
       

    };
           [view show];
    
  
    
}


-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight-gdValue(70)-kTabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= [UIColor whiteColor];

        _setTableView.tableHeaderView=self.headView;
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[defiDetTableViewCell class] forCellReuseIdentifier:@"defidetID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}

-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(100), SCREEN_WIDTH,gdValue(400))imgstr:@"nodata" tis:getLocalStr(@"暂无数据")];
       
    }
    
    return _noView;
}


-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(1000))];
        _headView.backgroundColor=cyColor;
        
        [_headView addSubview:self.fristView];
        [_headView addSubview:self.poolView];
        [_headView addSubview:self.dfoneView];
        [_headView addSubview:self.dftwoView];
        [_headView addSubview:self.dfthreeView];
        [_headView addSubview:self.KLineView];
        

        
    }
    return _headView;
}
-(UIView*)sxView{
    if(!_sxView){
        _sxView=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15),0, SCREEN_WIDTH-gdValue(30), gdValue(48))];
        _sxView.backgroundColor=[UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_sxView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(8), gdValue(8))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame = _sxView.bounds;
               maskLayer.path = maskPath.CGPath;
        _sxView.layer.mask = maskLayer;
        
       
        
        UILabel*nalab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(14), gdValue(200), gdValue(20))];
        nalab.text=getLocalStr(@"最近交易");//;
        nalab.font=fontNum(14);
        nalab.textColor=zyincolor;
        [_sxView addSubview:nalab];
        
        UIButton*sxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sxBtn.frame=CGRectMake(_sxView.width-gdValue(80),gdValue(9) , gdValue(65), gdValue(30));
        [sxBtn setTitle:getLocalStr(@"adm6") forState:UIControlStateNormal];
        [sxBtn setTitleColor:mainColor forState:UIControlStateNormal];
        sxBtn.titleLabel.font=fontNum(14);
        [_sxView addSubview:sxBtn];
        
        [sxBtn setImage:imageName(@"defisx") forState:UIControlStateNormal];
        [sxBtn addTarget:self action:@selector(sxink) forControlEvents:UIControlEventTouchUpInside];
        
        [sxBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(10)];
    }
    
    return _sxView;
}
-(defiXQView*)fristView{
    if(!_fristView){
        _fristView=[[defiXQView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(238)) tit:_model.pairName];
        ViewRadius(_fristView, gdValue(8));
        _fristView.backgroundColor=[UIColor whiteColor];
    }
    return _fristView;
}
-(defiPoolView*)poolView{
    if(!_poolView){
        _poolView=[[defiPoolView alloc]initWithFrame:CGRectMake(gdValue(15), _fristView.bottom+gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(178))];
        ViewRadius(_poolView, gdValue(8));
        _poolView.backgroundColor=[UIColor whiteColor];
    }
    return _poolView;
}
-(defiSedView*)dfoneView{
    if(!_dfoneView){
        NSString*sty=[_model.pairName stringByReplacingOccurrencesOfString:@"-" withString:@"："];
        NSString*str=[NSString stringWithFormat:@"%@ (%@)",getLocalStr(@"wark3"),sty];
        _dfoneView=[[defiSedView alloc]initWithFrame:CGRectMake(gdValue(15), _poolView.bottom+gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(110)) tit:str];
        
        ViewRadius(_dfoneView, gdValue(8));
        _dfoneView.backgroundColor=[UIColor whiteColor];
    }
    return _dfoneView;
}

-(defiSedView*)dftwoView{
    if(!_dftwoView){

        _dftwoView=[[defiSedView alloc]initWithFrame:CGRectMake(gdValue(15), _dfoneView.bottom+gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(90)) tit:getLocalStr(@"24小时交易量")];
        
        ViewRadius(_dftwoView, gdValue(8));
        _dftwoView.backgroundColor=[UIColor whiteColor];
    }
    return _dftwoView;
}

-(defiSedView*)dfthreeView{
    if(!_dfthreeView){

        _dfthreeView=[[defiSedView alloc]initWithFrame:CGRectMake(gdValue(15), _dftwoView.bottom+gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(90)) tit:getLocalStr(@"24小时交易次数")];
        
        ViewRadius(_dfthreeView, gdValue(8));
        _dfthreeView.backgroundColor=[UIColor whiteColor];
    }
    return _dfthreeView;
}

-(defiKLineView*)KLineView{
    if(!_KLineView){
        _KLineView=[[defiKLineView alloc]initWithFrame:CGRectMake(gdValue(15),  _dfthreeView.bottom+gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(222)) defi:_model.ascription conid:_model.identity];
        ViewRadius(_KLineView, gdValue(8));
        _KLineView.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _KLineView;
}

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
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
