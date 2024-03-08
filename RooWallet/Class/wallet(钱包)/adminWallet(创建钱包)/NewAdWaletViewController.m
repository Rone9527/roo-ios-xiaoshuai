//
//  NewAdWaletViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import "NewAdWaletViewController.h"
#import "yinsinView.h"
#import "upWalletViewController.h"
#import "BaseTabBarViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "blockModel.h"
#import "MnemonViewController.h"
#import "walletQDViewController.h"
#import <ethers/ethers.h>

@interface NewAdWaletViewController ()
@property(nonatomic,strong)UITextField*textFild;
@property(nonatomic,strong)UILabel*tslab;
@property(nonatomic,weak)UIButton*addBtn;
@property(nonatomic,strong)NSMutableArray*morenArr;
@end

@implementation NewAdWaletViewController
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
    [self setfert];//判断同意隐私;
   
   
    [self setUI];
    
    // Do any additional setup after loading the view.
}
-(void)creaToken{
   
    [self.morenArr addObjectsFromArray:[Utility getChaninCodeStr]];
    
}
-(void)setfert{
    if(!isAgrEE){
        yinsinView*view=[[yinsinView alloc]initWithFrame:SCREEN_FRAME];
        [view show];
        
    }
    
}
-(void)setUI{
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(28), gdValue(136), gdValue(300), gdValue(28))];
    tlab.text=getLocalStr(@"adm17");
    tlab.font=fontBoldNum(20);
    tlab.textColor=ziColor;
    [self.view addSubview:tlab];
    
    [self.view addSubview:self.textFild];
    
    UIButton*addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(gdValue(35), SCREEN_HEIGHT-gdValue(172), SCREEN_WIDTH-gdValue(70), gdValue(50));
    ViewRadius(addBtn, gdValue(8));
    self.addBtn=addBtn;
    addBtn.backgroundColor=mainColor;
    [addBtn setTitle:getLocalStr(@"adm18") forState:UIControlStateNormal];
    addBtn.titleLabel.font=fontNum(16);
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addCkl1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton*addBtnn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtnn.frame=CGRectMake(gdValue(35), addBtn.bottom+gdValue(20), SCREEN_WIDTH-gdValue(70), gdValue(50));
   
   
    addBtnn.backgroundColor=UIColorFromRGB(0xffffff);
    [addBtnn setTitle:getLocalStr(@"waddwlt2") forState:UIControlStateNormal];
    addBtnn.titleLabel.font=fontNum(16);
    [addBtnn setTitleColor:mainColor forState:UIControlStateNormal];
    [self.view addSubview:addBtnn];
    
    [addBtnn addTarget:self action:@selector(addCkl2) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.view addSubview:self.tslab];
    
    
    
    
}
#pragma mark 创建用户
-(void)addCkl1{
    
    
    NSArray*art=[ userModel bg_findAll:bg_tablename];
    if(art.count>0){
    for(userModel*md in art){
        if(![md.name isEqualToString:self.textFild.text]){
            [self creaUSerData];
        }
        else{
            [MBProgressHUD showText:getLocalStr(@"adm21")];
        }
    }
    }
    else{
        [self creaUSerData];
    }
//
   
}



