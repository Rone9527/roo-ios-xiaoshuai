//
//  jysMarkViewController.m
//  RooWallet
//
//  Created by mac on 2021/7/30.
//

#import "jysMarkViewController.h"
#import "jysmarkTableViewCell.h"
#import "coinsModel.h"
#import "jysmarkModel.h"
#import "jysMarkView.h"

@interface jysMarkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,copy)NSArray*trr;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,strong)jysMarkView*markView;

@end

@implementation jysMarkViewController

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    
    NSString*strf=[NSString stringWithFormat:getLocalStr(@"最新价"),cmod.icon];
    _trr=@[getLocalStr(@"交易所"),strf,getLocalStr(@"24H成交量")];
    
    self.baseLab.text=[NSString stringWithFormat:@"%@%@",_symodel.symbol,getLocalStr(@"交易所行情")];
    
    
    [self.view addSubview:self.headView];
    
    [self.view addSubview:self.mainTableview];
    [self.mainTableview addSubview:self.noView];
    
    [MBProgressHUD showHUD];
    [self reqsData];
    
    // Do any additional setup after loading the view.
}


-(void)reqsData{
    
    
    NSDictionary*dic=@{@"baseAsset":_symodel.symbol};
//    NSLog(@"sd---%@",dic);
    
    [Request GET:getPlatAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"ddd--%@",[Utility strData:responseObject]);
        
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
          NSArray*arr=responseObject[@"data"];
            
            
            if(arr.count){
                
                for(NSDictionary*dict in arr){
                    jysmarkModel*model=[jysmarkModel mj_objectWithKeyValues:dict];
                    
                    [self.dataArr addObject:model];
                    
                }
                
                self.noView.hidden=YES;
                [self.mainTableview reloadData];
                
                
            }
            
            
        }
        
        [MBProgressHUD hideHUD];
        
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
}
#pragma mark --TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    jysmarkTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"jysmarkID" forIndexPath:indexPath];
    
    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
        
    }
   
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return gdValue(40);
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
    
    UIView*vg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(10))];
    vg.backgroundColor=cyColor;
    [view addSubview:vg];
    
    
    for(int i=0;i<_trr.count;i++){
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), vg.bottom+gdValue(5), gdValue(60), gdValue(20))];
        tlab.text=_trr[i];
        tlab.textColor=zyincolor;
        tlab.font=fontNum(11);
        [view addSubview:tlab];
        
        if(i==1){
            tlab.frame=CGRectMake(SCREEN_WIDTH-gdValue(230), vg.bottom+gdValue(5) ,gdValue(100), gdValue(20));
            tlab.textAlignment=NSTextAlignmentRight;
        }
        else if (i==2){
            tlab.frame=CGRectMake(SCREEN_WIDTH-gdValue(115), vg.bottom+gdValue(5) ,gdValue(100), gdValue(20));
            tlab.textAlignment=NSTextAlignmentRight;
            
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
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,_headView.bottom, SCREEN_WIDTH,SCREEN_HEIGHT-_headView.bottom) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=cyColor;
//        _mainTableview.tableHeaderView=self.headView;
        
        UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(60))];
        fotv.backgroundColor=[UIColor whiteColor];
        _mainTableview.tableFooterView=fotv;
        
        
        [_mainTableview registerClass:[jysmarkTableViewCell class] forCellReuseIdentifier:@"jysmarkID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        _mainTableview.bounces=NO;
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(50), SCREEN_WIDTH,self.mainTableview.height-gdValue(50)) imgstr:@"nodata" tis:getLocalStr(@"暂无数据")];
        _noView.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _noView;
}

-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, gdValue(226))];
        
        _headView.backgroundColor=[UIColor whiteColor];
        [_headView addSubview:self.markView];
        
    }
    return _headView;
}


-(jysMarkView*)markView{
    if(!_markView){
        _markView=[[jysMarkView alloc]initWithFrame:CGRectMake(0, gdValue(20), SCREEN_WIDTH, gdValue(216)) baseAsset:_symodel.symbol];
        _markView.backgroundColor=[UIColor whiteColor];
    }
    return _markView;
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
