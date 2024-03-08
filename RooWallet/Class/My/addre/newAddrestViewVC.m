//
//  newAddrestViewVC.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "newAddrestViewVC.h"
#import "selectMainView.h"
#import "SGQRCodeScanVC.h"
#import "addreManreDB.h"

@interface newAddrestViewVC ()<SGQRCodeScanDelegate>
@property(nonatomic,weak) UIButton*rBtn;
@property(nonatomic,strong) UIButton*seleBtn;
@property(nonatomic,strong) UIImageView*icimg;
@property(nonatomic,strong) UILabel*nameLab;

@property(nonatomic,strong)UITextField*addTextf;
@property(nonatomic,strong)UITextField*nameTextf;
@property(nonatomic,strong)UITextField*bzTextf;
@property(nonatomic,assign)NSInteger seleMainIndx;

@end

@implementation newAddrestViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _seleMainIndx=0;
    self.baseLab.text=getLocalStr(@"addreb4");
    [self loadNui];
    
    [self setUI];
    
    if(_type==1){
        self.nameLab.text=_addModel.ChinaCode;
        self.icimg.image=imageName(_addModel.ChinaCode);
        self.addTextf.text=_addModel.addreStr;
        self.nameTextf.text=_addModel.name;
        self.bzTextf.text=_addModel.subStr;
        [self.rBtn setTitleColor:mainColor forState:UIControlStateNormal];
        self.rBtn.enabled=YES;
    }
    
    // Do any additional setup after loading the view.
}
-(void)setUI{
    
    [self.view addSubview:self.seleBtn];
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), _seleBtn.bottom+gdValue(25), gdValue(300), gdValue(23))];
    tlab1.text=getLocalStr(@"addreb5");
    tlab1.font=fontMidNum(16);
    tlab1.textColor=ziColor;
    [self.view addSubview:tlab1];
    
    [self.view addSubview:self.addTextf];
    [self.view addSubview:self.nameTextf];
    [self.view addSubview:self.bzTextf];
    
    
}
-(void)loadNui{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(85), WDNavHeight, gdValue(70), gdValue(25));
    [rBtn setTitle:getLocalStr(@"wabcui") forState:UIControlStateNormal];
    [rBtn setTitleColor:zyincolor forState:UIControlStateNormal];
    rBtn.titleLabel.font=fontNum(16);
    rBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rBtn.enabled=NO;
    self.rBtn=rBtn;
    [rBtn addTarget:self action:@selector(tjiaKt) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navHeadView addSubview:rBtn];
}

#pragma mark --保存
-(void)tjiaKt{
    
    NSLog(@"s0--%@",self.nameLab.text);
    if(_seleMainIndx<4){//eth
    if(![Utility judgeETHadrre:self.addTextf.text]){
        
        [MBProgressHUD showText:getLocalStr(@"地址不合法")];
        
        return;
    }
    
    
    }
    else if([self.nameLab.text isEqualToString:@"TRON"]){
        if(![Utility isTRXAddre:self.addTextf.text]){
            
            [MBProgressHUD showText:getLocalStr(@"地址不合法")];
            
            return;
        }
    }
    
    
    if(_type==1){
        _addModel.ChinaCode=self.nameLab.text;
        _addModel.name=self.nameTextf.text;
        _addModel.addreStr=self.addTextf.text;
        _addModel.subStr=self.bzTextf.text;
        [_addModel bg_saveOrUpdate];
      
    }
    else{
    addreModel*model=[[addreModel alloc]init];
    model.ChinaCode=self.nameLab.text;
    model.name=self.nameTextf.text;
    model.addreStr=self.addTextf.text;
    model.subStr=self.bzTextf.text;
    model.creatimer=[Utility getNowTimeTimestamp];
        model.bg_tableName=bg_addresname;
        [model bg_save];
        
        
  
    
  
    }
    [self leftBarBtnClicked];
    [MBProgressHUD showText:getLocalStr(@"rzt6")];
}

-(UIButton*)seleBtn{
    if(!_seleBtn){
        _seleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _seleBtn.frame=CGRectMake(gdValue(15), WD_StatusHight+gdValue(15), SCREEN_WIDTH-gdValue(30), gdValue(55));
        _seleBtn.backgroundColor=cyColor;
        ViewRadius(_seleBtn, gdValue(6));
        
        UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(51), gdValue(42)/2, gdValue(6), gdValue(13))];
        seimg.image=imageName(@"dlad");
        [  _seleBtn addSubview:seimg];
        
        [_seleBtn addSubview:self.icimg];
        [_seleBtn addSubview:self.nameLab];
        [_seleBtn addTarget:self action:@selector(seleCk:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _seleBtn;
}
-(UIImageView*)icimg{
    if(!_icimg){
        _icimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(25)/2, gdValue(30), gdValue(30))];
        _icimg.image=imageName(@"ETH");
    }
    return _icimg;
}
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(_icimg.right+gdValue(10), gdValue(16), gdValue(gdValue(100)), gdValue(23))];
        _nameLab.text=@"ETH";
        _nameLab.font=fontBoldNum(16);
        _nameLab.textColor=ziColor;
    }
    return _nameLab;
        
}

