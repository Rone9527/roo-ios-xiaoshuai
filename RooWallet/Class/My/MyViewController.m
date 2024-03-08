//
//  MyViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "MyViewController.h"
#import "RedPointBadgeView.h"
#import "adminWalletViewController.h"
#import "addrestViewController.h"
#import "myNewsViewController.h"
#import "mySetViewController.h"
#import "helpModel.h"
#import "h5ViewController.h"
#import "tranDetModel.h"
#import "aboutUSViewController.h"
#import "authsmView.h"
#import "addAsstsViewController.h"
#import "invtfrindViewController.h"
#import "neswModel.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,copy)NSArray*tiArr;
@property(nonatomic,copy)NSArray*tuArr;
@property(nonatomic,strong)RedPointBadgeView*redPointView;
@property(nonatomic,weak)UIButton*rBtn;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)UIView*tzview;
@property(nonatomic,copy)NSString*addstr;
@property(nonatomic,copy)NSString*ivtcodestr;

@property(nonatomic,strong)UIView*headView;

@end

@implementation MyViewController

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.leftBtn.hidden=YES;
//    self.baseLab.text=getLocalStr(@"myd");
    
    _tiArr=@[@[getLocalStr(@"myd1")],@[getLocalStr(@"myd2")],@[getLocalStr(@"活动中心"),getLocalStr(@"myd4"),getLocalStr(@"myd3"),getLocalStr(@"myd5")],@[getLocalStr(@"myd6")]];
    _tuArr=@[@[@"myt_1"],@[@"myt_2"],@[@"myt_8",@"myt_4",@"myt_3",@"myt_5"],@[@"myt_6"]];
    [self setNavUI];
    
    [self setUI];
    
 
    [self upVesUI];

    [self getHCdata];
    [self resqData];
    
    
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
    NSArray*newArr=[tranDetModel bg_findAll:bg_pushNewname];
    NSArray*newArr1=[neswModel bg_findAll:bg_Newtpushname];
    
    for(tranDetModel*model in newArr){
        
        if(model.isYdu==0){
        
            _redPointView.hidden=NO;
           
            _redPointView.isRedview=YES;
            [_redPointView showTargetView:_rBtn forCount:1 location: RIGHT_TOP color:UIColorFromRGB(0xFA6400)];
            
            return;
        }
        else{
          
            _redPointView.hidden=YES;;
        }
        
    }
    
    for(neswModel*model in newArr1){
        if(model.isYdu==0){
        
            _redPointView.hidden=NO;
           
            _redPointView.isRedview=YES;
            [_redPointView showTargetView:_rBtn forCount:1 location: RIGHT_TOP color:UIColorFromRGB(0xFA6400)];
            
            return;
        }
        else{
          
            _redPointView.hidden=YES;;
        }
    }
    
}
-(void)getHCdata{
  
    id responseObject=[XHNetworkCache cacheJsonWithURL:sysConfigAPI];
    [self jsonJx:responseObject];
}
-(void)setUI{
    
    self.navHeadView.hidden=YES;
    
    _redPointView = [[RedPointBadgeView alloc] init];
    [self.view addSubview:self.headView];
    
    [self.view addSubview:self.mainTableview];
    
}
-(void)setNavUI{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.rBtn=rBtn;
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45), WDNavHeight, gdValue(30), gdValue(30));
    [rBtn setImage:imageName(@"mynews") forState:UIControlStateNormal];
    [self.headView addSubview:rBtn];
    [rBtn addTarget:self action:@selector(myneskl) forControlEvents:UIControlEventTouchUpInside];
    
    

    
}
-(void)myneskl{
    myNewsViewController*neVc=[[myNewsViewController alloc]init];
    [neVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:neVc animated:YES];
}


