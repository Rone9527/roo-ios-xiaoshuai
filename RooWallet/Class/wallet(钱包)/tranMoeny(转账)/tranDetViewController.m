//
//  tranDetViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "tranDetViewController.h"
#import "tradDetTableViewCell.h"

#import "DetTradViewController.h"
#import  "Lottie.h"
#import "symbolModel.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "tranDetModel.h"
#import "collectMoenyViewController.h"
#import "tranMoenyViewController.h"
#import "TradDetViewController.h"
#import "h5ViewController.h"
#import "jysMarkViewController.h"
#import "JXCategoryView.h"
#import "TRXKDViewController.h"
#import "TronTranViewController.h"

@interface tranDetViewController ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)UILabel*numLab;
@property(nonatomic,strong)UILabel*prLab;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,assign)int page;

@property(nonatomic,assign)int PageCount;
@property(nonatomic,strong)NSMutableArray*dataArr;

@property(nonatomic,strong)NSMutableArray*allArr;
@property(nonatomic,strong)NSMutableArray*ffromArr;
@property(nonatomic,strong)NSMutableArray*ttoArr;
@property(nonatomic,assign)NSInteger seleindx;

@property(nonatomic,strong)JXCategoryTitleView*jxgtiView;
@property(nonatomic,copy)NSString*browserUrl;

@property(nonatomic,strong)UIView*col;


@end

@implementation tranDetViewController

-(NSMutableArray*)allArr{
    if(!_allArr){
        _allArr=[NSMutableArray array];
    }
    return _allArr;
}
-(NSMutableArray*)ffromArr{
    if(!_ffromArr){
        _ffromArr=[NSMutableArray array];
    }
    return _ffromArr;
}
-(NSMutableArray*)ttoArr{
    if(!_ttoArr){
        _ttoArr=[NSMutableArray array];
    }
    return _ttoArr;
}
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(void)leftBarBtnClicked{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseLab.text=_symodel.symbol;
    
    [self getlanurl];
    
    _page=0;
    _seleindx=0;

    [self setUI];
    [MBProgressHUD showHUD];

    [self resqData:_page];

    [self getPrice];

    [self frsh];
    
    [self utineTrad];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    

    
    if(self.symodel.tradArr.count>0){
    [MBProgressHUD showHUD];
    [self loadNewData];
        
    }
    
    
}
-(void)getPrice{
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
    if([_symodel.symbol isEqualToString:@"USDT"]){
        _symodel.price=@"1";
        _symodel.pricdecimals=@"4";
        
    }
    
  

    
    //总价=价格*数量
    NSString*atrr=[NSString stringWithFormat:@"%f",[_symodel.price doubleValue]*[tare doubleValue]*[_symodel.numRest doubleValue]];
    
    
    NSString*allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility douVale:atrr num:[_symodel.pricdecimals intValue]]];//总价
    
    self.prLab.text=allPrc;
}

