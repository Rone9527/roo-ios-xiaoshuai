//
//  aboutUSViewController.m
//  RooWallet
//
//  Created by mac on 2021/8/11.
//

#import "aboutUSViewController.h"
#import "helpModel.h"
#import "h5ViewController.h"
#import "upVesView.h"


@interface aboutUSViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)NSMutableArray*urlArr;
@property(nonatomic,copy)NSString *currentVersion;
@property(nonatomic,copy)UIView*tzview;

@end

@implementation aboutUSViewController
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray*)urlArr{
    if(!_urlArr){
        _urlArr=[NSMutableArray array];
    }
    return _urlArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=getLocalStr(@"关于我们");
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
      _currentVersion =[NSString stringWithFormat:@"v %@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
    
    [self.dataArr addObject:getLocalStr(@"版本号")];
    [self.dataArr addObject:getLocalStr(@"用户协议")];
    [self.dataArr addObject:getLocalStr(@"隐私协议")];
    [self.urlArr addObject:@""];
    [self.urlArr addObject:@""];
    [self.urlArr addObject:@""];
    
    for(helpDetModel *model in self.daArr){
        
        if(![model.name isEqualToString:@"用户协议"] && ![model.name isEqualToString:@"隐私协议"]){
//            [self.dataArr insertObject:getLocalStr(@"用户协议") atIndex:1];
//            [self.urlArr insertObject:model.value atIndex:1];
           
            [self.dataArr addObject:model.name];
            
            [self.urlArr addObject:model.value];
            

        }
        else if ([model.name isEqualToString:@"隐私协议"]){
            
            [self.urlArr replaceObjectAtIndex:2 withObject:model.value];
           
        }
        else if ([model.name isEqualToString:@"用户协议"]){
            
            [self.urlArr replaceObjectAtIndex:1 withObject:model.value];
           
        }
        
    }
    
    [self.view addSubview:self.mainTableview];
    
    // Do any additional setup after loading the view.
}
#pragma mark --TableViewDelegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"mysetID" forIndexPath:indexPath];
    
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIView*bgview=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), 0, SCREEN_WIDTH-gdValue(30), gdValue(55))];
    bgview.backgroundColor=cyColor;
    ViewRadius(bgview, gdValue(6));
    [cell.contentView addSubview:bgview];
    
    UILabel*nalab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(100), gdValue(25))];
    nalab.text=self.dataArr[indexPath.row];
    nalab.textColor=ziColor;
    nalab.font=fontNum(16);
    [bgview addSubview:nalab];
    
    
    if(indexPath.row==0){
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(bgview.width-gdValue(70), gdValue(15), gdValue(55), gdValue(25))];
        tlab.text=_currentVersion;
        tlab.textColor=zyincolor;
        tlab.font=fontNum(14);
        tlab.textAlignment=NSTextAlignmentRight;
        [bgview addSubview:tlab];
        if( [isRedvd intValue]==1){
//            self.tzview.hidden=NO;
            [bgview addSubview:self.tzview];
        }
        else{
//            self.tzview.hidden=YES;
        }
        
    }
    else if (indexPath.row==1||indexPath.row==2){
        UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(bgview.width-gdValue(21), gdValue(21), gdValue(6), gdValue(13))];
        seimg.image=imageName(@"dlad");
        [bgview addSubview:seimg];
    }
    else{
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(bgview.width-gdValue(215), gdValue(15), gdValue(200), gdValue(25))];
        tlab.text=self.urlArr[indexPath.row];
        tlab.textColor=mainColor;
        tlab.font=fontNum(16);
        tlab.textAlignment=NSTextAlignmentRight;
        [bgview addSubview:tlab];
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
  
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    if(indexPath.row==2){
        return gdValue(85);
    }
    return gdValue(60);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==0){
        if( [isRedvd intValue]==1){
        NSString*str1=[[NSUserDefaults standardUserDefaults]objectForKey:@"isremark"];
        NSString*str2=[[NSUserDefaults standardUserDefaults]objectForKey:@"islinkUrl"];
            NSString*str3=[[NSUserDefaults standardUserDefaults]objectForKey:@"isverst"];
            
            
        upVesView*view=[[upVesView alloc]initWithFrame:SCREEN_FRAME type:@"0" remark:str1 linkUrl:str2 vers:str3] ;
            [view show];
        }
        else{
            
            [MBProgressHUD showText:getLocalStr(@"当前为最新版本")];
        }
    }
    else{
        
     
       
       
       
        
        if(indexPath.row<3){
        h5ViewController*hVc=[[h5ViewController alloc]init];
        [hVc setHidesBottomBarWhenPushed:YES];

        hVc.baseLab.text=_dataArr[indexPath.row];

            NSString*wurl=[self.urlArr[indexPath.row] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            hVc.url=wurl;

        [self.navigationController pushViewController:hVc animated:YES];
    }
        else{
            NSString*wurl=[self.urlArr[indexPath.row] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication]openURL:Url_Str(wurl) options:@{} completionHandler:nil];
        }

    }
    
    
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=[UIColor whiteColor];
        _mainTableview.tableHeaderView=self.headView;
        [_mainTableview registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"mysetID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}
-(UIView*)tzview{
    if(!_tzview){
    _tzview=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(105), gdValue(47)/2, gdValue(8),gdValue(8))];
        _tzview.backgroundColor=UIColorFromRGB(0xFA6400);
        ViewRadius(_tzview, gdValue(4));
//        _tzview.hidden=YES;
    }
    return _tzview;
}
-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(162))];
        _headView.backgroundColor=[UIColor whiteColor];
        
        UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(75))/2, gdValue(20), gdValue(75), gdValue(75))];
        log.image=imageName(@"mylog");
        [_headView addSubview:log];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, log.bottom+gdValue(18), SCREEN_WIDTH,gdValue(30))];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.textColor=ziColor;
        lab.font=fontBoldNum(20);
        lab.text=@"RooWallet";
        [_headView addSubview:lab];
        
        
        
    }
    return _headView;
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