-(void)creaUSerData{
    
    if([Utility isBlankString:self.textFild.text]){
        [MBProgressHUD showText:getLocalStr(@"adm22")];
        
    }
    else{
    
    WeakSelf;
//    [MBProgressHUD showHUD];
passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts3") typ:0];
__block passdOCRView*pasv= passView;

passView.getpass = ^(NSString * _Nonnull str) {
    
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"UserPassword"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [pasv hide];
    
    userModel*model=[[userModel alloc]init];
    model.creatimer=[Utility getNowTimeTimestamp];
//    model.sectPassWord=str;
    model.name=self.textFild.text;
//    model.seleindx=@"0";
    model.isHide=NO;
    model.isPort=@"0";
    
//    model.bg_tableName=bg_tablename;
//    [model bg_save];
    
  
    [weakSelf creatETHWallet:model];
        
   
  
  
};
        
    }
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
    
    
    Account *account = [Account randomMnemonicAccount];
    NSString *address = [SecureData dataToHexString: account.address.data];
    //4 获取私钥
    NSString *privateKey = [SecureData dataToHexString:account.privateKey];
    NSString *mnemonicPhrase =  account.mnemonicPhrase;
    
    WeakSelf;
//    [HSEther hs_createWithPwd:ETHWalletPasKey block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey) {
        NSLog(@"助记词==%@",mnemonicPhrase);
        NSLog(@"私钥=%@",privateKey);
        
        [MBProgressHUD hideHUD];
 
        walletQDViewController*walVc=[[walletQDViewController alloc]init];
        walVc.mnemonicPhrase=mnemonicPhrase;
        [self.navigationController pushViewController:walVc animated:YES];
        
    [usarr addObject:[self creatTronWallet:userModell act:account]];//创建Tron钱包
        
        for(btokensModel*btmodel in  weakSelf.morenArr){
            
            if([btmodel.chainCode isEqualToString:@"TRON"]){
                
                continue;
            }
            
        walletModel*wmodel=[[walletModel alloc]init];
        wmodel.ID=[Utility getNowTimeTimestamp];

        wmodel.keyStore=@"";
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
            
            
//        [usarr addObject:wmodel];
            [usarr insertObject:wmodel atIndex:0];
            
            
        }

        userModell.walletArray=[usarr copy];

        userModell.bg_tableName=bg_tablename;
        [userModell  bg_save];

       
        
       
        NSLog(@"钱包数量--%ld",userModell.walletArray.count);
        
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //注册钱包推送
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
        
      
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
#pragma mark --导入钱包
-(void)addCkl2{
    
    upWalletViewController*addwVc=[[upWalletViewController alloc]init];
    addwVc.seleType=0;
    [self.navigationController pushViewController:addwVc animated:YES];
}
-(UITextField*)textFild{
    if(!_textFild){
        _textFild=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(25), gdValue(185), SCREEN_WIDTH-gdValue(50), gdValue(60))];
        
        ViewRadius(_textFild, gdValue(6));
        _textFild.backgroundColor=UIColorFromRGB(0xf5f6f9);
        _textFild.textColor=ziColor;
        _textFild.font=fontNum(16);
        
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
       
        
        _textFild.text=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
//        _textFild.text=[NSString stringWithFormat:@"Roo Wallet-%ld",[userModel bg_findAll:bg_tablename].count+1];
        
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(40))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(tapp) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
     
        [rigV addSubview:btn];
        _textFild.rightView=rigV;
        _textFild.rightViewMode=UITextFieldViewModeAlways;
        [btn  setImage:imageName(@"sergb") forState:UIControlStateNormal];
        
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(20), gdValue(60))];
        lefv.backgroundColor=UIColorFromRGB(0xf5f6f9);
        _textFild.leftView=lefv;
        _textFild.leftViewMode=UITextFieldViewModeAlways;
        [_textFild addTarget:self action:@selector(limitString:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _textFild;
}

-(void)tapp{
    self.textFild.text=nil;
    [self limitString:self.textFild];
    
}
-(UILabel*)tslab{
    if(!_tslab){
        _tslab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(25), _textFild.bottom+gdValue(10), SCREEN_WIDTH-gdValue(50), gdValue(20))];
        _tslab.text=getLocalStr(@"stcw");
        _tslab.font=fontNum(14);
        _tslab.textColor=UIColorFromRGB(0xFA6400);
        _tslab.hidden=YES;
        
    }
    return _tslab;
}
/**
限制字数输入

@param textField 输入框
*/
-(void)limitString:(UITextField *)textField
{
  UITextField *myTextField = (UITextField *)textField;
  NSString *toBeString = myTextField.text;

  //获取高亮部分
  UITextRange *selectedRange = [textField markedTextRange];
  UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
  if (!position)
  {
      if (toBeString.length > 200)
      {
          NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:200];
          if (rangeIndex.length == 1)
          {
              textField.text = [toBeString substringToIndex:200];
          }
          else
          {
              NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
              textField.text = [toBeString substringWithRange:rangeRange];
          }
      }
      else if (toBeString.length>12){
          self.tslab.hidden=NO;
       
      }
      else if (toBeString.length<=0){
          self.tslab.hidden=NO;
          self.addBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
//          [self.addBtn setTitleColor:ziColor forState:UIControlStateNormal];
          self.addBtn.enabled=NO;
      }
      else{
          self.tslab.hidden=YES;
          self.addBtn.backgroundColor=mainColor;
//          [self.addBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
          self.addBtn.enabled=YES;
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
