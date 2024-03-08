//
//  WalletViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "WalletViewController.h"
#import "walletHeadView.h"
#import "WalletTableViewCell.h"
#import "noDataView.h"
#import "actShootView.h"
#import "selectMainView.h"
#import "seleWalletView.h"
#import "MnemonViewController.h"
#import "addAsstsViewController.h"
#import "tranDetViewController.h"

#import "seleBiView.h"
#import "upVesView.h"
#import "blockModel.h"
#import "marktModel.h"
#import "marketSocketManager.h"
#import "symbolModel.h"
#import "walletNewHeadView.h"
#import "myAssectModel.h"
#import "RedPointBadgeView.h"
#import "sybCodeModel.h"
#import "QuestViewController.h"


@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)walletHeadView*headView;
@property(nonatomic,assign)BOOL isYinc;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,strong)UIView*fotView;
@property(nonatomic,strong)UIButton*tishiBtn;//是否答题
@property(nonatomic,assign)NSInteger seleMainIndx;//主链选择
@property(nonatomic,assign)NSInteger selewalletIndx;//用户包选择
@property(nonatomic,weak)UIButton*lefbn;
@property(nonatomic,strong)UIButton*maincabtn;
@property(nonatomic,weak)UIImageView*maimg;
@property(nonatomic,copy)NSArray*dataArr;
//@property(nonatomic,strong)walletModel*wallModel;
@property(nonatomic,strong)userModel*userModel;

@property(nonatomic,strong) NSMutableArray*tempArr;//零时数据

@property(nonatomic,strong) NSMutableArray*allTokkArr;//显示的代币
@property(nonatomic,strong) NSMutableArray*titArr;//主链名称
@property(nonatomic,copy)NSArray*userArr;//用户数组

@property(nonatomic,strong)NSMutableArray*markArr;//行情数据

@property(nonatomic,strong)NSMutableArray*symboDataArr;//所有的代币

@property(nonatomic,strong)walletNewHeadView*waNewHeadView;


@property(nonatomic,strong)RedPointBadgeView*redPointView;
@property(nonatomic,strong)UIView*allView;//全部资产view
@property(nonatomic,strong)UIImageView*timg;

@property(nonatomic,strong) NSMutableArray*assectkArr;//代币合约地址
@property(nonatomic,strong) NSMutableArray*myAssectkArr;//有资产的代币
@property(nonatomic,assign)NSInteger zcnum;//没有添加的zxnum
@property(nonatomic,weak)UIButton*zcBtn;

@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
   
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    if([isQuest intValue]==1){
        self.tishiBtn.hidden=YES;
    }
    
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
    //    [self upVesUI];
   
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    _redPointView = [[RedPointBadgeView alloc] init];
    
    _seleMainIndx=0;
    _selewalletIndx=selewalletIndex;
    _isYinc=NO;
    self.leftBtn.hidden=YES;
    
    //   NSData*sd=[NSData da]
    
    [self setNavUI];
    
    [self setUI];
    [self  userSeleVoid];
    
    [self frsh];
    
//    [self setmarkSocket];
    
   
    [self getBlockData];
    
    [self getallbance];
    
    //
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotToken:) name:@"getALLTokenData" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deluser) name:@"deluser" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userSeleVoid) name:@"updateUSer" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myasset) name:@"myassetupte" object:nil];
   
    
    [Request  getInternetStatue];//监听网络状态
    
//   
    
    // Do any additional setup after loading the view.
}
-(void)myasset{
    
    _redPointView.hidden=YES;
    
}

