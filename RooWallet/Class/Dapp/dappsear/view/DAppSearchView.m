//
//  DAppSearchView.m
//  RooWallet
//
//  Created by mac on 2021/7/17.
//

#import "DAppSearchView.h"
#import "dappTableViewCell.h"
#import "dapptyModel.h"
#import "walletNodesModel.h"
#import "dappDetViewController.h"
#import "selectMainView.h"
#import "authsmView.h"
#import "addAsstsViewController.h"


@interface DAppSearchView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)UITableView*searchTableView;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)UIView*sheadView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;

@property(nonatomic,strong)UILabel*serLab;
@property(nonatomic,copy)NSArray*serArr;

@property(nonatomic,strong)noDataView*noView;

@end

@implementation DAppSearchView



- (instancetype)initWithFrame:(CGRect)frame historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
//        self.hotArray = hotArr;
        self.backgroundColor=UIColorFromRGB(0xffffff);
        [self addSubview:self.setTableView];
        [self addSubview:self.searchTableView];
        
        [self addSubview:self.noView];
        
        if(self.historyArray.count<=0){
            self.noView.hidden=NO;
        }
        
    }
    return self;
}
-(void)getsearData:(NSArray*)serarr tit:(NSString*)titstr{
    _serArr=serarr;
    _serLab.text=titstr;
//    if(serarr.count>0){
//        NSLog(@"有值");
        self.noView.hidden=YES;
        self.searchTableView.hidden=NO;
//    }
    
    [self.searchTableView reloadData];
}

-(void)sethisUIArr:(NSArray*)arr{
    self.searchTableView.hidden=YES;
    
    [_historyArray removeAllObjects];
    [_historyArray addObjectsFromArray:arr];
    
    if(_historyArray.count<=0){
        _noView.hidden=NO;
    }
    [self.setTableView reloadData];
    
   
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.setTableView){
    return self.historyArray.count;
    }
    return self.serArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell*Cell=nil;
    if(tableView==self.setTableView){
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"hsetID" forIndexPath:indexPath];
    
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
    cell.backgroundColor= UIColorFromRGB(0xffffff);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(250), gdValue(25))];
    lab.text=self.historyArray[indexPath.row];
    lab.font=fontNum(16);
    lab.textColor=ziColor;
    [cell.contentView addSubview:lab];
    
    UIButton*scBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    scBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45), gdValue(25)/2, gdValue(30), gdValue(30));
    [scBtn setImage:imageName(@"scbtn") forState:UIControlStateNormal];
    
    [cell.contentView addSubview:scBtn];
    scBtn.tag=1000+indexPath.row;
    [scBtn addTarget:self action:@selector(scck:) forControlEvents:UIControlEventTouchUpInside];
        Cell=cell;
    }
    else{
        dappTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"serhID" forIndexPath:indexPath];
        
        cell.model=self.serArr[indexPath.row];
        
        Cell=cell;
        
        
    }
    
    
    return Cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.setTableView){
        return gdValue(55);
        
    }
    
    return gdValue(70);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if(tableView==self.searchTableView){
        return gdValue(40);
    }
    return 0.01;
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
    if(tableView==self.searchTableView){
        UIView*vv=[UIView new];
        vv.backgroundColor=[UIColor whiteColor];
        
        for(UIView*vb in vv.subviews){
            [vb removeFromSuperview];
        }
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(9), gdValue(100), gdValue(22))];
        lab.text=@"DApp：";
        lab.textColor=ziColor;
        lab.font=fontNum(15);
        [vv addSubview:lab];
        
        
        return vv;
       
    }
    
    
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];;
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if(tableView==self.setTableView){
        
        if([_delagate respondsToSelector:@selector(getseleindex:)]){
            [_delagate getseleindex:_historyArray[indexPath.row]];
            
        }
    }
    else{
        
//        [self setHistoryArrWithStr:self.serLab.text];
        
        dapptyModel*model=self.serArr[indexPath.row];
        model= [Utility setmodelValue:model];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DAPPtangck" object:model];
        
     
//
//        if([Utility isBlankString:model.addres]){
//
//            NSString*srt=[NSString stringWithFormat:@"没有该%@链资产",model.chain];
//            [MBProgressHUD showText:srt];
//            return;
//        }
//
//        dappDetViewController*depVc=[[dappDetViewController alloc]init];
//        [depVc setHidesBottomBarWhenPushed:YES];
//
//    //    NSLog(@"dddd---%@",model.links);
//        depVc.dappmodel=model;
//
//        [depVc setHidesBottomBarWhenPushed:YES];
//
//        [[Utility dc_getCurrentVC].navigationController pushViewController:depVc animated:YES];
//
    }
  
}
- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    NSLog(@"s--%ld",_historyArray.count);
}

