//
//  myAssectViewController.m
//  RooWallet
//
//  Created by mac on 2021/9/14.
//

#import "myAssectViewController.h"
#import "accsctTableViewCell.h"
#import "accZBTableViewCell.h"


@interface myAssectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*accectTableView;
@property(nonatomic,strong)NSMutableArray*secrArr;
@property(nonatomic,strong)noDataView*noView;

@end

@implementation myAssectViewController

-(NSMutableArray*)secrArr{
    if(!_secrArr){
        _secrArr=[NSMutableArray array];
    }
    return _secrArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseLab.text=getLocalStr(@"我的资产");
    [self setUI];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myassetupte" object:nil];
    
    if(self.allSymbArr.count==0){
        [self.view addSubview:self.noView];
    }
    
    
    NSMutableArray*myarr=[NSMutableArray array];
    
    for(NSArray*arr in self.allSymbArr){
  
        for(myAssectModel*model in  arr){

            model.isTop=1;
            model.tokenVO.isRead=@"1";
  
            [myarr addObject:model];


        }
       
    }
    
   

    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    usmodel.myAssctArray=[myarr copy];
   
    [usmodel bg_saveOrUpdate];

  
    

    // Do any additional setup after loading the view.
}


-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(100), SCREEN_WIDTH,gdValue(340))imgstr:@"nodata" tis:getLocalStr(@"暂无数据")];
        
    }
    
    return _noView;
}

-(void)setUI{
    [self.view addSubview:self.accectTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allSymbArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return [self.allSymbArr[section]count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell*Cell=nil;
    
    
    if(self.allSymbArr.count>0){
        NSArray*art=self.allSymbArr[indexPath.section];
        myAssectModel*model=art[indexPath.row];
        
       
        if([Utility isBlankString:model.contractId]){
            accZBTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"accZBID" forIndexPath:indexPath];
            cell.model=model;
            
            Cell=cell;
        }
        
        
        
    
    else{
       
        accsctTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"accetID" forIndexPath:indexPath];
        cell.model=model;
        
        WeakSelf;
        cell.getBtnBlock = ^(BOOL isSele) {
            
            model.isSeled=isSele;
            [ weakSelf.allSymbArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:model];
            
            if(isSele){
                
            }
            else{
           
                
                
//                [weakSelf.remTokkArr replaceObjectAtIndex:indexPath.row withObject:model];
            }
        };
        
          Cell=cell;
    }
  
    }
   
//
    
    return Cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(70);
        
  
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    
        return gdValue(40);
    
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.allSymbArr.count>1){
        
        return gdValue(10);
    }
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    if(self.allSymbArr.count>1){
        if(section==0){
            vv.backgroundColor=cyColor;
        }
        else{
            vv.backgroundColor=[UIColor whiteColor];
        }
        
    }
    return vv;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    for(UIView*vi in vv.subviews){
        [vi removeFromSuperview];
    }
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10), gdValue(200), gdValue(20))];
    lab.textColor=zyincolor;
    lab.font=fontMidNum(14);
    [vv addSubview:lab];
    
    if(self.allSymbArr.count>1){
        
        if(section==0){
            lab.text=getLocalStr(@"新增资产");
            
        }
        else{
            lab.text=getLocalStr(@"列表资产");
        }
        
    }
    else{
        lab.text=getLocalStr(@"列表资产");
    }
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray*art=self.allSymbArr[indexPath.section];
    myAssectModel*model=art[indexPath.row];
    
    if(![Utility isBlankString:model.contractId]){
        
        accsctTableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
        model.isSeled=!model.isSeled;
//        cell.adBtn.selected=model.isSeled;
        if(model.isSeled){
            cell.adBtn.image=imageName(@"addactS");
            [self addTokenDatawalletm:model];
            
        }
        else{
            cell.adBtn.image=imageName(@"addactN");
            [self caneTokenwalletbtmodel:model];
            
        }
        
      
        [ self.allSymbArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:model];
        
    }
    
    
    
}