-(void)loadUI{
    
    [self.titArr addObject:getLocalStr(@"adm19")];//主链标题添加全部显示
    
    [self getALLTokenData];
    [self getallbance];
    

    
}
#pragma mark 删除用户
-(void)deluser{
    _userArr=[userModel bg_findAll:bg_tablename];
    
    if(_userArr.count-1<_selewalletIndx){
        _selewalletIndx=0;
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"selewalletIndx"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [self userSeleVoid];
    
}


#pragma mark 用户变动方法
-(void)userSeleVoid{
    
    
    _selewalletIndx=selewalletIndex;
    _seleMainIndx=0;
    [self.maincabtn setTitle:getLocalStr(@"waqubzc") forState:UIControlStateNormal];
    [self loadUI];
    
    
   
    CGFloat wid=[Utility withForString:self.userModel.name fontSize:23 andhig:WD_StatusHight-kStatusBarHeight]+ gdValue(40);
    
    if(wid>SCREEN_WIDTH-gdValue(100)){
        wid=SCREEN_WIDTH-gdValue(100);
    }
    
    CGRect rect=self.lefbn.frame;
    rect.size.width=wid;
    
    self.lefbn.frame=rect;
    
    [self.lefbn setTitle:self.userModel.name forState:UIControlStateNormal];
   
    [self.lefbn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(8)];
    
    
    
}


#pragma mark ---变动通知
-(void)getNotToken:(NSNotification*)obj{
    
    
    NSString*objf=(NSString*)obj.object;
    if(![Utility isBlankString:objf]){//删除代币
        NSArray*art=[objf componentsSeparatedByString:@","];
        
      
        
        [self.symboDataArr enumerateObjectsUsingBlock:^(symbolModel*syb, NSUInteger idx, BOOL * _Nonnull stop) {
                    
            if([syb.chainCode isEqualToString:art[0]] && [syb.symbol isEqualToString:art[1]]){
                
                [self delSymBolindx:syb];
                
            }
        }];
    }
 
    else{
        
       
//        dispatch_async(dispatch_queue_create(0, 0), ^{
//
//              // 子线程执行任务（比如获取较大数据）
       
              dispatch_async(dispatch_get_main_queue(), ^{
                 
                  [self getBlockData];

                  [self getALLTokenData];
               
       
              });
       
//          });
    
      
 
    }
    
}

#pragma mark --获取代币余额
-(void)GetToeneAddre{
    
    NSMutableArray*dataArr=[NSMutableArray array];
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
        
        for(walletModel*wammodel in usmodel.walletArray){
            NSMutableArray*aty=[NSMutableArray array];
            
           
            
            for(symbolModel*model in wammodel.coinArray){
  
                    
                [aty addObject:model.contractId];
                
                
            }
            
            
            NSDictionary*dic=@{@"address":wammodel.addres,@"chainCode":wammodel.name,@"contractIds":[aty componentsJoinedByString:@","]};
            [dataArr addObject:dic];
            
        }
    NSLog(@"dic2---%@",dataArr);
    
    
    [Request POST:blockgetbanleAPI2 parameters:dataArr success:^(id  _Nonnull responseObject) {
        NSLog(@"s2---余额%@",[Utility strData:responseObject]);
        
        
                NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if([cod intValue]==200){
                    
                    NSArray*dart=responseObject[@"data"];
                    
                    [self.tempArr removeAllObjects];
                    
                    for(NSDictionary*dict in dart){
                        
                        
                        sybCodeModel*syMdoel=[sybCodeModel mj_objectWithKeyValues:dict];
                        
                        NSString*availableBalance=[NSString stringWithFormat:@"%@",dict[@"availableBalance"]];
                        NSString*contractId=[NSString stringWithFormat:@"%@",dict[@"contractId"]];
                        if([Utility isBlankString:contractId]){
                            contractId=@"";
                        }
                        availableBalance=  [Utility removeFloatAllZero:[Utility douVale:availableBalance num:6]];
                        syMdoel.availableBalance=availableBalance;
                        syMdoel.contractId=contractId;
                        
                        [self.tempArr addObject:syMdoel];
                        
        //
        //
                    }
                    
                    
                    
                }
    
        
                [self getResqData];//请求价格
                    
       
        
        
    } failure:^(NSError * _Nonnull error) {
        [self getResqData];//请求价格
    }];
}





#pragma mark 获取钱包所有币
-(void)getALLTokenData{
    
    self.userModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
  
    
    _isYinc=[[NSUserDefaults standardUserDefaults]boolForKey:isYinPrice];
    
    
    NSArray*coeArr=self.userModel.walletArray;//[Utility toArrayOrNSDictionary: self.userModel.walletArray];
    //    NSLog(@"sdsdsddccccc---%@",coeArr);
    NSLog(@"钱包数量.cout--%ld",coeArr.count);
    //
    
    [self.symboDataArr removeAllObjects];
    
    [self.assectkArr removeAllObjects];
    [self.titArr removeAllObjects];
    [self.titArr addObject:getLocalStr(@"adm19")];
    
    for(walletModel*watmodel in coeArr){
        
        [self.titArr addObject:watmodel.name];
        
//        NSLog(@"1-----%@  2--%@",watmodel.name,watmodel.addres);
        NSArray*ar=watmodel.coinArray;
        
        NSMutableArray*conidArt=[NSMutableArray array];//代币合约id
        
        for(symbolModel*comodel in ar){
            
            [conidArt addObject:comodel.contractId];
            
            comodel.icon=[NSString stringWithFormat:@"%@/%@/assets/%@/logo.png",RimageApi,[comodel.chainCode lowercaseString],comodel.contractId];
            
            if([comodel.isCode isEqualToString:@"1"]){//主币
                comodel.icon=[NSString stringWithFormat:@"%@/%@/assets/0x0000000000000000000000000000000000000000/logo.png",RimageApi,[comodel.chainCode lowercaseString]];
            }
            
            
            if(watmodel.nodesArray.count>0){//获取节点
                
                walletNodesModel*nodmol=watmodel.nodesArray[0];
                comodel.addres=watmodel.addres;
                comodel.rpcUrl=nodmol.rpcUrl;
                comodel.browserUrl=nodmol.browserUrl;
                
                //                NSLog(@"wa---%@  d--%@  df--%@  gg--%@",watmodel.addres,comodel.symbol,comodel.addres,comodel.chainCode);
                ////
                //                [self TokenmyQueDatasym:comodel nodeurl:nodmol.rpcUrl ];  自己请求rpc
                
                
            }
            
            [self.assectkArr addObject:comodel.contractId];
            [self.symboDataArr addObject:comodel];
            
            
        }
        

//        NSString*sybID=[conidArt componentsJoinedByString:@","];
        
        //----请求余额--------------
//        [self getToeneAddre:watmodel.addres contr:conidArt chaincod:watmodel.name];
        
        
        
    }
    
      
   
    
    [self.symboDataArr sortUsingComparator:^NSComparisonResult(symbolModel* obj1,symbolModel* obj2) {
        if (obj1.creadCount > obj2.creadCount) {
            return  NSOrderedAscending;
        }else if(obj1.creadCount == obj2.creadCount){
            return NSOrderedSame;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    

    
    [self GetToeneAddre];
    
    //
//    [self getAllWallData];
  
   
    
    [self cureesWallet];
    self.waNewHeadView.allArr=self.symboDataArr;
   
}

#pragma mark 当前钱包所有币
-(void)cureesWallet{
    
    
    //当前选中的钱包
    NSLog(@"wlletCount------%ld ",_seleMainIndx);
    
    if(_seleMainIndx==0){//所有
        
        //
        [self.allTokkArr removeAllObjects];
        [self.allTokkArr addObjectsFromArray:self.symboDataArr];
        
    
    }
    else{
        NSArray*coeArr=self.userModel.walletArray;
        
        [self.allTokkArr removeAllObjects];
        walletModel*watmodel=coeArr[_seleMainIndx-1];
//        NSLog(@"wlletCname------%@ ",watmodel.name);
        
        
        for(symbolModel* symodel in self.symboDataArr){
            if([symodel.chainCode isEqualToString:watmodel.name]){
                [self.allTokkArr addObject:symodel];
                
            }
        }
        
        
    }
    
    
    
    NSLog(@"总资产数量--%ld",self.allTokkArr.count);
    
    [ self.allTokkArr sortUsingComparator:^NSComparisonResult(symbolModel* obj1,symbolModel* obj2) {
        if (obj1.creadCount > obj2.creadCount) {
            return  NSOrderedAscending;
        }else if(obj1.creadCount == obj2.creadCount){
            return NSOrderedSame;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    
    
    
    if(self.allTokkArr.count>0){
        self.noView.hidden=YES;
    }
    else{
        self.noView.hidden=NO;
        
    }
    
    
    
    [self.mainTableview reloadData];
    
    
    
    
}



-(void)jsonJx:(id)responseObject{
    
    
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
        NSArray*daArr=responseObject[@"data"];
        
        if(daArr.count>0){
            self.userModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
            
            NSMutableArray*usarr=[NSMutableArray array];
            [usarr addObjectsFromArray:self.userModel.walletArray];
            
            for(NSDictionary*dic  in daArr){
                
                blockModel*model=[blockModel mj_objectWithKeyValues:dic];
                
                
                [usarr enumerateObjectsUsingBlock:^(walletModel*wamodel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([wamodel.name isEqualToString:model.code]){
                        wamodel.nodesArray=model.nodes;
                        
                        
                        [usarr replaceObjectAtIndex:idx withObject:wamodel];
                        
                        self.userModel.walletArray=[usarr copy];
                        
                        [self.userModel bg_saveOrUpdate];
                        
                    }
                    
                }];
                
                
            }
            
 
            
          
            
        }
        
        
        
    }
    
}
#pragma mark --主链信息
-(void)getBlockData{

    
    
    [Request GET:BlockAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
//            NSLog(@"sdcc---%@",[Utility strData:responseObject]);
       
        [self jsonJx:responseObject];
        
        
        
    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"sds--we--%@",[error localizedDescription]);
        
        [MBProgressHUD hideHUD];
    }];
    
}
-(void)getAllWallData{
    //
//    NSLog(@"当前选择第--%ld   用户总数：%ld",selewalletIndex,[userModel bg_findAll:bg_tablename].count);
    self.userModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    
    NSArray*userWallArr= self.userModel.walletArray;
    
    
    [self.titArr removeAllObjects];
    [self.titArr addObject:getLocalStr(@"adm19")];
    for(walletModel*modl in userWallArr){
        
        [self.titArr addObject:modl.name];
    }
    
    
    //   NSLog(@"s---%@")
}






-(void)setUI{
    
//
    
    

    [self.view addSubview:self.mainTableview];
    [self.mainTableview addSubview:self.noView];
  
    [self.view addSubview:self.tishiBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(yincNot:) name:@"yincnot" object:nil];
    
    [self.view bringSubviewToFront:self.navHeadView];
    
}

#pragma mark --隐藏价格
-(void)yincNot:(NSNotification*)objc{
    
    NSNumber*sty=(NSNumber*)objc.object;
    if([sty intValue]==1){
        
        _isYinc=YES;
        
    }
    else{
        _isYinc=NO;
       
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:_isYinc forKey:isYinPrice];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
   
//    _userModel.isHide=_isYinc;
//
//
//    [_userModel bg_saveOrUpdate];
    [self.mainTableview reloadData];
    
    
    
}
-(void)setNavUI{
    
    self.navHeadView.backgroundColor=mainColor;
    
    
    
    UIButton*lfBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    lfBtn.frame=CGRectMake(gdValue(17),kStatusBarHeight, gdValue(120), WD_StatusHight-kStatusBarHeight);
//    lfBtn.backgroundColor=UIColorFromRGB(0xf5f6f9);
//    ViewRadius(lfBtn, gdValue(15));
    [self.navHeadView addSubview:lfBtn];
    userModel*usmodel=_userArr[_selewalletIndx];
    [lfBtn setTitle:usmodel.name forState:UIControlStateNormal];
    [lfBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    lfBtn.titleLabel.font=fontMidNum(23);
    [lfBtn setImage:imageName(@"waxla") forState:UIControlStateNormal];
    lfBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [lfBtn addTarget:self action:@selector(selewaletCk:) forControlEvents:UIControlEventTouchUpInside];
    self.lefbn=lfBtn;
    [lfBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(8)];
    
    
}


#pragma mark --TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTokkArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"walletID" forIndexPath:indexPath];
    
    if(self.allTokkArr.count){
        cell.isYinc=_isYinc;
        //        cell.swipeDelegate = self;//开启左右滑动
        cell.model=self.allTokkArr[indexPath.row];
        //        NSDictionary*dic=self.allTokkArr[indexPath.row];
        //        cell.dict=dic;
        //添加长按手势
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        
        longPressGesture.minimumPressDuration=0.6f;//设置长按 时间
        [cell addGestureRecognizer:longPressGesture];
    }
    
    
    return cell;
}

#pragma mark  长按点击
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.mainTableview];
        NSIndexPath * indexPath = [self.mainTableview indexPathForRowAtPoint:location];
        
        
        actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:@[@"wazdi",@"watschu",@"waqux"] tis:@""];
        
        
        WeakSelf;
        view.getIndx = ^(NSInteger indx) {
            //           NSLog(@"a---%ld",indx);
            if(indx==0){//置顶
                
                [weakSelf bringUpindx:indexPath.row];
                
            }
            else if (indx==1){//删除
                symbolModel*modl=self.allTokkArr[indexPath.row];
                [weakSelf delSymBolindx:modl];
            }
            
        } ;
        
        [view show];
        
        //可以得到此时你点击的哪一行
        
        //在此添加你想要完成的功能
        
    }
    
    
}