-(void)setUI{
    [self.view addSubview:self.mainTableview];
    
    [self.mainTableview addSubview:self.noView];
    
    
    NSArray*art;
    CGFloat wid;
    CGFloat fwid;
   
    if([_symodel.symbol isEqualToString:@"TRX"]){
        art=@[getLocalStr(@"wacloo"),getLocalStr(@"watran"),getLocalStr(@"带宽/能量")];
        wid=(SCREEN_WIDTH-gdValue(60))/3;
        fwid=gdValue(15);
    }
    else{
        art=@[getLocalStr(@"wacloo"),getLocalStr(@"watran")];
        wid=(SCREEN_WIDTH-gdValue(55))/2;
        fwid=gdValue(25);
    }
   
    for(int i=0;i<art.count;i++){
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(15)+(wid+fwid)*i, _mainTableview.bottom+gdValue(8), wid, gdValue(50));
    
        btn.titleLabel.font=fontMidNum(16);
        [btn setTitle:art[i] forState:UIControlStateNormal];
        [btn setTitleColor:mainColor forState:UIControlStateNormal];
        if(i==0 ){
           
            [btn setImage:imageName(@"trddet_4") forState:UIControlStateNormal];
        
            ViewBorderRadius(btn, gdValue(8), 1, mainColor);
            [btn  layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(10)];
        }
        else if(i==1){
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn setImage:imageName(@"trddet_5") forState:UIControlStateNormal];
            btn.backgroundColor=mainColor;
            ViewRadius(btn, gdValue(8));
            [btn  layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(10)];
        }
        else{
            ViewBorderRadius(btn, gdValue(8), 1, mainColor);
        }
      
        
       
        btn.tag=2222+i;
        [btn addTarget:self action:@selector(track:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
    }
    
}
#pragma mark --转账
-(void)track:(UIButton*)sender{
    if(sender.tag==2222){//收款
        collectMoenyViewController*cllVc=[[collectMoenyViewController alloc]init];
        cllVc.iconname=_symodel.chainCode;
        cllVc.iconnamed=_symodel.symbol;
        cllVc.addreStr=_symodel.addres;
        [cllVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cllVc animated:YES];
    }
    else if(sender.tag==2223){//转账
        
        if([_symodel.chainCode isEqualToString:@"TRON"]){
            
            TronTranViewController*trVc=[[TronTranViewController alloc]init];
            trVc.type=1;
            trVc.symodel=_symodel;
            [trVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:trVc animated:YES];
        }
        else{
        tranMoenyViewController*travC=[[tranMoenyViewController alloc]init];
        travC.type=1;
            travC.symodel=_symodel;
//          travC.usmdel=self.usmdel;
        
        [travC setHidesBottomBarWhenPushed:YES];
        [[Utility dc_getCurrentVC].navigationController pushViewController:travC animated:YES];
        }
    }
    
    else{
        TRXKDViewController*trxVC=[[TRXKDViewController alloc]init];
        trxVC.symodel=_symodel;
        [trxVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:trxVC animated:YES];
        
    }
}
#pragma mark --查询过期的转账
-(void)utineTrad{
    
    NSMutableArray*tradAr=[NSMutableArray array];
    [tradAr addObjectsFromArray:self.symodel.tradArr];
    
  
    for(tranDetModel*detmodel in self.symodel.tradArr){
        
//        NSLog(@"sd--%lld  f--%lld",[detmodel.timeStamp longLongValue],([[Utility getNowTimeTimestamp] longLongValue]-(60*60)));
        if([detmodel.timeStamp longLongValue]+(60*60)<([[Utility getNowTimeTimestamp] longLongValue])){//大于60分钟
            
         
            [tradAr removeObject:detmodel];
        }
    }
        
        [self delarr:[tradAr copy] ];
        
    
}
-(void)resqData:(int)page{
    
//    NSLog(@"sds--%d",page);
    
    NSString*pagee=[NSString stringWithFormat:@"%d",page];
    NSDictionary*dic;
    if([Utility isBlankString:_symodel.contractId]){
        dic=@{@"address":_symodel.addres,@"pageNum":pagee,@"pageSize":@"20"};
    }
    else{
        dic=@{@"address":_symodel.addres,@"contractId":_symodel.contractId,@"pageNum":pagee,@"pageSize":@"20"};
    }
  
//    NSLog(@"dic--%@",dic);
    
    NSString*url=[NSString stringWithFormat:transactionAPI,_symodel.chainCode];
    
    
    
    NSMutableArray*txidarr=[NSMutableArray array];
    
    
//   url=[NSString stringWithFormat:@"%@%@/",HostApi,url];
//    url=[NSString stringWithFormat:@"%@%@?address=%@&pageNum=%@&pageSize=10",HostApi,url,_symodel.addres,pagee];

    [Request GET:url parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
        NSLog(@"data--%@",[Utility strData:responseObject]);
        
        NSDictionary*dat=responseObject[@"data"];
        
        if(dat.count){
            
           
            
            
            self.PageCount=[[NSString stringWithFormat:@"%@",dat[@"totalPage"]] intValue];
            
            NSArray*datrr=dat[@"data"];
            if(datrr.count){
                
                if(self.page==0){
                  
                    [self.dataArr removeAllObjects];
                }
                
                [self.allArr removeAllObjects];
                [self.ttoArr removeAllObjects];
                [self.ffromArr removeAllObjects];
                
                
                NSMutableArray*tradAr=[NSMutableArray array];
                [tradAr addObjectsFromArray:self.symodel.tradArr];
//                NSLog(@"sddddddd--%ld",tradAr.count);
                
                
            for(NSDictionary*dict in datrr){
                tranDetModel *model= [tranDetModel mj_objectWithKeyValues:dict];
           
              
                
                //0失败 1，成功，2待处理，打包中
                if([model.statusType isEqualToString:@"FAIL"]){
                    model.staues=0;
                }
                else if ([model.statusType isEqualToString:@"CONFIRMED"]){
                    model.staues=1;
                }
                else if ([model.statusType isEqualToString:@"PENDIN"]||[model.statusType isEqualToString:@"IN_BLOCK"]){
                    model.staues=2;
                }
                
                if([model.toAddr isEqualToString:self.symodel.addres]){//收款
                    model.type=2;
                    [self.ttoArr addObject:model];
                }
               else if([model.fromAddr isEqualToString:self.symodel.addres]){//转出
                    model.type=1;
                    [self.ffromArr addObject:model];
                }
                
                [txidarr addObject:model.txId];
                
                [self.allArr addObject:model];
                
                
                
                ////------------------
//                for(tranDetModel*detmodel in self.symodel.tradArr){//判断接口是不是有了数据
//
////                    NSLog(@"fgg---%@   fff--%@",model.txId,detmodel.txId);
//                    if([model.txId isEqualToString:detmodel.txId]){
////                        NSLog(@"as----%@",model.txId);
//                        if([tradAr containsObject:detmodel]){
//                           [tradAr removeObject:detmodel];
////                            break;
//                        }
//
//
//
//                    }
//
//                    else{
//
//
//                        if(![self.dataArr containsObject:detmodel]){
//
//                        if(![self.allArr containsObject:detmodel]){
//                            NSLog(@"添加");
////                            [self   getTransactionReceipt:detmodel];
//
//                            [self.allArr insertObject:detmodel atIndex:0];
////                            break;
//                        }
//
//
//                        }
////
//                    }
//////
//                }
                //////-----------------------
                
                
                
            }
                
                if(self.seleindx==0){
                    [self.dataArr addObjectsFromArray:self.allArr];
                }
                else if (self.seleindx==1){
                    [self.dataArr addObjectsFromArray:self.ttoArr];
                }
                else{
                    [self.dataArr addObjectsFromArray:self.ffromArr];
                }
                
           
                
                
                [self.symodel.tradArr enumerateObjectsUsingBlock:^(tranDetModel*detmodel, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if([txidarr containsObject:detmodel.txId]){//包含了
                        
                        
                        if([tradAr containsObject:detmodel]){
                            [tradAr removeObject:detmodel];
                            
                        }
                        
                    }
                    else{
                        
                        if(![self.allArr containsObject:detmodel]){
                      
                       
                                
                           [self.allArr insertObject:detmodel atIndex:0];
                           
                                
                            }
                        else{
                            
                            [self.allArr  removeObject:detmodel];
                            
                        }
                        
                        if(![self.dataArr containsObject:detmodel]){
                      
                      
                            [self.dataArr insertObject:detmodel atIndex:0];
                                
                            }
                        else{
                            [self.dataArr  removeObject:detmodel];
                            
                        }
                      
                            
                        
                    }
                    
                }];
                
                
                
                
                
                [self delarr:[tradAr copy] ];
                
                
             
                
            
           
            }
            
        }
        [MBProgressHUD hideHUD];
        if(self.dataArr.count){
            self.noView.hidden=YES;
//            self.mainTableview.mj_footer.hidden=YES;
//            self.mainTableview.mj_header.hidden=YES;
        }
        else{
            self.mainTableview.mj_footer.hidden=YES;
            self.noView.hidden=NO;
        }
     
        [self.mainTableview reloadData];
        [self.mainTableview.mj_header endRefreshing];
        [self.mainTableview.mj_footer endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        self.mainTableview.mj_footer.hidden=YES;
//        self.noView.hidden=NO;
        [self.mainTableview.mj_header endRefreshing];
        [self.mainTableview.mj_footer endRefreshing];
    }];
}

