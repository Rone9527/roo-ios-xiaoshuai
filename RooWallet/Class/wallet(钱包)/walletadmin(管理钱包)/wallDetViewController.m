//
//  wallDetViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "wallDetViewController.h"
#import "actShootView.h"
#import "walletnameViewController.h"
#import "outPriKeyViewController.h"
#import "MnemonViewController.h"
#import "YZAuthIDVC.h"
#import "passdOCRView.h"
#import "AddWalletDetViewController.h"
#import "selectMainView.h"
#import "adminWalletViewController.h"
@interface wallDetViewController ()<UITableViewDelegate,UITableViewDataSource,wallxgDelagete>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)UIView*footView;
@end

@implementation wallDetViewController
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.dataArr addObject:getLocalStr(@"walletd1")];
//    NSLog(@"sd---%@",_model.mnemonicPhrase);
    
    if(![Utility isBlankString:_model.mnemonicPhrase]){//有助记词
        [self.dataArr addObject:getLocalStr(@"walletd2")];
    }
  if(_model.walletArray.count>0){
        [self.dataArr addObject:getLocalStr(@"walletd3")];
    }
//    _zrr=@[getLocalStr(@"walletd1"),getLocalStr(@"walletd2"),getLocalStr(@"walletd3")];
    self.baseLab.text=@"我的钱包";
    
    [self.view addSubview:self.setTableView];
    
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"addwaCellID" forIndexPath:indexPath];
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
   
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(100), gdValue(25))];
    tlab.text=_dataArr[indexPath.row];
    tlab.font=fontNum(16);
    tlab.textColor=ziColor;
    [cell.contentView addSubview:tlab];
    
    
    
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
    seimg.image=imageName(@"dlad");
    [cell.contentView addSubview:seimg];
    if(indexPath.row==0){
        UILabel*ylab=[[UILabel alloc]initWithFrame:CGRectMake(seimg.x-gdValue(215), gdValue(15), gdValue(200), gdValue(25))];
        ylab.text=_nameStr;
        ylab.font=fontNum(16);
        ylab.textColor=zyincolor;
        ylab.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:ylab];
        
        
    }
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(55)-1, SCREEN_WIDTH, 1)];
    col.backgroundColor=UIColorFromRGB(0xf5f6f7);
    [cell.contentView addSubview:col];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(55);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
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
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==0){
        walletnameViewController*wanvc=[[walletnameViewController alloc]init];
        wanvc.nameStr=self.nameStr;
        wanvc.delagate=self;
        wanvc.model=self.model;
        
        [self.navigationController pushViewController:wanvc animated:YES];

    }
    else{
    

    WeakSelf;
    passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
    
    __block passdOCRView*passV=passView;
    passView.getpass = ^(NSString * _Nonnull str) {
        NSLog(@"sf--%@  %@",str,UserPassword);
     
        if([str isEqualToString:UserPassword]){
//        if([str integerValue]==123456){
            
//            [weakSelf.view endEditing:YES];
            [passV hide];
        
          
                
                NSString*srt=weakSelf.dataArr[indexPath.row] ;
                
                if ([srt isEqualToString:getLocalStr(@"walletd2")] ){
                    NSLog(@"备份助记词");
                    MnemonViewController*menVc=[[MnemonViewController alloc]init];
                    menVc.mnemonics=weakSelf.model.mnemonicPhrase;
    //                menVc.model=weakSelf.model;
    //                menVc.sleIndx=indx;
                    [weakSelf.navigationController pushViewController:menVc animated:YES];
    //                [self seleMain:indexPath.row];
                   
                }
                else {
                    NSLog(@"导出私钥");
                    
                    [self seleMain:indexPath.row];
                    
                    
                    
                    
                }
            }
            
          
        
        else{
           
            [MBProgressHUD showText:getLocalStr(@"cwts1")];
        }
        
    };

    
    }
    
   
}
#pragma mark 选择主链
-(void)seleMain:(NSInteger)indxe{
    NSArray*userWallArr= _model.walletArray;//[Utility toArrayOrNSDictionary:_model.walletArray];
    
 
    NSMutableArray*titArr=[NSMutableArray array];
//    NSMutableArray*titArrmn=[NSMutableArray array];//助记词
    NSMutableArray*titArrprty=[NSMutableArray array];//私钥
    for(walletModel*wamodel in userWallArr){
      
//        NSLog(@"sname------%@",dic[@"name"]);
//        NSLog(@"sname------%@",dic[@"password"]);
        [titArr addObject:wamodel.name];
//        [titArrmn addObject:wamodel.mnemonics];
        [titArrprty addObject:wamodel.password];
    }
    
    
    
    
    selectMainView*view=[[selectMainView alloc]initWithFrame:SCREEN_FRAME  seleindx:99 arr:titArr];
   
    view.type=@"1";
     WeakSelf;
     view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
         
//         if(indxe==1){
//             MnemonViewController*menVc=[[MnemonViewController alloc]init];
//             menVc.mnemonics=titArrmn [indx];
//             menVc.model=weakSelf.model;
//             menVc.sleIndx=indx;
//             [weakSelf.navigationController pushViewController:menVc animated:YES];
//         }
//
//         else{
             outPriKeyViewController*outVc=[[outPriKeyViewController alloc]init ];
             outVc.password=titArrprty[indx];
         [weakSelf.navigationController pushViewController:outVc animated:YES];
             
//         }
         
     };
     
     
     [view show];
}