#pragma mark --TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tiArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_tiArr[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"mysetID" forIndexPath:indexPath];
    
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= cyColor;
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UIView*bgview=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), 0, SCREEN_WIDTH-gdValue(30), gdValue(55))];
    bgview.backgroundColor=[UIColor whiteColor];
    if(indexPath.section==2){
        if(indexPath.row==0){
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: bgview.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(6), gdValue(6))];
                       CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                       maskLayer.frame =  bgview.bounds;
                       maskLayer.path = maskPath.CGPath;
           bgview.layer.mask = maskLayer;
        }
        else if(indexPath.row==3){
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: bgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(gdValue(6), gdValue(6))];
                       CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                       maskLayer.frame =  bgview.bounds;
                       maskLayer.path = maskPath.CGPath;
           bgview.layer.mask = maskLayer;
        }
    }
    else{
    ViewRadius(bgview, gdValue(6));
        
    }
    [cell.contentView addSubview:bgview];
    
    
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(16), gdValue(23), gdValue(23))];
    img.image=imageName(_tuArr[indexPath.section][indexPath.row]);
    [bgview addSubview:img];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(img.right+gdValue(15), gdValue(16), gdValue(200), gdValue(23))];
    tlab.text=_tiArr[indexPath.section][indexPath.row];
    tlab.textColor=ziColor;
    tlab.font=fontMidNum(16);
    [bgview addSubview:tlab];
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(55)-1, bgview.width-gdValue(30), 1)];
    col.backgroundColor=cyColor;
    [bgview addSubview:col];
    
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(bgview.width-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
    seimg.image=imageName(@"dlad");
    [bgview addSubview:seimg];
    
    if(indexPath.section==2){
        if(indexPath.row==3){
            [bgview  addSubview:self.tzview];
            
            if( [isRedvd intValue]==1){
                self.tzview.hidden=NO;
            }
            else{
                self.tzview.hidden=YES;
            }
        }
        
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return gdValue(10);
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
    UIView*view=[UIView new];
  
    view.backgroundColor=cyColor;
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(55);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0){
        adminWalletViewController*adVc=[[adminWalletViewController alloc]init];
        [adVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:adVc animated:YES];
    }
    else if (indexPath.section==1){
        addrestViewController*adrVc=[[addrestViewController alloc]init];
        [adrVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:adrVc animated:YES];
    }
    else if (indexPath.section==2){
        
//        if(indexPath.row==0){
//
//            invtfrindViewController*vtVc=[[invtfrindViewController alloc]init];
//            [vtVc setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:vtVc animated:YES];
//
//
//
//        }
        if (indexPath.row==0){
            if(![self isCreasBSC]){
                userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
                WeakSelf;
                authsmView*view=[[authsmView alloc]initWithFrame:SCREEN_FRAME tit:@"BSC"];
                view.numblock = ^{
                    addAsstsViewController*addVc=[[addAsstsViewController alloc]init];
                    addVc.typrt=1;
//                    addVc.userModel=usModel;
                    [addVc setHidesBottomBarWhenPushed:YES];
                    [weakSelf.navigationController pushViewController:addVc animated:YES];

                };

                return;
            }
            else{
                
                //bsc/0x01201020120?platform=android
                h5ViewController*hVc=[[h5ViewController alloc]init];
                [hVc setHidesBottomBarWhenPushed:YES];
                hVc.type=2;
                hVc.baseLab.text=_tiArr[indexPath.section][indexPath.row];
                hVc.addtrse=_addstr;
                for(helpModel*model in self.dataArr){
                    if([model.code  isEqualToString:@"ACTIVITY_CENTER"] ){
                        helpDetModel*mod=model.value[0];
                        
                        hVc.url=[NSString stringWithFormat:@"%@bsc/%@?platform=ios",mod.value,_addstr];
                        break;
                    }
                }
                [self.navigationController pushViewController:hVc animated:YES];
            }
        }
     
       else  if(indexPath.row==1){
            h5ViewController*hVc=[[h5ViewController alloc]init];
            [hVc setHidesBottomBarWhenPushed:YES];
          
            hVc.baseLab.text=_tiArr[indexPath.section][indexPath.row];
            
            for(helpModel*model in self.dataArr){
                if([model.code isEqualToString:@"HELP_CENTER_URl"] ){
                    helpDetModel*mod=model.value[0];
                    
                    hVc.url=mod.value;
                    break;
                }
            }
            [self.navigationController pushViewController:hVc animated:YES];
        }
        else if (indexPath.row==2){
            h5ViewController*hVc=[[h5ViewController alloc]init];
            [hVc setHidesBottomBarWhenPushed:YES];
          
            hVc.baseLab.text=_tiArr[indexPath.section][indexPath.row];
            
            for(helpModel*model in self.dataArr){
                if([model.code  isEqualToString:@"USE_THE_TUTORIAL"] ){
                    helpDetModel*mod=model.value[0];
                    
                    hVc.url=mod.value;
                    break;
                }
            }
            [self.navigationController pushViewController:hVc animated:YES];
        }
        else if (indexPath.row==3){
            aboutUSViewController*abvc=[[aboutUSViewController alloc]init];
            
            for(helpModel*model in self.dataArr){
                if([model.code  isEqualToString:@"ABOUT_US_URL"] ){
                 
                    abvc.daArr=model.value;
                
                }
            }
            [abvc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:abvc animated:YES];
            
        }
        
     
        
    }
    else if (indexPath.section==3){
        mySetViewController*mystVc=[[mySetViewController alloc]init];
        [mystVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:mystVc animated:YES];
    }
  
 
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,_headView.bottom, SCREEN_WIDTH,SCREEN_HEIGHT-WD_TabBarHeight-_headView.bottom) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=cyColor;
       
        [_mainTableview registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"mysetID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(UIView*)headView{
    
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WDNavHeight+gdValue(40))];
        _headView.backgroundColor=cyColor;
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), WDNavHeight, gdValue(100), gdValue(30))];
        tlab.text=getLocalStr(@"myd");
        tlab.font=fontMidNum(23);
        tlab.textColor=ziColor;
        [_headView addSubview:tlab];
        
        
        
        
        
    }
    return _headView;
}