-(void)delarr:(NSArray*)tradAr{
        self.symodel.tradArr=tradAr ;
    NSMutableArray*userar=[NSMutableArray array];
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    [userar addObjectsFromArray:usmodel.walletArray];
    
    for(int k=0;k<usmodel.walletArray.count;k++){
        
        walletModel*wmmodel=usmodel.walletArray[k];
        
        if([self.symodel.chainCode isEqualToString:wmmodel.name]){//当前钱包
          
            NSMutableArray*cty=[NSMutableArray array];
            [cty addObjectsFromArray:wmmodel.coinArray];
          
         
            for(int i=0;i<wmmodel.coinArray.count;i++){
                
                symbolModel*sym=wmmodel.coinArray[i];
             
                if([sym.symbol isEqualToString:self.symodel.symbol]){//当前代币
                 
                    [cty replaceObjectAtIndex:i withObject:self.symodel];
                    wmmodel.coinArray=[cty copy];
                    
                   
                    [userar replaceObjectAtIndex:k withObject:wmmodel];
                   
                }
            }
        }
        
    }
    
    usmodel.walletArray=[userar copy];//[weakSelf.userWallArr mj_JSONString];
    

    
    [usmodel bg_saveOrUpdate];
}
#pragma mark 查询交易
-(void)getTransactionReceipt:(tranDetModel*)ret{
    
    NSDictionary*dic=@{@"jsonrpc":@"2.0",@"method": @"eth_getTransactionReceipt", @"id":@"274",@"params": @[ret.txId]};
    
    
    [Request POST:self.symodel.rpcUrl parameters:dic success:^(id  _Nonnull responseObject) {
//        NSLog(@"ret----%@",[Utility strData:responseObject]);
        
        NSDictionary*dif=responseObject[@"result"];
        if(dif.count){
        NSString*sts=[NSString stringWithFormat:@"%@",responseObject[@"result"][@"status"]];
        if([sts isEqualToString:@"0x1"]){
       
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                    NSLog(@"3秒后执行这个方法");
                NSMutableArray*tradAr=[NSMutableArray array];
                [tradAr addObjectsFromArray:self.symodel.tradArr];
            
            [tradAr removeObject:ret];
            
       
            
            [self delarr:[tradAr copy] ];

           
            
        }
     
           
        }
        else{
//            [self getTransactionReceipt:ret];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
    
}
-(void)frsh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableview.mj_header=header;
     self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}

-(void)loadLastData{
    
    if(_page>=_PageCount){
        [self.mainTableview.mj_footer endRefreshing];
        //        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        
        _page++;
    
        [self resqData:_page];
    }
 
}
- (void)loadNewData
{
    
    self.mainTableview.mj_footer.hidden=NO;
    
    _page=0;
    
   
    
    [self resqData:_page];
    [self.mainTableview.mj_footer resetNoMoreData];
    
}

#pragma mark --TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tradDetTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"tradetID" forIndexPath:indexPath];

    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
    }
    
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];

    [view addSubview:self.col];
    [view addSubview:self.jxgtiView];
    
    
    
