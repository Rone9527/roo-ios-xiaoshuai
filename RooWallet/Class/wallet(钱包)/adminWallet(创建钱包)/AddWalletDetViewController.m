//
//  AddWalletDetViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "AddWalletDetViewController.h"
#import "upWalletViewController.h"
#import "passdOCRView.h"
#import "BaseTabBarViewController.h"
#import "blockModel.h"
#import "MnemonViewController.h"
#import "walletQDViewController.h"
#import <ethers/ethers.h>

@interface AddWalletDetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,copy)NSArray*tirr;
@property(nonatomic,copy)NSArray*subrr;
@property(nonatomic,strong)NSMutableArray*morenArr;


@end

@implementation AddWalletDetViewController
-(NSMutableArray*)morenArr{
    if(!_morenArr){
        _morenArr=[NSMutableArray array];
        
    }
    return _morenArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creaToken];
    
    if(_seleType==0){
        self.leftBtn.hidden=YES;
        
    }
    
    
    _tirr=@[getLocalStr(@"waddwlt1"),getLocalStr(@"waddwlt2")];
    _subrr=@[getLocalStr(@"waddwlt3"),getLocalStr(@"waddwlt4")];
    [self loadUI];
    
  
    
    
    // Do any additional setup after loading the view.
}
-(void)creaToken{
   
    
    [self.morenArr addObjectsFromArray:[Utility getChaninCodeStr]];
    
}
-(void)loadUI{
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(25), gdValue(136),gdValue(200), gdValue(30))];
    tlab.text=getLocalStr(@"waaddwalet");
    tlab.font=fontBoldNum(20);
    tlab.textColor=ziColor;
    [self.view addSubview:tlab];
    
    [self.view addSubview:self.setTableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tirr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"addwaCellID" forIndexPath:indexPath];
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
    UIView*cellBgv=[[UIView alloc]initWithFrame:CGRectMake(gdValue(25), 0, SCREEN_WIDTH-gdValue(50), gdValue(100))];
    
    cellBgv.backgroundColor=cyColor;
    ViewRadius(cellBgv, gdValue(8));
    [cell.contentView addSubview:cellBgv];
    
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(26), gdValue(33), gdValue(34), gdValue(34))];
    NSString*srt=[NSString stringWithFormat:@"cjwalle_%ld",indexPath.row+1];
    
    seimg.image=imageName(srt);
    [cellBgv addSubview:seimg];
    
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(19)+seimg.right, gdValue(30), gdValue(100), gdValue(23))];
    tlab.text=_tirr[indexPath.row];
    tlab.font=fontBoldNum(16);
    tlab.textColor=ziColor;
    [cellBgv addSubview:tlab];
    
    UILabel*slab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(19)+seimg.right, gdValue(2)+tlab.bottom, gdValue(100), gdValue(15))];
    slab.text=_subrr[indexPath.row];
    slab.font=fontNum(11);
    slab.textColor=UIColorFromRGB(0x999999);
    [cellBgv addSubview:slab];
    
    
    

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(120);
    
   
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
      
        
       
        
        

        if(_seleType==0){//

            [self creaUSerData];

        }
        else{

            NSLog(@"再次创建成功");
            userModel*model=[[userModel alloc]init];
            model.creatimer=[Utility getNowTimeTimestamp];

            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;


            NSString*namer=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
            
            NSArray*art=[ userModel bg_findAll:bg_tablename];
            model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
            
            [art enumerateObjectsUsingBlock:^(userModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"111---%@  2---%@",obj.name,namer);
                if([obj.name isEqualToString:namer]){
                
                    [[NSUserDefaults standardUserDefaults] setInteger:runCount+1 forKey:WalletcountKEY];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount+1];
                   
                    *stop = YES;
                    
                }
            }];
            
         
        
            
//            model.seleindx=@"0";
            model.isHide=NO;
//            model.walletArray=@"";
//            model.bg_tableName=bg_tablename;
//            [model bg_save];



                [self creatETHWallet:model ];



        }
   
         
        
        
    }
    else{
        upWalletViewController*addwVc=[[upWalletViewController alloc]init];
        addwVc.seleType=_seleType;
        
        [self.navigationController pushViewController:addwVc animated:YES];
        
    }
    
   
}
#pragma mark --创建新用户
-(void)creaUSerData{
    
  

//    NSInteger runCount =0;
//    [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    userModel*model=[[userModel alloc]init];
    model.creatimer=[Utility getNowTimeTimestamp];
//    model.sectPassWord=str;
    model.name=@"RooWallet-1";
//    model.seleindx=@"0";
    model.isPort=@"0";
    model.isHide=NO;
  

    
        [self  creatETHWallet:model];
        

    
    
  
//};
        
    
}

