//
//  markettViewController.m
//  RooWallet
//
//  Created by mac on 2021/7/20.
//

#import "markettViewController.h"
#import "markTableViewCell.h"
#import "marktModel.h"
#import "marketSocketManager.h"
@interface markettViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,copy)NSArray*trr;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,assign)NSInteger seIndx;//0默认，1涨，2降

@property(nonatomic,strong)NSMutableArray*scourArr;
@property(nonatomic,strong)UIView*headView;


@end

@implementation markettViewController
-(NSMutableArray*)scourArr{
    if(!_scourArr){
        _scourArr=[NSMutableArray array];
    }
    return _scourArr;
}
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _seIndx=0;
    self.leftBtn.hidden=YES;
    
    _trr=@[getLocalStr(@"wark2"),getLocalStr(@"wark3"),getLocalStr(@"wark4")];
    
    self.baseLab.text=getLocalStr(@"wark1");
    [self setUI];
    
    [self frsh];
    
    [MBProgressHUD showHUD];
    [self getResqData];
//    [self setmarkSocket];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(markbhua:) name:@"markbhua" object:nil];
    // Do any additional setup after loading the view.
}
-(void)markbhua:(NSNotification*)obj{
    [self.dataArr removeAllObjects];
    
    NSArray*art=(NSArray*)obj.object;
    
    for(marktModel*model in art){
        if([model.isShow isEqualToString:@"1"]){
        [self.dataArr addObject:model];
        }
    }
 
    [self chenckData];
    
    
    
    
}
#pragma mark --处理数据
-(void)chenckData{
    
    [self.scourArr removeAllObjects];
   
    [self.scourArr addObjectsFromArray:self.dataArr];
  
     if(_seIndx==1){
         
         [self.scourArr sortUsingComparator:^NSComparisonResult(marktModel* obj1,marktModel* obj2) {
         if ([obj1.priceChangePercent floatValue]< [obj2.priceChangePercent floatValue]) {
             return  NSOrderedAscending;
         }else if(obj1.priceChangePercent == obj2.priceChangePercent){
             return NSOrderedSame;
         }else{
             return NSOrderedDescending;
         }
     }];
        
        
    }
    else if(_seIndx==2){
        
        [self.scourArr sortUsingComparator:^NSComparisonResult(marktModel* obj1,marktModel* obj2) {
                       if ([obj1.priceChangePercent floatValue] > [obj2.priceChangePercent floatValue]) {
                           return  NSOrderedAscending;
                       }else if(obj1.priceChangePercent == obj2.priceChangePercent){
                           return NSOrderedSame;
                       }else{
                           return NSOrderedDescending;
                       }
                   }];
        
    
        
    }
    
    [self.mainTableview reloadData];
}
-(void)setUI{
    [self.view addSubview:self.mainTableview];
}
-(void)frsh{
       MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upteData)];
        header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTableview.mj_header=header;
//     self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}
-(void)upteData{
    
    
    
    [self getResqData];
 
    [self.mainTableview.mj_footer resetNoMoreData];
}
-(void)getResqData{
    
    
    [Request GET:tigetTickAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
//        NSLog(@"sd---%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            NSArray*daArr=responseObject[@"data"];
            
            if(daArr.count>0){
                
                [self.dataArr removeAllObjects];
              
                for(NSDictionary*dic  in daArr){
                    
                    marktModel*model=[marktModel mj_objectWithKeyValues:dic];
                
                    if([model.isShow isEqualToString:@"1"]){
                    [self.dataArr addObject:model];
                    }
                    
                    
                    
                }
              
                
                [self chenckData];
                
            }
            
            
        }
 
        
        [self.mainTableview.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        
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
//         NSLog(@"Message===%@",message);
//        NSDictionary*dic=[weakSelf dictionaryWithJsonString1:message];
//        NSLog(@"sds--%@",dic);
         if (type == FLSocketReceiveTypeForMessage) {
             NSDictionary*responseObject=[weakSelf dictionaryWithJsonString1:message];
           
             NSArray*daArr=responseObject[@"data"];
             
             if(daArr.count>0){
                 
                 [self.dataArr removeAllObjects];
                 for(NSDictionary*dic  in daArr){
                     
                     marktModel*model=[marktModel mj_objectWithKeyValues:dic];
                 

                     
                     if([model.isShow isEqualToString:@"1"]){
                     [self.dataArr addObject:model];
                     }
                     
                     
                     
                 }
                 [self.mainTableview reloadData];
             }
//             if([Utility getNumberID:dic[@"result"] num:200]){
  
//                [weakSelf getBuySellData:dic];
//             }
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

#pragma mark --TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.scourArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    markTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"markID" forIndexPath:indexPath];
    
    if(self.scourArr.count){
        
    cell.tsLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    
        cell.model=self.scourArr[indexPath.row];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return gdValue(30);
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
  
    for(UIView*vv in view.subviews){
        [vv removeFromSuperview];
    }
    view.backgroundColor=[UIColor whiteColor];
    

    
    for(int i=0;i<_trr.count;i++){
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
       
        
        [view addSubview:btn];
        
        
     
        btn.tag=2340+i;
        [btn addTarget:self action:@selector(hqck:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if(i==0){
            btn.frame=CGRectMake(gdValue(15),0, gdValue(60), gdValue(30));
            [btn setTitle:_trr[i] forState:UIControlStateNormal];
            [btn setTitleColor:zyincolor forState:UIControlStateNormal];
            btn.titleLabel.font=fontNum(11);
            btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        }
        else if (i==1){
            btn.frame=CGRectMake(SCREEN_WIDTH-gdValue(210), 0 ,gdValue(100), gdValue(30));
            [btn setTitle:_trr[i] forState:UIControlStateNormal];
            [btn setTitleColor:zyincolor forState:UIControlStateNormal];
            btn.titleLabel.font=fontNum(11);
            btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        }
        else if (i==2){
            btn.frame=CGRectMake(SCREEN_WIDTH-gdValue(82),0 ,gdValue(72), gdValue(30));
            
            
            UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(65), gdValue(10), gdValue(7), gdValue(10))];
            
            NSString*rt=[NSString stringWithFormat:@"markup_%ld",_seIndx+1];
         ;
            img.image=imageName(rt);
           
            [btn addSubview:img];
            
            UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gdValue(60), gdValue(30))];
            lab.text=_trr[i];
            lab.font=fontNum(11);
            lab.textColor=zyincolor;
            lab.textAlignment=NSTextAlignmentRight;
            [btn addSubview:lab];
            
        }
    }
    
    
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(60);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
 
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight-WD_TabBarHeight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=cyColor;
       
        [_mainTableview registerClass:[markTableViewCell class] forCellReuseIdentifier:@"markID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}


-(void)hqck:(UIButton*)sender{
    
    NSInteger indx=sender.tag-2340;
    if(indx==2){
        
        _seIndx++;
        if(_seIndx>2){
            _seIndx=0;
        }
        
      
        
        NSLog(@"sdd--%ld",_seIndx);
        
        
        [self chenckData];
        
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