#pragma mark 置顶
-(void)bringUpindx:(NSInteger)indx{
    
    
    symbolModel*model=self.allTokkArr[indx];
    //    model.isUp=@"1";
    //    [self.allTokkArr replaceObjectAtIndex:indx withObject:model];
    
    [self.allTokkArr removeObject:model];
    [self.allTokkArr insertObject:model atIndex:0];
    
    [self.symboDataArr removeObject:model];
    [self.symboDataArr insertObject:model atIndex:0];
    
    //    [self.allTokkArr exchangeObjectAtIndex:indx withObjectAtIndex:0];
    
    [self.mainTableview reloadData];
    
    
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    model.creadCount=runCount;
    
    
    NSMutableArray*userWallArr=[NSMutableArray array];
    NSMutableArray*arrt=[NSMutableArray array];
    
    
    
    [userWallArr addObjectsFromArray:self.userModel.walletArray];
    
    
    for(walletModel* watmodel in userWallArr){
        
        if([watmodel.name isEqualToString:model.chainCode]){//当前钱包
            arrt=[watmodel.coinArray mutableCopy];
            for(symbolModel * comdel in watmodel.coinArray){
                
                if([comdel.symbol isEqualToString:model.symbol]){//当前币
                    
                    
                    [arrt removeObject:comdel];
                    [arrt addObject:model];
                    watmodel.coinArray=[arrt copy];
                    [userWallArr removeObject:watmodel];
                    [userWallArr addObject:watmodel];
                    self.userModel.walletArray=[userWallArr copy];
                    
                    
                    [self.userModel bg_saveOrUpdate];
                    return;
                    
                }
            }
        }
        
    }
    
    
    
}

