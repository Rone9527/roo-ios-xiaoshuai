//
//  defiDetView.m
//  RooWallet
//
//  Created by mac on 2021/8/3.
//

#import "defiDetView.h"

#import "defiMarkTableViewCell.h"

#import "defiModel.h"
#import "actShootView.h"
#import "defiDetXqViewController.h"

@interface defiDetView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,assign)int PageCount;
@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString*sortBy;

@property(nonatomic,strong)NSMutableArray*deIDArr;


@end

@implementation defiDetView
-(NSMutableArray*)deIDArr{
    if(!_deIDArr){
        _deIDArr=[NSMutableArray array];
    }
    return _deIDArr;
}
- (instancetype)initWithFrame:(CGRect)frame  type:(int)type{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _type=type;
        
        NSArray*arty=@[@"",@"hots",@"funds",@"incrs",@"recents"];
        _sortBy=arty[type];
        
       
        self.backgroundColor=[UIColor whiteColor];
        
        [self addSubview:self.setTableView];
        
        
         [self addSubview:self.noView];
        
        
        [self frsh];
        
        if(_type==0){
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getArrData) name:@"zxmarkdefi" object:nil];
        }
      
        
        
    }
    
 
    return self;
}
-(void)setUI{
    _page=1;
   
    [MBProgressHUD showHUD];
    
    [self resqData:_page];
//
    
}
-(void)getconidvoid{
    
    NSArray*arr=[defiModel bg_findAll:bg_DeFizxname];
    
    [self.deIDArr removeAllObjects];
    
    arr = [[arr reverseObjectEnumerator] allObjects];
    
    [arr enumerateObjectsUsingBlock:^(defiModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.deIDArr addObject:model.identity];
        
    }];
    
    
}
-(void)getArrData{
    
    [self.dataArr removeAllObjects];
    
    NSArray*arr=[defiModel bg_findAll:bg_DeFizxname];
    
    
   arr = [[arr reverseObjectEnumerator] allObjects];
    
    
    
    [self.dataArr addObjectsFromArray:arr];
    
   
    
    if(self.dataArr.count){
      
        self.noView.hidden=YES;
        [self zxeData];
        [self.setTableView reloadData];
    }
    else{
     
        self.noView.hidden=NO;
        [self.setTableView reloadData];
    }
    
  
    
    
    [self getconidvoid];
    
   
    
   
    
    
    
    
}
-(void)updatermb{
    
    [self.setTableView reloadData];
    
}
#pragma mark --请求数据
-(void)qiuData{
    
   
    
    if(self.dataArr.count==0){
       
       
            if(self.type==0){//自选
              
                [self getArrData];
                
        
            }
            else{
                
                [self getconidvoid];
                [self setUI];
                
                
            }
            
          
            
   
}
    
    else{
        NSLog(@"%d---youl",_type);
        
    }
}

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark --理财分页
-(void)resqData:(int)page{
    
    NSString*pagee=[NSString stringWithFormat:@"%d",page];
    
   
    NSDictionary*dic=@{@"pageNum":pagee,@"pageSize":@"10",@"sortBy":_sortBy};
    
  

    [Request GET:defipairAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//
        if(self.type==3){
        NSLog(@"data--%@",[Utility strData:responseObject]);
        }
//
        NSDictionary*dat=responseObject[@"data"];
        
        if(dat.count){
            
            self.PageCount=[[NSString stringWithFormat:@"%@",dat[@"totalPage"]] intValue];
            
            NSArray*datrr=dat[@"data"];
            if(datrr.count){
                for(NSDictionary*dict in  datrr){
                   defiModel*model=[defiModel mj_objectWithKeyValues:dict];
                    [self.dataArr addObject:model];

            }
                
            }
        }
              
        if(self.dataArr.count){
            self.noView.hidden=YES;
            self.setTableView.mj_footer.hidden=NO;
//            self.mainTableview.mj_footer.hidden=YES;
//            self.mainTableview.mj_header.hidden=YES;
        }
        else{
            self.setTableView.mj_header.hidden=NO;
            self.setTableView.mj_footer.hidden=YES;
            self.noView.hidden=NO;
        }
     
        [self.setTableView reloadData];
        [self.setTableView.mj_header endRefreshing];
        [self.setTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"err--%@",[error localizedDescription]);
        [self.setTableView.mj_header endRefreshing];
        [self.setTableView.mj_footer endRefreshing];
    }];
}


