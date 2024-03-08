//
//  myNewsViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "myNewsViewController.h"
#import "LBJButton.h"
#import "RedPointBadgeView.h"
#import "DetTradViewController.h"
#import "myneswTableViewCell.h"
#import "noDataView.h"
#import "tranDetModel.h"
#import "JXCategoryView.h"
#import "xtnewsTableViewCell.h"
#import "newDetViewVC.h"
#import "neswModel.h"
#import "h5ViewController.h"

@interface myNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,strong)LBJButton*tradBtn;
@property(nonatomic,strong)LBJButton*servBtn;
@property(nonatomic,strong)RedPointBadgeView*redPointView1;
@property(nonatomic,assign)NSInteger selindx;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)NSMutableArray*newdataArr;
@property(nonatomic,copy)NSArray*sourArr;
@property(nonatomic,strong)UIButton*rBtn;
@property(nonatomic,strong)RedPointBadgeView*redPointView2;

@end

@implementation myNewsViewController

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray*)newdataArr{
    if(!_newdataArr){
        _newdataArr=[NSMutableArray array];
    }
    return _newdataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _selindx=0;
    [self setUI];
    [self setnavUI];
    
    [self getALLData];
    
    [self isredSHow];
    
    [self isxtShow];
    
    // Do any additional setup after loading the view.
}
#pragma mark -已读
-(void)yduck:(UIButton*)sender{
//    sender.selected=!sender.selected;
    
    NSArray*newArr=[tranDetModel bg_findAll:bg_pushNewname];
    NSArray*newArr1=[neswModel bg_findAll:bg_Newtpushname];
    
    for(tranDetModel*model in newArr){
        model.isYdu=1;
        [model bg_saveOrUpdate];
        
    }
    
    for(neswModel*modell in newArr1){
        modell.isYdu=1;
        [modell bg_saveOrUpdate];
    }
    
    [self getALLData];
    
    [self isredSHow];
    [self isxtShow];
    
    
   
}
-(void)getALLData{
    
//    if(_selindx==0){
        
    [self.dataArr removeAllObjects];
    
  _sourArr=[tranDetModel bg_findAll:bg_pushNewname];
//        NSLog(@"sd--%ld",_sourArr.count);
    
//       [self.dataArr addObjectsFromArray:newArr];
        self.dataArr=(NSMutableArray*)[[_sourArr reverseObjectEnumerator] allObjects];
    
    if(_selindx==0){
    if(self.dataArr.count){
        self.noView.hidden=YES;
    }
    else{
        self.noView.hidden=NO;
    }
    
    }
        
        
//    }
//    else{
        
        [self.newdataArr removeAllObjects];
        
        NSArray*arr=[neswModel bg_findAll:bg_Newtpushname];
       
        self.newdataArr=(NSMutableArray*)[[arr reverseObjectEnumerator] allObjects];

    [self.mainTableview reloadData];
    
    if(_selindx==1){
    if(self.newdataArr.count){
        self.noView.hidden=YES;
    }
    else{
        self.noView.hidden=NO;
    }
    
    }
    
}

-(void)isredSHow{
    
    for(tranDetModel*modle in self.dataArr){
        
        if(modle.isYdu==0){
            _redPointView1.hidden=NO;
//            _rBtn.selected=YES;
            _redPointView1.isRedview=YES;
            [_redPointView1 showTargetView:self.tradBtn forCount:1 location: RIGHT_TOP  color:UIColorFromRGB(0xFA6400)];
            return;
        }
        else{
//            _rBtn.selected=NO;
            _redPointView1.hidden=YES;
        }
    }
    
    if(_redPointView1.hidden==NO || _redPointView2.hidden==NO){
        _rBtn.selected=YES;
    }
    else{
        _rBtn.selected=NO;
    }
    
}

-(void)isxtShow{
    
    for(neswModel*modle in self.newdataArr){
        
//        NSLog(@"sd---%ld",modle.isYdu);
        
        if(modle.isYdu==0){
            _redPointView2.hidden=NO;
//            _rBtn.selected=YES;
            _redPointView2.isRedview=YES;
            
          
            
            [_redPointView2 showTargetView:self.servBtn forCount:1 location: RIGHT_TOP  color:UIColorFromRGB(0xFA6400)];
            return;
        }
        else{
            
//            _rBtn.selected=NO;
            _redPointView2.hidden=YES;
        }
    }
    
    if(_redPointView1.hidden==NO || _redPointView2.hidden==NO){
        _rBtn.selected=YES;
    }
    else{
        _rBtn.selected=NO;
    }
}