#pragma mark 删除代币
-(void)delSymBolindx:(symbolModel*)model{
    
   
    
    if([model.isCode isEqualToString:@"1"]){
        [MBProgressHUD showText:getLocalStr(@"主币不能取消")];
        return;
    }
    
   
    [self.allTokkArr removeObject:model];
    
    [self.symboDataArr removeObject:model];
    
  
    
    if(self.allTokkArr.count>0){
        self.noView.hidden=YES;
    }
    else{
        self.noView.hidden=NO;
    
    }
    
    
    self.waNewHeadView.allArr=self.symboDataArr;
    
    [self.mainTableview reloadData];
    
    
    
    NSMutableArray*userWallArr=[NSMutableArray array];
    NSMutableArray*arrt=[NSMutableArray array];
    
    
    
    [userWallArr addObjectsFromArray:self.userModel.walletArray];
    
    
    for(walletModel* watmodel in userWallArr){
        
        if([watmodel.name isEqualToString:model.chainCode]){//当前钱包
            arrt=[watmodel.coinArray mutableCopy];
            for(symbolModel * comdel in watmodel.coinArray){
                
                if([comdel.symbol isEqualToString:model.symbol]){//当前币
                    
                    
                    [arrt removeObject:comdel];
                    
                    watmodel.coinArray=[arrt copy];
                    [userWallArr removeObject:watmodel];
                    [userWallArr addObject:watmodel];
                    self.userModel.walletArray=[userWallArr copy];
                    
                    [self.userModel bg_saveOrUpdate];
                    
                    return;
                    
                }
            }
        }
        
    }
    
    
    
    
    
}

