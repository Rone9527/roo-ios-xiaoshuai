//
//  DappViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "DappViewController.h"
#import "dappTableViewCell.h"
#import "coletView.h"
#import "remView.h"
#import "collHeaView.h"
#import "DapSearViewController.h"
#import "dappDetViewController.h"
#import "fangwenView.h"
#import "authorFrstView.h"
#import "authorSecdView.h"
#import "dapptyModel.h"
#import "walletNodesModel.h"
#import "authsmView.h"
#import "addAsstsViewController.h"
#import "SDCycleScrollView.h"
#import "tabFootView.h"


#import "h5ViewController.h"
#import "frsitFWView.h"

@interface DappViewController ()<UITableViewDelegate,UITableViewDataSource,collheadDelagte,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)UIButton*serBtn;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)coletView*cllView;
@property(nonatomic,strong)remView*rmView;
@property(nonatomic,strong)collHeaView*cview;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic, strong) SDCycleScrollView *SDCView;
@property(nonatomic,strong)tabFootView*fotView;
@property(nonatomic,strong)NSMutableArray*imgUrlArr;
@end

@implementation DappViewController
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    
    return _dataArr;
}
-(NSMutableArray*)imgUrlArr{
    if(!_imgUrlArr){
        _imgUrlArr=[NSMutableArray array];
    }
    return _imgUrlArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_cllView getdata];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHeadView.hidden=YES;
    
  
    
    [self getBlockData];
    
    
    [self setUI];
    
    [self getBannner];
    
    [self frsh];
    
//    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tangcnot:) name:@"DAPPtangck" object:nil];
    
    // Do any additional setup after loading the view.
}
- (SDCycleScrollView *)SDCView
{
    if (!_SDCView) {
        
        _SDCView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(gdValue(15),gdValue(10), SCREEN_WIDTH-gdValue(30),gdValue(140)) imageNamesGroup:nil];
//        _SDCView.pageDotImage=HH_IMAGE(@"h_hy1");
 
        _SDCView.backgroundColor=[UIColor whiteColor];
        _SDCView.delegate=self;
        _SDCView.autoScrollTimeInterval = 5;
        _SDCView.currentPageDotColor=mainColor;
//        _SDCView.currentPageDotImage=HH_IMAGE(@"h_hy2");
//        _SDCView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFill
       
        _SDCView.placeholderImage=imageName(@"dappmrtu");
        
//        NSArray*arr=@[@"ccs_0",@"ccs_1",@"ccs_2",@"ccs_3",@"ccs_4",@"ccs_5",@"ccs_6",@"ccs_7"];
    
//        _SDCView.localizationImageNamesGroup=arr;
     
       
    }
    return _SDCView;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    if(self.imgUrlArr.count){
        h5ViewController*vch=[[h5ViewController alloc]init];
        vch.url=self.imgUrlArr[index];
        vch.type=3;
        [vch setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:vch animated:YES];
        
    }
    
}

#pragma mark --通知
-(void)tangcnot:(NSNotification*)objt{
    
    dapptyModel*model=(dapptyModel*)objt.object;
    
  
    [self notModel:model];
    
    
}

#pragma mark --请求banner
-(void)getBannner{
    
    id responseObjectt=[XHNetworkCache cacheJsonWithURL:getBanAPI];
//    NSLog(@"sdfffffff--%@",responseObject);
    [self jsonJbann:responseObjectt];
    
    
    NSDictionary*dic=@{@"type":@"1"};
    [Request GET:getBanAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//        NSLog(@"cc---%@",[Utility strData:responseObject]);
        
        [self jsonJbann:responseObject];
        
   
    } failure:^(NSError * _Nonnull error) {
        
//        NSLog(@"weerrr--%@",[error localizedDescription]);
        
    }];
    
}

-(void)jsonJbann:(id)responseObject{
    
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
        NSArray*daArr=responseObject[@"data"];
        NSMutableArray*imgeArr=[NSMutableArray array];
        
        [self.imgUrlArr removeAllObjects];
        
        if(daArr.count>0){
       
            for(NSDictionary*dcit in daArr){
                
                NSString*icon=[NSString stringWithFormat:@"%@",dcit[@"image"]];
//                .NSLog(@"sd--%@",icon);
                
                [imgeArr addObject:icon];
                
                NSString*url=[NSString stringWithFormat:@"%@",dcit[@"href"]];
                
                [self.imgUrlArr addObject:url];
                
            }
            
            self.SDCView.imageURLStringsGroup=imgeArr;
            
            [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:getBanAPI];
            }
  
        
    }
}
-(void)jsonJx:(id)responseObject{
    
    
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
        NSArray*daArr=responseObject[@"data"];
        
        if(daArr.count>0){
       
                
            [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:BlockAPI];
                
            }
  
        
    }
    
}

#pragma mark --主链信息
-(void)getBlockData{
    
    
    [Request GET:BlockAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        //        NSLog(@"sd---%@",[Utility strData:responseObject]);
        
        [self jsonJx:responseObject];
        
        
        
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
}
-(void)setUI{
    
    
    UILabel*namelab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), WDNavHeight, gdValue(100), gdValue(30))];
    namelab.text=@"DAPP";
    namelab.textColor=ziColor;
    namelab.font=fontMidNum(23);
    [self.view addSubview:namelab];
    
    [self.view addSubview:self.serBtn];
    [self.view addSubview:self.mainTableview];
    
 
    
}

