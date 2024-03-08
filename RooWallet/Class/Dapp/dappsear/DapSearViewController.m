//
//  DapSearViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import "DapSearViewController.h"
#import "LLSearchView.h"
#import "DAppSearchView.h"
#import "dapptyModel.h"
@interface DapSearViewController ()<UITextFieldDelegate,dappsearchDelagate>
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
//@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) DAppSearchView*searchView;

@property(nonatomic,strong)UITextField*serTextf;
@property(nonatomic,weak)UIButton*btn;
@end

@implementation DapSearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self setnavConfig];
    [self.serTextf becomeFirstResponder];
    // Do any additional setup after loading the view.
}
-(void)setUI{
    [self.navHeadView addSubview:self.serTextf];
    
    [self.view addSubview:self.searchView];
    
    
}

-(void)RestData{

}
-(void)setnavConfig{
    
 
    
}
-(void)ssClick{
    if(![Utility isBlankString:self.serTextf.text ]){
      [self pushToSearchResultWithSearchStr:self.serTextf.text];
    }
    else{
       [ MBProgressHUD showText:@"请输入搜索关键词"];
        
    }
}
-(void)scclick{
    
    self.serTextf.text=nil;
}
//搜索虚拟键盘响应

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
  
    [self.view endEditing:YES];
    
    [self pushToSearchResultWithSearchStr:textField.text];
  
    return YES;
    
}

-(void)reqsdata:(NSString*)resqStr{
    
    NSDictionary*dic=@{@"searchParam":resqStr};
    NSMutableArray*arr=[NSMutableArray array];
//    NSString*url=[NSString stringWithFormat:@"%@%@?searchParam=%@",HostApi,dalistAPI,resqStr];
    
    [MBProgressHUD showHUD];
    [Request GET:dalistAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"search---%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
        
            NSArray*art=responseObject[@"data"];
//            userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];;
            
            for(NSDictionary*dict in art){
                dapptyModel*model =[dapptyModel mj_objectWithKeyValues:dict];
                
    
                [arr addObject:model];
                
            }
            
            
            [self.searchView getsearData:[arr copy] tit:self.serTextf.text];
            
        }
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"err---%@",[error localizedDescription]);
    }];
    
}
-(void)getseleindex:(NSString *)str{
    [self pushToSearchResultWithSearchStr:str];
    
}
#pragma mark --搜索结果
- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    if(![Utility isBlankString:str]){
    self.serTextf.text = str;
//    [self.serTextf resignFirstResponder];
        
        [self reqsdata:str];
       
    [self setHistoryArrWithStr:str];
    }
    else{
       [MBProgressHUD showText:@"请输入搜索关键词"];
    }
}
-(void)textFieldDidChange:(UITextField *)theTextField{
    if(theTextField.text.length<=0){
     
            self.btn.hidden=YES;
        
        [self.searchView sethisUIArr:[NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath]];
        
    }
    else{
        
        self.btn.hidden=NO;
        NSLog(@"sd1---%@ ",theTextField.text);
//        NSString*srt = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//        theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//        NSString*srt [theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *temp = [theTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        temp=[temp stringByReplacingOccurrencesOfString:@" " withString:@""];
//        temp=[temp stringByReplacingOccurrencesOfString:@"1" withString:@""];
        NSLog(@"sd2---%@",temp);
        
//        [self  pushToSearchResultWithSearchStr:temp];
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


- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
       
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}

-(DAppSearchView*)searchView{
    
    if(!_searchView){
        _searchView=[[DAppSearchView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT - WD_StatusHight) historyArray:self.historyArray];
        _searchView.delagate=self;
    }
    return _searchView;
}

//- (LLSearchView *)searchView
//{
//    if (!_searchView) {
//        self.searchView = [[LLSearchView alloc] initWithFrame:CGRectMake(0, WD_StatusHight,SCREEN_WIDTH, SCREEN_HEIGHT - WD_StatusHight) hotArray:self.hotArray historyArray:self.historyArray];
//        WeakSelf;
//        _searchView.tapAction = ^(NSString *str) {
//
//            [weakSelf pushToSearchResultWithSearchStr:str];
//        };
//    }
//    return _searchView;
//}
-(UITextField*)serTextf{
    if(!_serTextf){
        _serTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(50),kStatusBarHeight, SCREEN_WIDTH-gdValue(65), gdValue(40))];
        ViewRadius(_serTextf, gdValue(6));
        _serTextf.backgroundColor=cyColor;
        _serTextf.placeholder=getLocalStr(@"adm5");
        _serTextf.font=fontNum(16);
        _serTextf.delegate=self;
        _serTextf.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"adm5") attributes:
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
        [btn  setImage:imageName(@"sergb") forState:UIControlStateNormal];
        
    }
    return _serTextf;
}
-(void)tapp{
    [self.searchView sethisUIArr:[NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath]];
    
    self.serTextf.text=@"";
    
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