-(UIButton*)maincabtn{
    if(!_maincabtn){
        _maincabtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _maincabtn.frame=CGRectMake(gdValue(15), gdValue(15), gdValue(78), gdValue(30));
        [_maincabtn setTitle:getLocalStr(@"waqubzc") forState:UIControlStateNormal];
        [_maincabtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _maincabtn.titleLabel.font=fontNum(15);
        [_maincabtn addTarget:self action:@selector(selemanck:) forControlEvents:UIControlEventTouchUpInside];
        [_maincabtn setImage:imageName(@"qbxla") forState:UIControlStateNormal];
        [_maincabtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(7)];
    }
    return _maincabtn;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=mainColor;
    
    [view addSubview:self.allView];
    
    
    CGFloat contX=gdValue(15);
    if(_seleMainIndx!=0){
        
     
        NSString*ser=[NSString stringWithFormat:@"%@_n",_titArr[_seleMainIndx]];
        _timg.image=imageName(ser);
    
        
        contX=gdValue(42);
        
        
    }
    else{
        _timg.image=nil;
    }
    

    CGFloat wid=[Utility withForString:self.maincabtn.titleLabel.text fontSize:15 andhig:gdValue(20)]+gdValue(30);
    
    self.maincabtn.frame=CGRectMake(contX, gdValue(15),wid, gdValue(20));
    [_maincabtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(7)];
    

    
    return view;
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
    
    if(self.allTokkArr.count){
        symbolModel*symodel=self.allTokkArr[indexPath.row];
        
        
        tranDetViewController*trVc=[[tranDetViewController alloc]init];
        trVc.symodel=symodel;
        //        trVc.usmdel=self.userModel;
        [trVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:trVc animated:YES];
        
    }
    
    
}


-(UIView*)allView{
    if(!_allView){
        _allView=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(6), SCREEN_WIDTH, gdValue(50))];
        _allView.backgroundColor=[UIColor whiteColor];

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _allView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(15), gdValue(15))];
                   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                   maskLayer.frame =  _allView.bounds;
                   maskLayer.path = maskPath.CGPath;
        _allView.layer.mask = maskLayer;


       _timg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(20), gdValue(20))];

        [_allView addSubview:_timg];
        [_allView addSubview:self.maincabtn];

        UIButton*zcBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        zcBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(50),gdValue(8), gdValue(34), gdValue(34));
        [zcBtn setImage:imageName(@"addzc") forState:UIControlStateNormal];
        [zcBtn addTarget:self action:@selector(addAcrCk) forControlEvents:UIControlEventTouchUpInside];
       
        self.zcBtn=zcBtn;
        
//        [zcBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(10)];
        [_allView addSubview:zcBtn];
        
        [self isredhidarr];
    }

    return _allView;
}

-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight-WD_TabBarHeight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=[UIColor whiteColor];
     
    
//        [self setcolorjb:_mainTableview];
        
        [_mainTableview registerClass:[WalletTableViewCell  class] forCellReuseIdentifier:@"walletID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        
//                _mainTableview.bounces=NO;
        _mainTableview.tableHeaderView=self.waNewHeadView;
        _mainTableview.tableFooterView=self.fotView;
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(230), SCREEN_WIDTH,self.mainTableview.height-gdValue(240))imgstr:@"wanodata" tis:getLocalStr(@"wanodata")];
        
    }
    
    return _noView;
}

-(UIButton*)tishiBtn{
    if(!_tishiBtn){
        _tishiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _tishiBtn.frame=CGRectMake(0, SCREEN_HEIGHT-WD_TabBarHeight-gdValue(50), SCREEN_WIDTH, gdValue(50));
        
        _tishiBtn.backgroundColor=cyColor;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _tishiBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(8), gdValue(8))];
                   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                   maskLayer.frame = _tishiBtn.bounds;
                   maskLayer.path = maskPath.CGPath;
        _tishiBtn.layer.mask = maskLayer;
       