#pragma mark --自选
-(void)zxeData{
    [self getconidvoid];
    
//    NSArray*arr=[defiModel bg_findAll:bg_DeFizxname];
//    NSMutableArray*art=[NSMutableArray array];
//    [art addObjectsFromArray:arr];
//
    
    NSString*idstr=[self.deIDArr componentsJoinedByString:@","];
    NSDictionary*dic=@{@"ids":idstr};
    
//    NSLog(@"sd--%@",dic);
    
    [Request GET:deflistAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"s---%@",[Utility strData:responseObject]);
        
        NSArray*datrr=responseObject[@"data"];
       
         
          
            if(datrr.count){
                [self.dataArr removeAllObjects];
                for(NSDictionary*dict in  datrr){
                   defiModel*model=[defiModel mj_objectWithKeyValues:dict];
                    
                    
//                    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"identity"),bg_sqlValue(model.identity)];
//                  BOOL isdel=  [defiModel bg_delete:bg_DeFizxname where:where];
//                    if(isdel){
//                        model.bg_tableName=bg_DeFizxname;
//                        [model bg_save];
//
//                    }
                    
                  
                    
                    
                    [self.dataArr addObject:model];
                    

            }
                
            }
        [self.setTableView reloadData];
//        [MBProgressHUD hideHUD];
        [self.setTableView.mj_header endRefreshing];
        [self.setTableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUD];
        [self.setTableView.mj_header endRefreshing];
        [self.setTableView.mj_footer endRefreshing];
    }];
    
}

-(void)frsh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
    self.setTableView.mj_header=header;
    if(self.type!=0){
     self.setTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
    }
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
    
    if(self.type==0){
        self.setTableView.mj_footer.hidden=YES;
        if(self.dataArr.count){
        [self zxeData];
        }
        
    }
    else{
        self.setTableView.mj_footer.hidden=NO;
        
        _page=1;
        
        [self.dataArr removeAllObjects];
        
        [self resqData:_page];
        [self.setTableView.mj_footer resetNoMoreData];
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    defiMarkTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"defiID" forIndexPath:indexPath];

    if(self.dataArr.count){
        
        cell.model=self.dataArr[indexPath.row];
        
        //添加长按手势
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPrefss:)];
        
        longPressGesture.minimumPressDuration=0.5f;//设置长按 时间
        [cell addGestureRecognizer:longPressGesture];
        
        
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(60);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 1;
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
        
        
    defiDetXqViewController*defidetVc=[[defiDetXqViewController alloc]init];
    [defidetVc setHidesBottomBarWhenPushed:YES];
        defidetVc.model=self.dataArr[indexPath.row];
    [[Utility dc_getCurrentVC].navigationController pushViewController:defidetVc animated:YES
     ];
    
    }
}

#pragma mark  长按点击
-(void)cellLongPrefss:(UILongPressGestureRecognizer *)longRecognizer{
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.setTableView];
        NSIndexPath * indexPath = [self.setTableView indexPathForRowAtPoint:location];
        
        
       
        
      
        if(_type!=0){
            
            [self getconidvoid];
            WeakSelf;
            
            defiModel*model=self.dataArr[indexPath.row];
            
            if([self.deIDArr containsObject:model.identity]){//已经添加
                actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:@[@"删除自选",@"waqux"] tis:getLocalStr(@"取消自选后，将不在自选中显示")];
                [view show];
                    
                    view.getIndx = ^(NSInteger indx) {
                        defiModel*model=weakSelf.dataArr[indexPath.row];
                        
                        
                        [weakSelf.dataArr removeObject:model];
                        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"identity"),bg_sqlValue(model.identity)];
                        [defiModel bg_delete:bg_DeFizxname where:where];
    
                        [MBProgressHUD showText:getLocalStr(@"sccg")];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"zxmarkdefi" object:nil];
                        
                        

                    };
                
            }
            else{
                actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:@[@"添加自选",@"waqux"] tis:getLocalStr(@"添加自选后，将在自选中显示")];
                [view show];
                    
                    view.getIndx = ^(NSInteger indx) {
                        
                        defiModel*model=weakSelf.dataArr[indexPath.row];
                        model.bg_tableName=bg_DeFizxname;
                        [model bg_save];
                        [MBProgressHUD showText:getLocalStr(@"添加成功")];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"zxmarkdefi" object:nil];
        //                bg_DeFizxname
                        
                    };
            }
            
           
       
        
            
        }
        else{
            WeakSelf;
            
            defiModel*modell=weakSelf.dataArr[indexPath.row];
            
            
            NSLog(@"s---%@  d--%ld",modell.pairName,indexPath.row);
        actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:@[@"删除自选",@"waqux"] tis:getLocalStr(@"取消自选后，将不在自选中显示")];
        [view show];
            
            view.getIndx = ^(NSInteger indx) {
               
                
                NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"identity"),bg_sqlValue(modell.identity)];
                BOOL fg=[defiModel bg_delete:bg_DeFizxname where:where];
                if(fg){
                    [weakSelf.dataArr removeObject:modell];
                  
                    
                    [weakSelf getArrData];
                    [MBProgressHUD showText:getLocalStr(@"sccg")];
                }
                
       //
               

        
            };
        }
        //可以得到此时你点击的哪一行
        
        //在此添加你想要完成的功能
        
    }
    
    
}




-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,self.height) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= [UIColor whiteColor];

        
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[defiMarkTableViewCell class] forCellReuseIdentifier:@"defiID"];
//        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}


-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(100), SCREEN_WIDTH,self.setTableView.height-gdValue(100))imgstr:@"nodata" tis:getLocalStr(@"暂无数据")];
        _noView.hidden=NO;
    }
    
    return _noView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