-(UITextField*)addTextf{
    if(!_addTextf){
        _addTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(60)+_seleBtn.bottom, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_addTextf, gdValue(6));
        _addTextf.backgroundColor=cyColor;
        
        _addTextf.placeholder=getLocalStr(@"addreb6");
        _addTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"addreb6") attributes:
            @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                            NSFontAttributeName: _addTextf.font
            }];
        _addTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _addTextf.leftView=lefv;
        _addTextf.leftViewMode=UITextFieldViewModeAlways;
        
        [_addTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [btn addTarget:self action:@selector(txlckk) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
     
        [rigV addSubview:btn];
        _addTextf.rightView=rigV;
        _addTextf.rightViewMode=UITextFieldViewModeAlways;
        [btn  setImage:imageName(@"saom") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(semaok) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _addTextf;
}

-(UITextField*)nameTextf{
    if(!_nameTextf){
        _nameTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10)+_addTextf.bottom, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_nameTextf, gdValue(6));
        _nameTextf.backgroundColor=cyColor;
        
        _nameTextf.placeholder=getLocalStr(@"addreb7");
        _nameTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"addreb7") attributes:
            @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                            NSFontAttributeName: _nameTextf.font
            }];
        _nameTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _nameTextf.leftView=lefv;
        _nameTextf.leftViewMode=UITextFieldViewModeAlways;
        
        [_nameTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
   
        
    }
    return _nameTextf;
}

-(UITextField*)bzTextf{
    if(!_bzTextf){
        _bzTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10)+_nameTextf.bottom, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_bzTextf, gdValue(6));
        _bzTextf.backgroundColor=cyColor;
        
        _bzTextf.placeholder=getLocalStr(@"addreb8");
        _bzTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"addreb8") attributes:
            @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                            NSFontAttributeName: _bzTextf.font
            }];
        _bzTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _bzTextf.leftView=lefv;
        _bzTextf.leftViewMode=UITextFieldViewModeAlways;
        
        [_bzTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
   
        
    }
    return _bzTextf;
}
-(void)semaok{
    
    SGQRCodeManager *manager = [SGQRCodeManager QRCodeManager];
    manager.openLog = YES;
    [manager authorizationStatusBlock:^(SGQRCodeManager *manager, SGAuthorizationStatus authorizationStatus) {
        if (authorizationStatus == SGAuthorizationStatusSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
            SGQRCodeScanVC*svc=[[SGQRCodeScanVC alloc]init];
//            svc.type=1;
            svc.delegate=self;
            [svc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:svc animated:YES];
            });
        } else if (authorizationStatus == SGAuthorizationStatusFail) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
    
}
-(void)getSGQECodeUrlStr:(NSString *)urlStr{
    self.addTextf.text=urlStr;
}

-(void)limitStringt:(UITextField *)textField
{
  UITextField *myTextField = (UITextField *)textField;
  NSString *toBeString = myTextField.text;

  //获取高亮部分
  UITextRange *selectedRange = [textField markedTextRange];
  UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    NSInteger numd=200;
    if(textField==self.addTextf){
        numd=200;
    }
    else if(textField==self.nameTextf){
        numd=20;
    }
    else if (textField==self.bzTextf){
        numd=100;
    }

  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
  if (!position)
  {
      
     
      
      if (toBeString.length > numd)
      {
          NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:numd];
          if (rangeIndex.length == 1)
          {
              textField.text = [toBeString substringToIndex:numd];
          }
          else
          {
              NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, numd)];
              textField.text = [toBeString substringWithRange:rangeRange];
          }
      }
      
      
      
      
      else{
          
          if(self.nameLab.text.length>0&&self.addTextf.text.length>0&&self.nameTextf.text.length>0){
              
           
              [self.rBtn setTitleColor:mainColor forState:UIControlStateNormal];
              self.rBtn.enabled=YES;
          }
          else{
              [self.rBtn setTitleColor:UIColorFromRGB(0xD1DAF5) forState:UIControlStateNormal];
              
              self.rBtn.enabled=NO;
          }
         
      }
      
      
      
  }
}

#pragma mark 选择链
-(void)seleCk:(UIButton*)sender{
    
    [self.view endEditing:YES];
    
    selectMainView*view=[[selectMainView alloc]initWithFrame:SCREEN_FRAME  seleindx:_seleMainIndx arr:chinaCodeArr];
   
    view.type=@"1";
     WeakSelf;
     view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
         weakSelf.nameLab.text=nameStr;
         weakSelf.seleMainIndx=indx;
         weakSelf.icimg.image=imageName(nameStr);
//         [weakSelf.maincabtn setTitle:nameStr forState:UIControlStateNormal];
     };
     
     
     [view show];
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