//        [ _tishiBtn setTitle:getLocalStr(@"watshifx") forState:UIControlStateNormal];
//        [ _tishiBtn setTitleColor:UIColorFromRGB(0xFA6400) forState:UIControlStateNormal];
//        _tishiBtn.titleLabel.font=fontMidNum(14);
//        [ _tishiBtn setImage:imageName(@"tsRight") forState:UIControlStateNormal];
        [_tishiBtn addTarget:self action:@selector(benfmnem) forControlEvents:UIControlEventTouchUpInside];
        
//        [_tishiBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(100)];
        
        
        UIImageView*lfimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), 0, gdValue(65), gdValue(50))];
        lfimg.image=imageName(@"wlftb");
        [_tishiBtn addSubview:lfimg];
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(lfimg.right+gdValue(30), gdValue(15), gdValue(230), gdValue(20))];
        tlab.text=getLocalStr(@"安全问卷");
        tlab.font=fontMidNum(14);
        tlab.textColor=ziColor;
        [_tishiBtn addSubview:tlab];
        
        UIImageView*rimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(30), gdValue(35)/2, gdValue(15), gdValue(15))];
        rimg.image=imageName(@"tsRight");
        [_tishiBtn addSubview:rimg];
        
//        _tishiBtn.hidden=YES;
        
    }
    return _tishiBtn;
}
#pragma mark 安全问卷
-(void)benfmnem{
    
    QuestViewController*quest=[[QuestViewController alloc]init];
    [quest  setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:quest animated:YES];
}


-(walletHeadView*)headView{
    if(!_headView){
        _headView=[[walletHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,gdValue(156))];
        //        _headView.backgroundColor=viewColor;
    }
    return _headView;
}


-(walletNewHeadView*)waNewHeadView{
    if(!_waNewHeadView){
        _waNewHeadView=[[walletNewHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(190))];
    }
    
    return _waNewHeadView;
}
-(UIView*)fotView{
    if(!_fotView){
        _fotView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(100))];
        _fotView.backgroundColor=[UIColor whiteColor];
    }
    return _fotView;
}


#pragma mark 选择链钱包
-(void)selemanck:(UIButton*)sender{
    
    
    selectMainView*view=[[selectMainView alloc]initWithFrame:SCREEN_FRAME  seleindx:_seleMainIndx arr:self.titArr];
    
    WeakSelf;
    view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
        weakSelf.seleMainIndx=indx;
        
        
        if(indx==0){
            
            [weakSelf.maincabtn setTitle:getLocalStr(@"waqubzc") forState:UIControlStateNormal];
            [ weakSelf cureesWallet];
        }
        else{
            NSString*srt=[NSString stringWithFormat:@"%@%@",nameStr,getLocalStr(@"adm20")];
            [weakSelf.maincabtn setTitle:srt forState:UIControlStateNormal];
            [ weakSelf cureesWallet];
        }
        
        
    };
    
    
    [view show];
    
}
#pragma mark 新增资产
-(void)addAcrCk{
    
   
    
    addAsstsViewController*addVc=[[addAsstsViewController alloc]init];

    [addVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addVc animated:YES];
    
}
#pragma mark 选择用户
-(void)selewaletCk:(UIButton*)sender{
    seleWalletView*view=[[seleWalletView alloc]initWithFrame:SCREEN_FRAME  seleindx:_selewalletIndx];
    
    
    WeakSelf;
    
    view.getselecwalletBlock = ^(NSInteger indx, NSString * _Nonnull nameStr) {
        weakSelf.selewalletIndx=indx;
        weakSelf.seleMainIndx=0;
        [weakSelf.maincabtn setTitle:getLocalStr(@"waqubzc") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setInteger:indx forKey:@"selewalletIndx"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [weakSelf.lefbn setTitle:nameStr forState:UIControlStateNormal];
        
        [weakSelf userSeleVoid];
        [weakSelf getallbance];
        
    };
    
    [view show];
}

#pragma mark 刷新
-(void)frsh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upteData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableview.mj_header=header;
//    header.tintColor=[UIColor whiteColor];
    header.stateLabel.textColor=[UIColor whiteColor];
    header.loadingView.color=[UIColor whiteColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectOffset(self.mainTableview.bounds, 0, -self.mainTableview.bounds.size.height)];
           bgView.backgroundColor = mainColor;
           [self.mainTableview insertSubview:bgView atIndex:0];
           
       });
    
    
    //     self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}
-(void)upteData{
    
    [self getALLTokenData];
    [ self getallbance];
    
    [self.mainTableview.mj_footer resetNoMoreData];
}


