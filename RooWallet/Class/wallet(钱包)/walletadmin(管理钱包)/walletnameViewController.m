//
//  walletnameViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "walletnameViewController.h"

@interface walletnameViewController ()
@property(nonatomic,strong)UITextField*textFild;
@property(nonatomic,strong)UILabel*tslab;
@property(nonatomic,weak)UIButton*addBtn;
@end

@implementation walletnameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.baseLab.text=getLocalStr(@"adm24");
    
    [self.view addSubview:self.textFild];
    
    UIButton*addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(gdValue(35), SCREEN_HEIGHT-gdValue(122), SCREEN_WIDTH-gdValue(70), gdValue(50));
    ViewRadius(addBtn, gdValue(8));
    self.addBtn=addBtn;
    addBtn.backgroundColor=mainColor;
    [addBtn setTitle:getLocalStr(@"wabcui") forState:UIControlStateNormal];
    addBtn.titleLabel.font=fontNum(16);
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addCkl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tslab];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark 保存
-(void)addCkl{
    
    if(![Utility isBlankString:self.textFild.text]){
        
        if(self.textFild.text.length>12){
            [MBProgressHUD showText:getLocalStr(@"stcw")];
        }
       
        else {
            
            
            NSArray*art=[ userModel bg_findAll:bg_tablename];
            if(art.count>0){
            for(userModel*md in art){
                if([md.name isEqualToString:self.textFild.text]){
                    [MBProgressHUD showText:getLocalStr(@"adm21")];
                    return;
                }
                
            }
            }
            
            
            
            if([_delagate respondsToSelector:@selector(getWalletName:)]){
                [_delagate getWalletName:self.textFild.text];
            }
            
//            NSArray*userArr=[userModel bg_findAll:bg_tablename];
            self.model.name=self.textFild.text;
            [self.model bg_saveOrUpdate];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUSer" object:nil];
            
            
            [MBProgressHUD showText:getLocalStr(@"waxgcg")];
            [self leftBarBtnClicked];
            
        }
    }
    else{
        [MBProgressHUD showText:getLocalStr(@"tswkong")];
    }
}
-(UITextField*)textFild{
    if(!_textFild){
        _textFild=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(25), WD_StatusHight+gdValue(25), SCREEN_WIDTH-gdValue(50), gdValue(60))];
        
        ViewRadius(_textFild, gdValue(6));
        _textFild.backgroundColor=UIColorFromRGB(0xf5f6f9);
        _textFild.textColor=ziColor;
        _textFild.font=fontNum(16);
        _textFild.text=_nameStr;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(20), gdValue(60))];
        lefv.backgroundColor=UIColorFromRGB(0xf5f6f9);
        _textFild.leftView=lefv;
        _textFild.leftViewMode=UITextFieldViewModeAlways;
        [_textFild addTarget:self action:@selector(limitString:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _textFild;
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