#pragma mark --助记词创建Tron钱包
-(walletModel*)creatTronWallet:( userModel*)userModell  act:(Account *)account {
    
    NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
    
    privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];

    SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
    [data1 appendData:[SecureData hexStringToData:@"0x41"]];
    [data1 appendData:account.address.data];
    NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        walletModel*wmodel=[[walletModel alloc]init];
        wmodel.ID=[Utility getNowTimeTimestamp];

        wmodel.keyStore=@"";
        wmodel.belongClass=@"TRON";
        wmodel.mnemonics=account.mnemonicPhrase;
            
        wmodel.name=@"TRON";
    wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
        wmodel.password=privateKeyStr;
        wmodel.addres=address;
        userModell.mnemonicPhrase=account.mnemonicPhrase;//所有都是一套助记词导入  后期可能会改，直接注释
            userModell.privtyKey=privateKeyStr;
       userModell.isbackUps=@"1";
        NSMutableArray*arrt=[NSMutableArray array];

//        [arrt addObjectsFromArray:wmodel.coinArray];
            
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
            
        NSDictionary*dict=@{@"chainCode":@"TRON",@"symbol":@"TRX",@"icon":@"",@"contractId":@"",@"morb":@"0",@"isUp":@"0",@"addres":address,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        
        symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
        
        [arrt addObject:symod];
        
        wmodel.coinArray=[arrt copy];
            

    
    return wmodel;
    
    
}

#pragma mark --创建eth钱包
-(void)creatETHWallet:( userModel*)userModell{
    NSMutableArray*usarr=[NSMutableArray array];
    [MBProgressHUD showHUD];
    WeakSelf;
    Account *account = [Account randomMnemonicAccount];
    NSString *address = [SecureData dataToHexString: account.address.data];
    //4 获取私钥
    NSString *privateKey = [SecureData dataToHexString:account.privateKey];
    NSString *mnemonicPhrase =  account.mnemonicPhrase;
    
    
//    [HSEther hs_createWithPwd:ETHWalletPasKey block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey) {
        NSLog(@"助记词==%@",mnemonicPhrase);
        NSLog(@"私钥=%@",privateKey);
        
        
        [MBProgressHUD hideHUD];
        walletQDViewController*walVc=[[walletQDViewController alloc]init];
        walVc.mnemonicPhrase=mnemonicPhrase;
        [self.navigationController pushViewController:walVc animated:YES];
        
        
    [usarr addObject:[self creatTronWallet:userModell act:account]];//创建Tron钱包
    
        for(btokensModel*btmodel in  self.morenArr){
            if([btmodel.chainCode isEqualToString:@"TRON"]){
                
                continue;
            }
            
        walletModel*wmodel=[[walletModel alloc]init];
        wmodel.ID=[Utility getNowTimeTimestamp];

//        wmodel.keyStore=keyStore;
        wmodel.belongClass=@"ETH";
        wmodel.mnemonics=mnemonicPhrase;
        wmodel.name=btmodel.chainCode;
        wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
        wmodel.password=privateKey;
        wmodel.addres=address;
        userModell.mnemonicPhrase=mnemonicPhrase;//所有都是一套助记词导入  后期可能会改，直接注释
        userModell.privtyKey=privateKey;
            userModell.isbackUps=@"0";
        NSMutableArray*arrt=[NSMutableArray array];

//        [arrt addObjectsFromArray:wmodel.coinArray];
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
            
        NSDictionary*dict=@{@"chainCode":btmodel.chainCode,@"symbol":btmodel.symbol,@"icon":@"",@"contractId":@"",@"morb":@"0",@"isUp":@"0",@"addres":address,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        
        symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
        
        [arrt addObject:symod];
        
        wmodel.coinArray=[arrt copy];
            
            
            [usarr insertObject:wmodel atIndex:0];
            
//        [usarr addObject:wmodel];
            
        }

        userModell.walletArray=[usarr copy];

        userModell.bg_tableName=bg_tablename;
        [userModell  bg_save];
        
        
            [MBProgressHUD hideHUD];
        
        //注册钱包推送
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    
   
    NSLog(@"钱包数量--%ld",userModell.walletArray.count);
        
        if(weakSelf.seleType!=0){
            //添加钱包+1
            [[NSUserDefaults standardUserDefaults]setInteger:[userModel bg_findAll:bg_tablename].count-1 forKey:@"selewalletIndx"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            

        }
        //回调
        
        walVc.block = ^(NSString * _Nullable blockStr) {
          
       
            
            userModel*userModellt=[userModel bg_findAll:bg_tablename][selewalletIndex];
            userModellt.isbackUps=blockStr;
         
            [userModellt bg_saveOrUpdate];
            
                for(UIViewController * vc in self.navigationController.viewControllers){
                    [vc removeFromParentViewController];
                }
            
            
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
                [[[UIApplication sharedApplication] delegate] window].rootViewController=tabbar;

        };
        
      
       
//    }];
}

-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,gdValue(185), SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight-gdValue(185)) style:UITableViewStylePlain];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xffffff);
       
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addwaCellID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
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