-(UIButton*)serBtn{
    if(!_serBtn){
        _serBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _serBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45), WDNavHeight, gdValue(30), gdValue(30));
        
        [_serBtn setImage:imageName(@"dappss") forState:UIControlStateNormal];
        
        
//        ViewRadius(_serBtn, gdValue(6));
//        _serBtn.backgroundColor=cyColor;
//        UIImageView*reimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(70), gdValue(10), gdValue(20), gdValue(20))];
//        reimg.image=imageName(@"sert");
//        [_serBtn addSubview:reimg];
//
//        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(reimg.right+gdValue(10), gdValue(9), gdValue(180), gdValue(22))];
//        tlab.text=getLocalStr(@"adm1");
//        tlab.font=fontNum(16);
//        tlab.textColor=zyincolor;
//        [_serBtn addSubview:tlab];
        
        [_serBtn addTarget:self action:@selector(serpClk) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _serBtn;
}

-(void)serpClk{
    
    DapSearViewController*dserVc=[[DapSearViewController alloc]init];
    [dserVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:dserVc animated:YES];
    
}
#pragma mark 刷新
-(void)frsh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upteData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableview.mj_header=header;
    //     self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}
-(void)upteData{
    
    [_rmView update];
    [_cview getuodate];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.mainTableview.mj_header endRefreshing];
        });
   
    [self.mainTableview.mj_footer resetNoMoreData];
}


#pragma mark --数据回调

-(void)getReqDataArr:(NSArray *)arr{
    
    [self.dataArr removeAllObjects];
//    NSArray*art=responseObject[@"data"];
//            userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];;
    
    for(NSDictionary*dict in arr){
        dapptyModel*model =[dapptyModel mj_objectWithKeyValues:dict];
        

        [self.dataArr addObject:model];
        
    }
    
    [self.mainTableview reloadData];
    
}


#pragma mark --TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    dappTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"dapID" forIndexPath:indexPath];
    
    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return gdValue(90);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];
    
    return view;;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.cview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(70);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
    
    
    dapptyModel*model=self.dataArr[indexPath.row];
    model= [Utility setmodelValue:model];

//    NSLog(@"sdrrrrrrrr---%@",model.rpcurl);
    
    [self notModel:model];

    
    
  
//
////
//    h5ViewController*vc=[[h5ViewController alloc]init];
//    vc.url=@"https://mdex.co";
    
//    linrelinViewController*vc=[[linrelinViewController alloc]init];
//
//    [self.navigationController pushViewController:vc animated:YES];
    
 
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _serBtn.bottom+5, SCREEN_WIDTH,SCREEN_HEIGHT-WD_TabBarHeight-_serBtn.bottom-5) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=[UIColor whiteColor];
       
        [_mainTableview registerClass:[dappTableViewCell  class] forCellReuseIdentifier:@"dapID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.tableHeaderView=self.headView;
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        _mainTableview.tableFooterView=self.fotView;
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(485))];//457 372
        _headView.backgroundColor=cyColor;
        [_headView addSubview:self.cllView];
        [_headView addSubview:self.rmView];
        
        
        UIView*vv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(150))];
        vv.backgroundColor=[UIColor whiteColor];
        [_headView addSubview:vv];
        
        [vv  addSubview:self.SDCView];
        
      
        
        
    }
    return _headView;
}
-(coletView*)cllView{
    if(!_cllView){
        _cllView=[[coletView alloc]initWithFrame:CGRectMake(0, gdValue(150), SCREEN_WIDTH, gdValue(130))];//225  140
        _cllView.backgroundColor=[UIColor whiteColor];
    }
    return  _cllView;
}
-(remView*)rmView{
    if(!_rmView){
        _rmView=[[remView alloc]initWithFrame:CGRectMake(0, _cllView.bottom+gdValue(7), SCREEN_WIDTH, gdValue(200))];
        _rmView.backgroundColor=[UIColor whiteColor];
    }
    return  _rmView;
}
-(collHeaView*)cview{
    if(!_cview){
        _cview=[[collHeaView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(90))];
        _cview.backgroundColor=[UIColor whiteColor];
        _cview.delegate=self;
        
    }
    return _cview;
}

-(tabFootView*)fotView{
    if(!_fotView){
        _fotView=[[tabFootView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(60)) titStr:@"我也是有底线的"];
    }
    return  _fotView;
}


-(void)notModel:(dapptyModel*)model{
//    NSLog(@"sdeeeeee---%@",model.addres);
    
    if([Utility isBlankString:model.addres]){
       
        WeakSelf;
        authsmView*view=[[authsmView alloc]initWithFrame:SCREEN_FRAME tit:model.chain];
        view.numblock = ^{
            addAsstsViewController*addVc=[[addAsstsViewController alloc]init];
            addVc.typrt=1;
//            addVc.userModel=usModel;
            [addVc setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:addVc animated:YES];
            
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
    

        WeakSelf;
    fangwenView*view=[[fangwenView alloc]initWithFrame:SCREEN_FRAME modell:model];
    view.block = ^(BOOL isselet) {
    
     
        
        dappDetViewController*depVc=[[dappDetViewController alloc]init];
        [depVc setHidesBottomBarWhenPushed:YES];
        depVc.dappmodel=model;

        [depVc setHidesBottomBarWhenPushed:YES];

        [weakSelf.navigationController pushViewController:depVc animated:YES];
 
       

    };
           [view show];
    
  
    
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