-(UIView*)tzview{
    if(!_tzview){
    _tzview=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(40), gdValue(47)/2, gdValue(8),gdValue(8))];
        _tzview.backgroundColor=UIColorFromRGB(0xFA6400);
        ViewRadius(_tzview, gdValue(4));
        _tzview.hidden=YES;
    }
    return _tzview;
}
-(void)resqData{
    
    
    [Request GET:sysConfigAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"sd--%@",[Utility strData:responseObject]);
        [self jsonJx:responseObject];
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)jsonJx:(id)responseObject{
        [self.dataArr removeAllObjects];
      
     
       
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
        NSArray*arr=responseObject[@"data"];
        if(arr.count){
            
            for(NSDictionary*dic in arr){
                helpModel*model=[helpModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                
            }
        }
        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:sysConfigAPI];
    }
 }
#pragma mark 更新版本
-(void)upVesUI{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
      NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    NSDictionary*dict=@{@"version":currentVersion};
    
    NSDictionary*dic=@{@"platform":@"iOS"};
    [Request GET:versAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"srr--%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            NSDictionary*dict=responseObject[@"data"];
            NSString*vv=[NSString stringWithFormat:@"%@",dict[@"version"]];
//            NSString*type=[NSString stringWithFormat:@"%@",dict[@"type"]];
            NSString*remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
            NSString*linkUrl=[NSString stringWithFormat:@"%@",dict[@"linkUrl"]];
            
            if(![self versionCompareFirst:currentVersion andVersionSecond:vv]){//小于最新版本
          
                self.tzview.hidden=NO;
                
                [[NSUserDefaults standardUserDefaults]setObject:remark forKey:@"isremark"];
                [[NSUserDefaults standardUserDefaults]setObject:linkUrl forKey:@"islinkUrl"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
//
//                upVesView*view=[[upVesView alloc]initWithFrame:SCREEN_FRAME type:type remark:remark linkUrl:linkUrl];
//                [view show];
                
            }
            
            
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    
}

// 方法调用
- (BOOL)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second
{
NSArray *versions1 = [first componentsSeparatedByString:@"."];
NSArray *versions2 = [second componentsSeparatedByString:@"."];
NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
// 确定最大数组
NSInteger a = (ver1Array.count> ver2Array.count)?ver1Array.count : ver2Array.count;
// 补成相同位数数组
if (ver1Array.count < a) {
    for(NSInteger j = ver1Array.count; j < a; j++)
    {
        [ver1Array addObject:@"0"];
    }
}
else
{
    for(NSInteger j = ver2Array.count; j < a; j++)
    {
        [ver2Array addObject:@"0"];
     }
     }
    // 比较版本号
int result = [self compareArray1:ver1Array andArray2:ver2Array];
if(result == 1)
{
    return YES;
}
else if (result == -1)
{
    return NO;
}
else if (result ==0 )
{
    return YES;
}
    return  NO;
}
// 比较版本号
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
for (int i = 0; i< array2.count; i++) {
    NSInteger a = [[array1 objectAtIndex:i] integerValue];
    NSInteger b = [[array2 objectAtIndex:i] integerValue];
    if (a > b) {
        return 1;
    }
    else if (a < b)
    {
        return -1;
    }
}
return 0;
}


-(BOOL)isCreasBSC{
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    for(walletModel*wamm in usmodel.walletArray){
        if([wamm.name isEqualToString:@"BSC"]){
            _addstr=wamm.addres;
            
            return YES;
        }
    }
    
    return NO;
    
   
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