//    [view addSubview:self.qbBtn];
//    [view addSubview:self.tradBtn];
//    [view addSubview:self.joutBtn];
    
    return view;
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(230), SCREEN_WIDTH,self.mainTableview.height-gdValue(240))imgstr:@"nodata" tis:getLocalStr(@"zwjz")];
        _noView.hidden=YES;
    }
    
    return _noView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return gdValue(55);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];
    
    return view;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(70);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if(self.dataArr.count){
        
    DetTradViewController*detVc=[[DetTradViewController alloc]init];
    detVc.model=self.dataArr[indexPath.row];
    detVc.chonacode=_symodel.chainCode;
    
    [self.navigationController pushViewController:detVc animated:YES];
    }
    
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight-gdValue(80)) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=viewColor;
       
        [_mainTableview registerClass:[tradDetTableViewCell  class] forCellReuseIdentifier:@"tradetID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //        _tableView.bounces=NO;
        _mainTableview.tableHeaderView=self.headView;
     
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(JXCategoryTitleView*)jxgtiView{
    if(!_jxgtiView){
        _jxgtiView=[[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(45))];
        _jxgtiView.delegate = self;
//        _jxgtiView.defaultSelectedIndex=1;
        _jxgtiView.titles = @[getLocalStr(@"trawrt15"),getLocalStr(@"trawrt16"),getLocalStr(@"trawrt17")];
        _jxgtiView.contentEdgeInsetLeft=gdValue(30);
        _jxgtiView.contentEdgeInsetRight=gdValue(140);
        _jxgtiView.titleColorGradientEnabled = YES;
        _jxgtiView.titleColor=zyincolor;
        _jxgtiView.titleSelectedColor=ziColor;
//        _jxgtiView.titleLabelVerticalOffset=10;
        _jxgtiView.cellSpacing=gdValue(10);
        _jxgtiView.titleFont=fontBoldNum(14);
        _jxgtiView.titleSelectedFont=fontBoldNum(14);
       

        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = ziColor;
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
//        lineView.indicatorWidthIncrement=gdValue(30);
        _jxgtiView.indicators = @[lineView];
    }
    return _jxgtiView;
}
-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(43), SCREEN_WIDTH, 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}