-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= cyColor;

        _setTableView.tableHeaderView=self.headView;
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"hsetID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(UITableView*)searchTableView{
    if(!_searchTableView){
        _searchTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) style:UITableViewStylePlain];
        _searchTableView.dataSource=self;
        _searchTableView.delegate=self;
        _searchTableView.backgroundColor= [UIColor whiteColor];
        _searchTableView.hidden=YES;
        _searchTableView.tableHeaderView=self.sheadView;
        
       
        _searchTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [_searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"hsetID"];
        [_searchTableView registerClass:[dappTableViewCell  class] forCellReuseIdentifier:@"serhID"];
        _searchTableView.bounces=NO;
        _searchTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _searchTableView;
}
-(UIView*)sheadView{
    if(!_sheadView){
        
        _sheadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(50))];
        _sheadView.backgroundColor=[UIColor whiteColor];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(13), gdValue(85), gdValue(24))];
        lab.text=getLocalStr(@"前往DApp：");
        lab.font=fontNum(14);
        lab.textColor=zyincolor;
        [_sheadView addSubview:lab];
        
        UIButton*scBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        scBtn.frame=CGRectMake(lab.right, gdValue(10), SCREEN_WIDTH-gdValue(117), gdValue(30));
      
        _serLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(5), scBtn.width-gdValue(15), gdValue(20))];
        _serLab.textColor=mainColor;
        _serLab.font=fontNum(14);
        [scBtn addSubview:_serLab];
        
        UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(scBtn.width-gdValue(6), gdValue(9), gdValue(6), gdValue(12))];
        img.image=imageName(@"dlad");
        [scBtn addSubview:img];
        
        
        [_sheadView addSubview:scBtn];
       
        [scBtn addTarget:self action:@selector(searck) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _sheadView;
}
-(UIView*)headView{
    if(!_headView){
        
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(40))];
        _headView.backgroundColor=[UIColor whiteColor];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(8), gdValue(200), gdValue(24))];
        lab.text=getLocalStr(@"flsht25");
        lab.font=fontNum(16);
        lab.textColor=zyincolor;
        [_headView addSubview:lab];
        
        UIButton*scBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        scBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45), gdValue(5), gdValue(30), gdValue(30));
        [scBtn setImage:imageName(@"delbtn") forState:UIControlStateNormal];
        
        [_headView addSubview:scBtn];
       
        [scBtn addTarget:self action:@selector(delck) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _headView;
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:self.setTableView.bounds imgstr:@"serno" tis:getLocalStr(@"flsht26")];
        _noView.backgroundColor=[UIColor whiteColor];
        _noView.hidden=YES;
    }
    
    return _noView;
}
-(void)scck:(UIButton*)btn{
    NSInteger indx=btn.tag-1000;
    
    [_historyArray removeObjectAtIndex:indx];
    
    if(_historyArray.count<=0){
        _noView.hidden=NO;
    }
    
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    [self.setTableView reloadData];
    
}

-(void)delck{
    [_historyArray removeAllObjects];
    if(_historyArray.count<=0){
        _noView.hidden=NO;
    }
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    [self.setTableView reloadData];
}


#pragma mark --前往
-(void)searck{
    
    [self.superview endEditing:YES];
    
    selectMainView*view=[[selectMainView alloc]initWithFrame:SCREEN_FRAME  seleindx:999 arr:chinaCodeArr];
   
    view.type=@"1";
     WeakSelf;
     view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
         
         
//         [weakSelf setHistoryArrWithStr:weakSelf.serLab.text];
       
      
             dapptyModel*model=[[dapptyModel alloc]init];
             
                 model.name=weakSelf.serLab.text;
           
                 NSString*url=weakSelf.serLab.text;
                 if(![url hasPrefix:@"http"]){
                     url=[NSString stringWithFormat:@"http://%@",weakSelf.serLab.text];
                 }
                 model.links=url;
                 
             model.chain=nameStr;
             model.tyy=@"0";
           model.discription=weakSelf.serLab.text;
             
                
                 model= [Utility setmodelValue:model];
                 
                 [weakSelf notModel:model];
         
     
     
     };
    
     
    
   
   
    
}

-(void)notModel:(dapptyModel*)model{
//    NSLog(@"sdeeeeee---%@",model.addres);
    
    if([Utility isBlankString:model.addres]){
       
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
    
    
    

        dappDetViewController*depVc=[[dappDetViewController alloc]init];
        [depVc setHidesBottomBarWhenPushed:YES];
        depVc.dappmodel=model;

        [depVc setHidesBottomBarWhenPushed:YES];

        [[Utility dc_getCurrentVC].navigationController pushViewController:depVc animated:YES];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