#pragma mark 请求价格
-(void)updatePrcie:(id)responseObject{
    
   
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
        NSArray*daArr=responseObject[@"data"];
        
        if(daArr.count>0){
            [self.markArr removeLastObject];
            NSMutableArray*temp=[NSMutableArray array];
            for(NSDictionary*dic  in daArr){
                
                marktModel*model=[marktModel mj_objectWithKeyValues:dic];
                
                [temp addObject:model];
                
  
                
            }
            
            
          
            
            
            [self.symboDataArr enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  
              
                
                [self.tempArr enumerateObjectsUsingBlock:^(sybCodeModel* scmodel, NSUInteger idxa, BOOL * _Nonnull stop) {
                    
//                    NSLog(@"sdsd---%@  ff---%@",obj.contractId ,scmodel.contractId);
                    if([obj.contractId isEqualToString:scmodel.contractId]&&[obj.chainCode isEqualToString:scmodel.chainCode]&&[obj.addres isEqualToString:scmodel.address]){
                        obj.numRest=scmodel.availableBalance;
//                            NSLog(@"ns--%@ d--%@",obj.symbol,scmodel.availableBalance);
                        [self.symboDataArr replaceObjectAtIndex:idx withObject:obj];





                   }
                                    
                }];
                
                [temp enumerateObjectsUsingBlock:^(marktModel*model, NSUInteger idxe, BOOL * _Nonnull stop) {
                    if([model.baseAsset isEqualToString:obj.symbol]){
                        obj.price=model.price;
                     obj.pricdecimals=model.decimals;
                        [self.symboDataArr replaceObjectAtIndex:idx withObject:obj];
                    }
                }];
                
  
                    
                    
                    

            }];
            
            
            [self cureesWallet];
            
            self.waNewHeadView.allArr=self.symboDataArr;
            
            
            
            
            NSMutableArray*usarr=[NSMutableArray array];

            userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];

            [usarr addObjectsFromArray:usmodel.walletArray];
            
            [self.symboDataArr enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idxer, BOOL * _Nonnull stopt) {
                
                
                NSMutableArray*aty=[NSMutableArray array];
      
                [usarr enumerateObjectsUsingBlock:^(walletModel*mmd, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([mmd.name isEqualToString:obj.chainCode]&&[mmd.addres isEqualToString:obj.addres]){//当前钱包
                        [aty addObjectsFromArray:mmd.coinArray];
                        
                        [aty enumerateObjectsUsingBlock:^(symbolModel*sym, NSUInteger idxt, BOOL * _Nonnull stopp) {
                            if([sym.contractId isEqualToString:obj.contractId]){
                                
                                [aty replaceObjectAtIndex:idxt withObject:obj];
                                
                                
                                mmd.coinArray=[aty copy];
                                
                                [usarr replaceObjectAtIndex:idx withObject:mmd];
                                
                                usmodel.walletArray=[usarr copy];
                                [usmodel bg_saveOrUpdate];
                                
                                *stopp=YES;
                                *stop=YES;
                                
                            }
                        }];
                        
                    }
                    
                    
                    
                }];
                //
            }];
            
            

            
            
       

        }
        
    }
}


-(void)getResqData{
    
//    id responseObject=[XHNetworkCache cacheJsonWithURL:tigetTickAPI];
//    [self updatePrcie:responseObject];
//
    
    
    [Request GET:tigetTickAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        //                NSLog(@"sd---%@",[Utility strData:responseObject]);
       
        [self updatePrcie:responseObject];
        
        [MBProgressHUD hideHUD];
        [self.mainTableview.mj_header endRefreshing];
            
        
        
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableview.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
    }];
    
}

#pragma mark 行情socket
-(void)setmarkSocket{
    
    //    NSString *url = [NSString stringWithFormat:@"%@ws",gdsocketHttp];
    //    NSLog(@"s===%@",url);//"cmd":"sub","topic":"tickers"
    WeakSelf;
    [[marketSocketManager shareManager]fl_open:gdsocketHttp connect:^{
        
        NSDictionary*dic=@{@"cmd":@"sub",@"topic":@"tickers"};
        NSString*data=[dic mj_JSONString];
        //        NSLog(@"sd--%@")
        [[marketSocketManager shareManager] fl_send:data];
    } receive:^(id message, FLSocketReceiveType type) {
        
        if (type == FLSocketReceiveTypeForMessage) {
            NSDictionary*responseObject=[weakSelf dictionaryWithJsonString1:message];
            
            NSArray*daArr=responseObject[@"data"];
            
            if(daArr.count>0){
                
                [self.markArr removeAllObjects];
                for(NSDictionary*dic  in daArr){
                    
                    marktModel*model=[marktModel mj_objectWithKeyValues:dic];
                    
                    [self.markArr addObject:model];
                    
                }
                
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"markbhua" object:self.markArr];
                
                
                
                
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"===socket连接失败");
    }];
}