-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xf5f6f9);
        _setTableView.tableFooterView=self.footView;
        
        
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addwaCellID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}

-(UIView*)footView{
    if(!_footView){
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(90))];
        _footView.backgroundColor=UIColorFromRGB(0xf5f6f9);
        
        UIButton*scbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        scbtn.frame=CGRectMake(0, gdValue(25), SCREEN_WIDTH, gdValue(55));
        scbtn.backgroundColor=[UIColor whiteColor];
        [scbtn setTitle:getLocalStr(@"walletd4") forState:UIControlStateNormal];
        [scbtn setTitleColor:UIColorFromRGB(0xFA6400) forState:UIControlStateNormal];
        scbtn.titleLabel.font=fontNum(16);
        [_footView addSubview:scbtn];
        [scbtn addTarget:self action:@selector(delck:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _footView;
}

#pragma mark --删除钱包
-(void)delck:(UIButton*)sender{
    
    WeakSelf;
    
    
    actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:@[@"qddel",@"waqux"] tis:getLocalStr(@"walletd5")];
    [view show];
       
 
    view.getIndx = ^(NSInteger indx) {
        
        passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
        __block   passdOCRView*passV=passView;
        passView.getpass = ^(NSString * _Nonnull str) {
            
            if([str isEqualToString:UserPassword]){
    //        if([str integerValue]==123456){
                
    //            [weakSelf.view endEditing:YES];
                [passV hide];
           
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSLog(@"3秒后执行这个方法");
                   
                    [MBProgressHUD showText:getLocalStr(@"sccg")];
                    
                });
               
                
                NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"creatimer"),bg_sqlValue(weakSelf.model.creatimer)];
               
                
                [userModel bg_delete:bg_tablename where:where];
                
         
               
    //            [userModelArr removeInfoModel:weakSelf.model];
            
                if([userModel bg_findAll:bg_tablename].count<=0){
                    
                    NSInteger runCount =0;
                    [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    AddWalletDetViewController*addwaVc=[[AddWalletDetViewController alloc]init];
                    addwaVc.seleType=0;
                    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:addwaVc];
                    
                    weakSelf.view.window.rootViewController=nav;
                }
                else{
                    //注册钱包推送
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"deluser" object:nil];
                    
                    for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[adminWalletViewController class]]) {
                            [weakSelf.navigationController popToViewController:controller animated:YES];
                        }
                    }
                    
                   
                    
                }
                
                
         
            
           
            }
            else{
                [MBProgressHUD showText:getLocalStr(@"cwts1")];
            }
           
        };
        
          
        
    };
    
    
    
    
  
    
   
    
}

-(void)getWalletName:(NSString *)name{
    _nameStr=name;
    _model.name=name;
    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"name"),name];
    [userModel bg_update:bg_tablename where:where];
//    [userManger updateUser:_model];
    
    if([_delagate respondsToSelector:@selector(getwallDetWalletName:)]){
        [_delagate getwallDetWalletName:name];
    }
    [self.setTableView reloadData];
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