-(void)setUI{
   
    _redPointView1 = [[RedPointBadgeView alloc] init];
    _redPointView2 = [[RedPointBadgeView alloc] init];
    _selindx=0;
    [self.view addSubview:self.mainTableview];
    
    [self.mainTableview addSubview:self.noView];
//

    
}
-(void)setnavUI{
    [self.navHeadView addSubview:self.tradBtn];
    [self.navHeadView addSubview:self.servBtn];
    
    _rBtn=[UIButton buttonWithType:UIButtonTypeCustom];

    _rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(36), WDNavHeight, gdValue(25), gdValue(25));
    [_rBtn setImage:imageName(@"ydxs") forState:UIControlStateSelected];
    [_rBtn setImage:imageName(@"ydxs_n") forState:UIControlStateNormal];
    [self.navHeadView addSubview:_rBtn];
    
    [_rBtn addTarget:self action:@selector(yduck:) forControlEvents:UIControlEventTouchUpInside];
       
}
-(LBJButton*)tradBtn{
    if(!_tradBtn){
        _tradBtn=[LBJButton buttonWithType:UIButtonTypeCustom];
        _tradBtn.frame=CGRectMake(gdValue(96), kStatusBarHeight+7, gdValue(66), gdValue(30));
        [_tradBtn setTitleColor:ziColor forState:UIControlStateNormal];
        [_tradBtn setTitle:getLocalStr(@"myd7") forState:UIControlStateNormal];
        _tradBtn.titleLabel.font=fontBoldNum(14);
        _tradBtn.underLineColor=ziColor;
        _tradBtn.tag=10010;
        [_tradBtn addTarget:self action:@selector(tavkk:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _tradBtn;
}
-(LBJButton*)servBtn{
    if(!_servBtn){
        _servBtn=[LBJButton buttonWithType:UIButtonTypeCustom];
        _servBtn.frame=CGRectMake(gdValue(40)+_tradBtn.right,  kStatusBarHeight+7, gdValue(66), gdValue(30));
        [_servBtn setTitleColor:ziColor forState:UIControlStateNormal];
        [_servBtn setTitle:getLocalStr(@"myd8") forState:UIControlStateNormal];
        _servBtn.titleLabel.font=fontBoldNum(14);
        _servBtn.underLineColor=[UIColor clearColor];
        [_servBtn setTitleColor:ziColor forState:UIControlStateNormal];
        _servBtn.tag=10011;
        [ _servBtn addTarget:self action:@selector(tavkk:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _servBtn;
}

#pragma mark --点击
-(void)tavkk:(LBJButton*)sender{
    sender.underLineColor=ziColor;
    [sender setTitleColor:ziColor forState:UIControlStateNormal];
    
    if(sender.tag==self.tradBtn.tag){
      
        _selindx=0;
        self.noView.hidden=NO;
        if(self.dataArr.count){
            self.noView.hidden=YES;
        }
        
        _servBtn.underLineColor=[UIColor clearColor];
        [   _servBtn setTitleColor:zyincolor forState:UIControlStateNormal];
        
    }
    else  if(sender.tag==_servBtn.tag){
        _selindx=1;
        self.noView.hidden=NO;
        if(self.newdataArr.count){
            self.noView.hidden=YES;
        }
        
        _tradBtn.underLineColor=[UIColor clearColor];
        [   _tradBtn setTitleColor:zyincolor forState:UIControlStateNormal];
        
        
       
    }
    
    [self.mainTableview reloadData];
    
}

#pragma mark --TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_selindx==0){
        return self.dataArr.count;
    }
    return self.newdataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell*Cell=nil;
    
    if(_selindx==0){
    myneswTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"mynesID" forIndexPath:indexPath];

    if(self.dataArr.count){
        tranDetModel*model=self.dataArr[indexPath.row];
        cell.model=model;
        if(model.isYdu==0){
            cell.contentView.backgroundColor=cyColor;
        }
        else{
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        
    }
        
        Cell=cell;
    }
    else{
        xtnewsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"xtnesID" forIndexPath:indexPath];
        
        if(self.newdataArr.count){
            neswModel*model=self.newdataArr[indexPath.row];
            cell.model=model;
            if(model.isYdu==0){
                cell.contentView.backgroundColor=cyColor;
            }
            else{
                cell.contentView.backgroundColor=[UIColor whiteColor];
            }
            
        }
        
        
        Cell=cell;
    }
    return Cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
   

    if(_selindx==0){
        return gdValue(80);
    }
    
    CGFloat hig=0.0;
    if(self.newdataArr.count){
        neswModel*model=self.newdataArr[indexPath.row];
        
        hig=[Utility heightForString:model.msgContent fontSize:11 andWidth:SCREEN_WIDTH-gdValue(38)]+gdValue(10);
        if(hig>gdValue(40)){
            hig=gdValue(40);
        }
    }
    
    return gdValue(50)+hig;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_selindx==0){
    if(self.dataArr.count){
        tranDetModel*model=self.dataArr[indexPath.row];
    DetTradViewController*detVc=[[DetTradViewController alloc]init];
    detVc.model=model;
    detVc.chonacode=model.chonacode;
    
        model.isYdu=1;
        
        [model bg_saveOrUpdate];
        
        [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
        [self isredSHow];
        
        [self.mainTableview reloadData];
    [self.navigationController pushViewController:detVc animated:YES];
        
    }
    }
    
    
    else{
        
        if(self.newdataArr.count){
            neswModel*model=self.newdataArr[indexPath.row];
            
            
            if(![Utility isBlankString:model.contentUrl]){
                
               
                
                h5ViewController*hvc=[[h5ViewController alloc]init];
                hvc.url=model.contentUrl;
                
               
                
                model.isYdu=1;
                
                [model bg_saveOrUpdate];
                
                [self.newdataArr replaceObjectAtIndex:indexPath.row withObject:model];
                [self isxtShow];
                
                [self.mainTableview reloadData];
                
                [ hvc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:hvc animated:YES];
                
             
                
                
            }
            else{
                
           newDetViewVC*detvc=[[newDetViewVC alloc]init];
            detvc.nid=model.id;
            
            model.isYdu=1;
            
            [model bg_saveOrUpdate];
            
            [self.newdataArr replaceObjectAtIndex:indexPath.row withObject:model];
            [self isxtShow];
            
            [self.mainTableview reloadData];
            
          [self.navigationController pushViewController:detvc animated:YES];
                
        
        }
            
        }
    }
    
}
-(void)checkNews:(NSString*)nid{
    NSDictionary*dic=@{@"id":nid};
    
    [Request GET:messacgAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark 点击删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"删除");
    
    if(_selindx==0){
    [self.dataArr removeObjectAtIndex:indexPath.row];
    NSArray*arr= [tranDetModel bg_findAll:bg_pushNewname];
   [tranDetModel bg_delete:bg_pushNewname row:arr.count-indexPath.row];
 
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if(self.dataArr.count<=0){
            self.noView.hidden=NO;
        }
    }
    else{
        [self.newdataArr removeObjectAtIndex:indexPath.row];
        NSArray*arr= [neswModel bg_findAll:bg_Newtpushname];
       [neswModel bg_delete:bg_Newtpushname row:arr.count-indexPath.row];
     
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if(self.newdataArr.count<=0){
            self.noView.hidden=NO;
        }
    }
}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return getLocalStr(@"watschu");
}




#pragma mark 选择编辑模式，添加模式很少用,默认是删除-
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;//UITableViewCellEditingStyleNone;
}


-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=viewColor;
       
        [_mainTableview registerClass:[myneswTableViewCell  class] forCellReuseIdentifier:@"mynesID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_mainTableview registerClass:[xtnewsTableViewCell  class] forCellReuseIdentifier:@"xtnesID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
     
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(60), SCREEN_WIDTH,self.mainTableview.height-gdValue(240))imgstr:@"nesno" tis:getLocalStr(@"zwxxe")];
        _noView.hidden=YES;
    }
    
    return _noView;
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