-(NSDictionary *)dictionaryWithJsonString1:(NSString *)jsonString {
    
    if (jsonString == nil ) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


-(NSMutableArray*)markArr{
    if(!_markArr){
        _markArr=[NSMutableArray array];
    }
    return _markArr;
}
-(NSMutableArray*)titArr{
    if(!_titArr){
        _titArr=[NSMutableArray array];
    }
    return _titArr;
}
-(NSMutableArray*)allTokkArr{
    if(!_allTokkArr){
        _allTokkArr=[NSMutableArray array];
    }
    return _allTokkArr;
}

-(NSMutableArray*)symboDataArr{
    if(!_symboDataArr){
        _symboDataArr=[NSMutableArray array];
    }
    return _symboDataArr;
}
-(NSMutableArray*)assectkArr{
    if(!_assectkArr){
        _assectkArr=[NSMutableArray array];
    }
    return _assectkArr;
}
-(NSMutableArray*)myAssectkArr{
    if(!_myAssectkArr){
        _myAssectkArr=[NSMutableArray array];
    }
    return _myAssectkArr;
}

-(NSMutableArray*)tempArr{
    if(!_tempArr){
        _tempArr=[NSMutableArray array];
    }
    return _tempArr;
}

#pragma mark--获取所有代币
-(void)getallbance{
   
    
    NSMutableArray*dataArr=[NSMutableArray array];
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
        
        for(walletModel*wammodel in usmodel.walletArray){
            NSMutableArray*aty=[NSMutableArray array];
            
           
            
            for(myAssectModel*model in usmodel.myAssctArray){
//                NSLog(@"sdsd--ff--%@-%ld  o--%@",model.tokenVO.symbol,model.isTop ,model.tokenVO.isRead);
                
                if([model.chainCode isEqualToString:wammodel.name]&& model.isTop==1&&![Utility isBlankString:model.contractId]){
                    
//                    NSLog(@"sdsds--%@",model.contractId);
                    
                    [aty addObject:model.tokenVO.contractId];
                }
                
            }
            
            
            NSDictionary*dic=@{@"address":wammodel.addres,@"chainCode":wammodel.name,@"contractIds":[aty componentsJoinedByString:@","]};
            [dataArr addObject:dic];
            
        }
    NSLog(@"dic---%@",dataArr);
    

    [Request POST:getAllBalanAPI parameters:dataArr success:^(id  _Nonnull responseObject) {
        
        NSLog(@"mystrdf--%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            [self.myAssectkArr removeAllObjects];
            self.zcnum=0;
        

            userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];

            NSMutableArray*usarr=[NSMutableArray array];
            
            [usarr addObjectsFromArray:usmodel.myAssctArray];
            
            NSArray*arr=responseObject[@"data"];
            
            for(NSDictionary*dict in arr){
                myAssectModel*model=[myAssectModel mj_objectWithKeyValues:dict];
                
                if([Utility isBlankString:model.contractId ]){//主币
                    model.icon=[NSString stringWithFormat:@"%@/%@/assets/0x0000000000000000000000000000000000000000/logo.png",RimageApi,[model.chainCode lowercaseString]];
                }
                else{
                    model.icon=[NSString stringWithFormat:@"%@/%@/assets/%@/logo.png",RimageApi,model.chainCode,[model.contractId lowercaseString]];
                }
                
                
                [usarr enumerateObjectsUsingBlock:^( myAssectModel*obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    if([model.contractId isEqualToString: obj.contractId]&&[model.chainCode isEqualToString:model.chainCode]){
                        model.isTop=obj.isTop;
                        
                        
                    }
                    
                }];
                
                
                
                [self.myAssectkArr addObject:model];
                
                if(![Utility isBlankString:model.contractId]){
                if(![self.assectkArr containsObject:model.contractId]){
//                    NSLog(@"sys---%@  ---%@",model.symbol,model.tokenVO.symbol);
                    
                    if(![model.tokenVO.isRead isEqualToString:@"1"]&&model.isTop!=1){//新增
                    self.zcnum++;
                        
                    }
                    

                }
              
                }

                
            }
            
         
            
          
            usmodel.myAssctArray=[self.myAssectkArr copy];
            [usmodel bg_saveOrUpdate];
            
          
           
            if(self.zcnum>0){
            self.redPointView.hidden=NO;
           
            self.redPointView.isRedview=YES;
            [self.redPointView showTargetView:self.zcBtn forCount:1 location: RIGHT_TOP color:UIColorFromRGB(0xFA6400)];
            }
            if(self.zcnum==0){
            self.redPointView.hidden=YES;
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark --是否显示我的资产红点
-(void)isredhidarr{
    
    self.redPointView.hidden=YES;
//    if(!self.redPointView.isRedview){
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    NSArray*art=usmodel.myAssctArray;
    
    [art enumerateObjectsUsingBlock:^(myAssectModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![Utility isBlankString:model.contractId]){
        if(![self.assectkArr containsObject:model.contractId]){
         
            if(![model.tokenVO.isRead isEqualToString:@"1"]&&model.isTop!=1){//新增
            self.redPointView.hidden=NO;
           
            self.redPointView.isRedview=YES;
            [self.redPointView showTargetView:self.zcBtn forCount:1 location: RIGHT_TOP color:UIColorFromRGB(0xFA6400)];
            
            *stop=YES;
                
            }
            
        }
            
        }
        }];
//}

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