-(UITableView*)accectTableView{
    if(!_accectTableView){
        _accectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        _accectTableView.dataSource=self;
        _accectTableView.delegate=self;
        _accectTableView.backgroundColor= UIColorFromRGB(0xfffffff);

        UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(80))];
        fotv.backgroundColor=[UIColor whiteColor];
        _accectTableView.tableFooterView=fotv;
        
//       _accectTableView.tableHeaderView=self.righheadView;
        
       
        _accectTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_accectTableView registerClass:[accsctTableViewCell class] forCellReuseIdentifier:@"accetID"];
        [_accectTableView registerClass:[accZBTableViewCell class] forCellReuseIdentifier:@"accZBID"];
        
//        _accectTableView.bounces=NO;
        _accectTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _accectTableView;
}
#pragma  mark 取消代币
-(void)caneTokenwalletbtmodel:(myAssectModel*)btmodel{
    
    
    
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    NSMutableArray*userWallArr=[NSMutableArray array];
    [userWallArr addObjectsFromArray:usmodel.walletArray];
    
    
    for(int i=0;i<userWallArr.count;i++){
        walletModel*wamodel=userWallArr[i];
        if([wamodel.name  isEqualToString:btmodel.chainCode]){//已经存在钱包
         
            NSMutableArray*arrt=[NSMutableArray array];
         
            [arrt addObjectsFromArray:wamodel.coinArray];
            
            for(symbolModel*symob in wamodel.coinArray){

                if([btmodel.chainCode isEqualToString:symob.chainCode]&&[btmodel.tokenVO.symbol isEqualToString:symob.symbol]){


                    [arrt removeObject:symob];

                }


            }

            if(arrt.count>0){
                wamodel.coinArray=arrt;
             
                [userWallArr replaceObjectAtIndex:i withObject:wamodel];
                

                
               
            }
            else{
                
                [userWallArr removeObjectAtIndex:i];
            }
           
         
            usmodel.walletArray=[userWallArr copy];
            
            [usmodel bg_saveOrUpdate];
            NSLog(@"取消成功");
          
            NSLog(@"取消代币");
            NSString*delstr=[NSString stringWithFormat:@"%@,%@",btmodel.chainCode,btmodel.symbol];
            
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:delstr];
            
            return;
        }
        
    }
    
    

}

#pragma  mark 添加代币
-(void)addTokenDatawalletm:(myAssectModel*)model{
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    NSMutableArray*userWallArr=[NSMutableArray array];
    [userWallArr addObjectsFromArray:usmodel.walletArray];

    for(int i=0;i<userWallArr.count;i++){
        walletModel*wamodel=userWallArr[i];
        if([wamodel.name  isEqualToString:model.chainCode]){//已经存在钱包
            NSMutableArray*arrt=[NSMutableArray array];
            NSArray*waar=wamodel.coinArray;
            [arrt addObjectsFromArray:waar];


            if([Utility isBlankString:model.icon]){
                model.icon=@"";
            }

            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];

            NSDictionary*dict=@{@"chainCode":model.chainCode,@"symbol":model.tokenVO.symbol,@"icon":model.icon,@"contractId":model.tokenVO.contractId,@"isUp":@"0",@"addres":wamodel.addres,@"decimals":model.tokenVO.decimals,@"creadCount":@(runCount),@"isMarket":model.tokenVO.isMarket};

            symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];

                  NSArray*coinArray=@[symod];

            [arrt addObjectsFromArray:coinArray];
            NSLog(@"代币数目2---%ld",arrt.count);
            wamodel.coinArray=[arrt copy];
    
 

        [userWallArr replaceObjectAtIndex:i withObject:wamodel];
           
        usmodel.walletArray=[userWallArr copy];//[weakSelf.userWallArr mj_JSONString];

            [usmodel bg_saveOrUpdate];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
            [MBProgressHUD showHUD1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSLog(@"3秒后执行这个方法");
                [MBProgressHUD hideHUD];
                
            });
            return;
        }
        
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