-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,gdValue(242))];//gdValue(122)

        [_headView addSubview:self.numLab];
        [_headView addSubview:self.prLab];
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(232), SCREEN_WIDTH, gdValue(10))];
        col.backgroundColor=cyColor;
        [_headView addSubview:col];
        
        CGFloat wid=0.0;
        CGFloat fld=0.0;
        NSArray*art;
        NSArray*tuArr;
        if([_symodel.isMarket isEqualToString:@"1"]){//有行情
            
             wid=(SCREEN_WIDTH-gdValue(330))/2;
            art=@[getLocalStr(@"资产介绍"),getLocalStr(@"交易所行情"),getLocalStr(@"区块浏览器")];
            tuArr=@[@"syb_1",@"syb_2",@"syb_3"];
            fld=gdValue(120);
        }
        else{
          wid=(SCREEN_WIDTH-gdValue(260))/2;
            art=@[getLocalStr(@"资产介绍"),getLocalStr(@"区块浏览器")];
            tuArr=@[@"syb_1",@"syb_3"];
            fld=gdValue(180);
        }
      
        for(int i=0;i<art.count;i++){
            UIButton*btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(wid+i*fld, _prLab.bottom+gdValue(50), gdValue(80), gdValue(80));

            UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(20), 0, gdValue(40), gdValue(40))];
            img.image=imageName(tuArr[i]);
            [btn addSubview:img];
            
            UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+gdValue(10), gdValue(80), gdValue(20))];
            lab.text=art[i];
            lab.textColor=ziColor;
            lab.font=fontNum(14);
            lab.textAlignment=NSTextAlignmentCenter;
            [btn addSubview:lab];
            
            btn.tag=8000+i;
            [btn addTarget:self action:@selector(sybck:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [_headView addSubview:btn];
        }
        
        
    }
    return _headView;
}
-(UILabel*)numLab{
    if(!_numLab){
        _numLab= [[UILabel  alloc]initWithFrame:CGRectMake(0, gdValue(20), SCREEN_WIDTH, gdValue(42))];
        _numLab.text=_symodel.numRest;
        if([Utility isBlankString:_symodel.numRest]){
           _numLab.text=@"0";
        }
        _numLab.font=fontBoldNum(30);
        _numLab.textColor=ziColor;
        _numLab.textAlignment=NSTextAlignmentCenter;
    }
    return _numLab;;
}
-(UILabel*)prLab{
    if(!_prLab){
        _prLab= [[UILabel  alloc]initWithFrame:CGRectMake(0, gdValue(7)+_numLab.bottom, SCREEN_WIDTH, gdValue(23))];
//        _prLab.text=@"￥74.42";
        
        
        _prLab.font=fontNum(16);
        _prLab.textColor=zyincolor;
        _prLab.textAlignment=NSTextAlignmentCenter;
    }
    return _prLab;
}

