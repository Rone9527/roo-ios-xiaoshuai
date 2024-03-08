//
//  defiSearViewController.m
//  RooWallet
//
//  Created by mac on 2021/8/4.
//

#import "defiSearViewController.h"
#import "defiModel.h"
#import "defiSearTableViewCell.h"
#import "defiDetXqViewController.h"

@interface defiSearViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)UITextField*serTextf;
@property(nonatomic,weak)UIButton*btn;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,assign)int PageCount;

@property(nonatomic,strong)NSMutableArray*deIDArr;

@end

@implementation defiSearViewController

-(NSMutableArray*)deIDArr{
    if(!_deIDArr){
        _deIDArr=[NSMutableArray array];
    }
    return _deIDArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getconidvoid];
    
    [self.navHeadView addSubview:self.serTextf];
    
    [self.view addSubview:self.setTableView];
    
  
    [self.setTableView addSubview:self.noView];
   
   
   [self frsh];
    
    _page=1;
   
    [MBProgressHUD showHUD];
    
    [self resqData:_page conStr:@""];
    
    // Do any additional setup after loading the view.
}



-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark --理财分页
-(void)resqData:(int)page conStr:(NSString*)pariStr{
    
    NSString*pagee=[NSString stringWithFormat:@"%d",page];
    
   
    NSDictionary*dic=@{@"pageNum":pagee,@"pageSize":@"15",@"sortBy":@"hots",@"pairNameOrContractId":pariStr};
    
    NSLog(@"sd--%@",dic);
    [self getconidvoid];

    [Request GET:defipairAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//
//        if(self.type==1){
        NSLog(@"data--%@",[Utility strData:responseObject]);
//        }
//
        NSDictionary*dat=responseObject[@"data"];
        
        if(dat.count){
            
            self.PageCount=[[NSString stringWithFormat:@"%@",dat[@"totalPage"]] intValue];
            
            NSArray*datrr=dat[@"data"];
            if(datrr.count){
                
                if(self.page==1){
                    [self.dataArr removeAllObjects];
                    
                }
                for(NSDictionary*dict in  datrr){
                   defiModel*model=[defiModel mj_objectWithKeyValues:dict];
                 
                    if([self.deIDArr containsObject:model.identity]){
                        model.isAdd=@"1";
                    }
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
        [self resqData:_page conStr:self.serTextf.text];
    }
 
}
- (void)loadNewData
{
    
  
        self.setTableView.mj_footer.hidden=NO;
        
        _page=1;
        
        [self.dataArr removeAllObjects];
        
        [self resqData:_page conStr:self.serTextf.text];
        [self.setTableView.mj_footer resetNoMoreData];
    
    
    
}
#pragma mark --获取添加数据
-(void)getconidvoid{
    
    NSArray*arr=[defiModel bg_findAll:bg_DeFizxname];
    
    [self.deIDArr removeAllObjects];
    
    arr = [[arr reverseObjectEnumerator] allObjects];
    
    [arr enumerateObjectsUsingBlock:^(defiModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if([Utility isBlankString:model.identity]){
//            NSLog(@"kong--------------%@",model.pairName);
//        }
        [self.deIDArr addObject:model.identity];
        
    }];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    defiSearTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"defiserID" forIndexPath:indexPath];

    if(self.dataArr.count){

        defiModel*model=self.dataArr[indexPath.row];
        
        cell.model=model;

        WeakSelf;
        cell.block = ^(BOOL isSeld) {
            if(isSeld){//添加
                
                model.isAdd=@"1";
                
            }
            else{//取消
                model.isAdd=@"0";
            }
            
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            
        };
        
     


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
        [self.navigationController pushViewController:defidetVc animated:YES];
    
        WeakSelf;
        defiModel*model=self.dataArr[indexPath.row];
        
        defidetVc.block = ^(NSString * _Nonnull isSed) {
            model.isAdd=isSed;
            
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            
            [weakSelf.setTableView reloadData];
            
        };
    }

}



-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= [UIColor whiteColor];

        _setTableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[defiSearTableViewCell class] forCellReuseIdentifier:@"defiserID"];
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






-(UITextField*)serTextf{
    if(!_serTextf){
        _serTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(50),kStatusBarHeight, SCREEN_WIDTH-gdValue(65), gdValue(40))];
        ViewRadius(_serTextf, gdValue(6));
        _serTextf.backgroundColor=cyColor;
        _serTextf.placeholder=getLocalStr(@"输入Token或合约地址");
        _serTextf.font=fontNum(16);
        _serTextf.delegate=self;
        _serTextf.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"输入Token或合约地址") attributes:
            @{NSForegroundColorAttributeName:zyincolor,
                            NSFontAttributeName:_serTextf.font
            }];
        _serTextf.attributedPlaceholder = attrString;
        [_serTextf  addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(40))];
        lefv.backgroundColor=cyColor;
        UIImageView*levim=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(10), gdValue(10), gdValue(20), gdValue(20))];
        levim.image=imageName(@"sert");
        [lefv addSubview:levim];
        
        _serTextf.leftView=lefv;
        _serTextf.leftViewMode=UITextFieldViewModeAlways;
        
     
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(40))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(tapp) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
        self.btn=btn;
        btn.hidden=YES;
        [rigV addSubview:btn];
        
        _serTextf.rightView=rigV;
        _serTextf.rightViewMode=UITextFieldViewModeWhileEditing;
        
        _serTextf.keyboardType=UIKeyboardTypeASCIICapable;
        [btn  setImage:imageName(@"sergb") forState:UIControlStateNormal];
        
    }
    return _serTextf;
}
-(void)tapp{
   
    
    self.serTextf.text=@"";
    [self loadNewData];
    
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    [self.view endEditing:YES];
//}


#pragma  mark --SearbarDelegate--
-(void)textFieldDidChange:(UITextField *)theTextField{

    if(theTextField.text.length>0){
        self.btn.hidden=NO;
      
    }
    else{
        self.btn.hidden=YES;
    }
   
     
    if([theTextField.text hasSuffix:@"-"]||[theTextField.text hasPrefix:@"-"]){
        
        [MBProgressHUD showText:getLocalStr(@"输入不合法")];
    }
    else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self.dataArr removeAllObjects];
//            [self loadNewData];
//
//
//        });
    }
        
        
    
    
    //
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
  
    if([textField.text hasSuffix:@"-"]||[textField.text hasPrefix:@"-"]){
        
        [MBProgressHUD showText:getLocalStr(@"输入不合法")];
    }
    else{
        [self.view endEditing:YES];
        [MBProgressHUD showHUD];
    [self loadNewData];
        
    }
  
    return YES;
    
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
