//
//  conductView.m
//  RooWallet
//
//  Created by mac on 2021/7/7.
//

#import "conductView.h"
#import "conductVTableViewCell.h"
#import "conduModel.h"
#import "dapptyModel.h"
#import "dappDetViewController.h"
#import "walletNodesModel.h"
#import "authsmView.h"
#import "addAsstsViewController.h"
#import "fangwenView.h"
#import "frsitFWView.h"


@interface conductView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,assign)int PageCount;

@end

@implementation conductView
- (instancetype)initWithFrame:(CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=cyColor;
        [self setUI];
        
    }
    
 
    return self;
}
-(void)setUI{
   
    _page=1;
    
    [self addSubview:self.setTableView];
    [self addSubview:self.noView];
    [self frsh];
    
//    [self resqData:_page];
    
    
}

-(void)qiuData{
    
    if(self.dataArr.count==0){
        [MBProgressHUD showHUD];
    [self resqData:_page];
        
    }
    else{
        NSLog(@"licai----yiu");
    }
}

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(void)resqData:(int)page{
    
    NSString*pagee=[NSString stringWithFormat:@"%d",page];
    
   
    NSDictionary*dic=@{@"pageNum":pagee,@"pageSize":@"10"};
    
  

    [Request GET:finaciAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
        NSLog(@"data--%@",[Utility strData:responseObject]);
        
        NSDictionary*dat=responseObject[@"data"];
        
        if(dat.count){
            
            self.PageCount=[[NSString stringWithFormat:@"%@",dat[@"totalPage"]] intValue];
            
            NSArray*datrr=dat[@"data"];
            if(datrr.count){
                for(NSDictionary*dict in  datrr){
                    conduModel*model=[conduModel mj_objectWithKeyValues:dict];
                    [self.dataArr addObject:model];
                    
            }
                
            }
        }
              
        if(self.dataArr.count){
            self.noView.hidden=YES;
           
//            self.mainTableview.mj_footer.hidden=YES;
//            self.mainTableview.mj_header.hidden=YES;
        }
        else{
            self.setTableView.mj_footer.hidden=YES;
            self.noView.hidden=NO;
        }
     
        [self.setTableView reloadData];
        [self.setTableView.mj_header endRefreshing];
        [self.setTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    
        [self.setTableView.mj_header endRefreshing];
        [self.setTableView.mj_footer endRefreshing];
    }];
}


-(void)frsh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
    self.setTableView.mj_header=header;
     self.setTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}

-(void)loadLastData{
    
    if(_page>=_PageCount){
        [self.setTableView.mj_footer endRefreshing];
        //        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [self.setTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        
        _page++;
        [self resqData:_page];
    }
 
}
- (void)loadNewData
{
    
    self.setTableView.mj_footer.hidden=NO;
    
    _page=1;
    
    [self.dataArr removeAllObjects];
    
    [self resqData:_page];
    [self.setTableView.mj_footer resetNoMoreData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    conductVTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"actID" forIndexPath:indexPath];

    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(134);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return gdValue(15);
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
    vv.backgroundColor=cyColor;
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if(self.dataArr.count){
        conduModel*cmodel=self.dataArr[indexPath.row];
        
    dapptyModel*model=[[dapptyModel alloc]init];
    
    model.name=cmodel.name;
  
    model.links=cmodel.link;
        model.icon=cmodel.logo;
    model.chain=cmodel.chainCode;
    model.tyy=@"1";
    model.discription=cmodel.ascription;
    
       
        model= [Utility setmodelValue:model];
        
        [self notModel:model];
        
    }
}

-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,self.height) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= cyColor;

        
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[conductVTableViewCell class] forCellReuseIdentifier:@"actID"];
//        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(100), SCREEN_WIDTH,self.setTableView.height-gdValue(100))imgstr:@"nodata" tis:getLocalStr(@"zwjz")];
        _noView.hidden=NO;
    }
    
    return _noView;
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
     
        frsitFWView*frstVc=[[frsitFWView alloc]initWithFrame:SCREEN_FRAME modell:model];
        frstVc.block = ^{
            dappDetViewController*depVc=[[dappDetViewController alloc]init];
            [depVc setHidesBottomBarWhenPushed:YES];
            depVc.dappmodel=model;

            [depVc setHidesBottomBarWhenPushed:YES];

            [[Utility dc_getCurrentVC].navigationController pushViewController:depVc animated:YES];
        };
        
        
        [frstVc show];
        return;
        
    }
    
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