#pragma mark 点击
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    
    [self.dataArr removeAllObjects];
    self.seleindx=index;
    if(index==0){
    [self.dataArr addObjectsFromArray:self.allArr];
    }
    else if (index==1){
        [self.dataArr addObjectsFromArray:self.ttoArr];
    }
    else{
        [self.dataArr addObjectsFromArray:self.ffromArr];
    }
    if(self.dataArr.count){
//        self.mainTableview.mj_header.hidden=NO;
        self.mainTableview.mj_footer.hidden=NO;
        self.noView.hidden=YES;
    }
    else{
//        self.mainTableview.mj_header.hidden=YES;
        self.mainTableview.mj_footer.hidden=YES;
        self.noView.hidden=NO;
    }
    
    [self.mainTableview reloadData];

}
#pragma mark --获取beurl
-(void)getlanurl{
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    for(walletModel*wmmodel in usmodel.walletArray){
        if([_symodel.chainCode isEqualToString:wmmodel.name]){
        
            if(wmmodel.nodesArray.count){
                walletNodesModel*nodmol=wmmodel.nodesArray[0];
//                NSLog(@"s---%@    -t---%@",wmmodel.addres,wmmodel.password);
                _browserUrl=nodmol.browserUrl;
//                NSLog(@"sdd------%@",_browserUrl);
            }
            
            
        }
        
        
    }
}
#pragma  mark --资产详情点击
-(void)sybck:(UIButton*)sender{
    NSInteger indx=sender.tag-8000;
    
    if(indx==0){
        TradDetViewController*vc=[[TradDetViewController alloc]init];
        vc.symodel=_symodel;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    else if (indx==1){
        
        if([_symodel.isMarket isEqualToString:@"1"]){
            jysMarkViewController*jysVC=[[jysMarkViewController alloc]init];
            jysVC.symodel=_symodel;
            [self.navigationController pushViewController:jysVC animated:YES];
            
        }
        else{
            
            NSString*url=[NSString stringWithFormat:@"%@address/%@",_browserUrl,_symodel.contractId];
            
            h5ViewController*vc=[[h5ViewController alloc]init];
            if([Utility isBlankString:_symodel.contractId]){
                vc.url= _browserUrl;
            }
            else{
                vc.url= url;
            }
          
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        NSString*url=[NSString stringWithFormat:@"%@address/%@",_browserUrl,_symodel.contractId];
       
        h5ViewController*vc=[[h5ViewController alloc]init];
        if([Utility isBlankString:_symodel.contractId]){
            vc.url= _browserUrl;
        }
        else{
            vc.url= url;
        }
        [self.navigationController pushViewController:vc animated:YES];
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
