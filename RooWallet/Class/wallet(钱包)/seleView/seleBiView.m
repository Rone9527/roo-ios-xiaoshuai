//
//  seleBiView.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "seleBiView.h"
#import "WalletTableViewCell.h"
#import "tranMoenyViewController.h"
#import "collectMoenyViewController.h"
#import "TronTranViewController.h"

@interface seleBiView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)UITextField*serTextf;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSArray*dataArr;
@property(nonatomic,strong)NSMutableArray*dataSearArr;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,weak)UIButton*btn;
@end

@implementation seleBiView
-(NSMutableArray*)dataSearArr{
    if(!_dataSearArr){
        _dataSearArr=[NSMutableArray array];
    }
    return _dataSearArr;
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0,gdValue(50), SCREEN_WIDTH,self.setTableView.height-gdValue(100))imgstr:@"serno" tis:getLocalStr(@"serno")];
        _noView.hidden=YES;
    }
    
    return _noView;
}
- (instancetype)initWithFrame:(CGRect)frame  type:(NSInteger) typ Tokenarr:(NSArray*)dataArr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _dataArr=dataArr;
        [self.dataSearArr addObjectsFromArray:dataArr];
        _type=typ;
        [self setUI];
        
      
        
    }
 
    return self;
}
-(void)setAddrs:(NSString *)addrs{
    _addrs=addrs;
}

-(void)setUI{
    self.frame=SCREEN_FRAME;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
    [self addGestureRecognizer:tap];
//
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,gdValue(100), SCREEN_WIDTH, SCREEN_HEIGHT-gdValue(100))];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
    [self.sheetView addSubview:self.headView];
    [self.sheetView addSubview:self.setTableView];
    [self.setTableView addSubview:self.noView];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sheetView.bounds;
           maskLayer.path = maskPath.CGPath;
    sheetView.layer.mask = maskLayer;
}
/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
    [self endEditing:YES];
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT;
    WeakSelf;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.sheetView.frame = rect;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.sheetView removeFromSuperview];
//
    }];
}
-(void)delView{
    [self removeFromSuperview];
    [self.sheetView removeFromSuperview];
}
-(void)dealloc{
    NSLog(@"selehui");
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = gdValue(100);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSearArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"setbiID" forIndexPath:indexPath];
    
    if(self.dataSearArr.count){
//        cell.isYinc=_isYinc;
//        cell.swipeDelegate = self;
        cell.model=self.dataSearArr[indexPath.row];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(70);
    
   
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
 
    symbolModel*symodel=self.dataSearArr[indexPath.row];
    if(_type==1){
        
        collectMoenyViewController*cllVc=[[collectMoenyViewController alloc]init];
        cllVc.iconname=symodel.chainCode;
        cllVc.iconnamed=symodel.symbol;
        cllVc.addreStr=symodel.addres;
        [cllVc setHidesBottomBarWhenPushed:YES];
        [[Utility dc_getCurrentVC].navigationController pushViewController:cllVc animated:YES];
    }
    else if (_type==0){
        if([symodel.chainCode isEqualToString:@"TRON"]){
            
            TronTranViewController*trVc=[[TronTranViewController alloc]init];
           
            trVc.symodel=symodel;
            trVc.addrest=_addrs;
            [trVc setHidesBottomBarWhenPushed:YES];
            [[Utility dc_getCurrentVC].navigationController pushViewController:trVc animated:YES];
        }
        else{
    tranMoenyViewController*travC=[[tranMoenyViewController alloc]init];
   
        travC.symodel=symodel;
        travC.addrest=_addrs;
//        travC.usmdel=self.u
    [travC setHidesBottomBarWhenPushed:YES];
    [[Utility dc_getCurrentVC].navigationController pushViewController:travC animated:YES];
            
        }
    }
             
    
        [self hide];
    
        
   
}
-(UITextField*)serTextf{
    if(!_serTextf){
        _serTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(57), SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_serTextf, gdValue(6));
        _serTextf.backgroundColor=cyColor;
        _serTextf.placeholder=getLocalStr(@"addAsst3");
        _serTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"addAsst3") attributes:
            @{NSForegroundColorAttributeName:zyincolor,
                            NSFontAttributeName:_serTextf.font
            }];
        _serTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        lefv.backgroundColor=cyColor;
        UIImageView*levim=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(35)/2, gdValue(20), gdValue(20))];
        levim.image=imageName(@"sert");
        [lefv addSubview:levim];
        
        _serTextf.leftView=lefv;
        _serTextf.leftViewMode=UITextFieldViewModeAlways;
        
        [_serTextf  addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(40))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(tapp) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
        self.btn=btn;
        btn.hidden=YES;
        [rigV addSubview:btn];
        _serTextf.rightView=rigV;
        _serTextf.rightViewMode=UITextFieldViewModeWhileEditing;
        _serTextf.keyboardType = UIKeyboardTypeASCIICapable;
        [btn  setImage:imageName(@"sergb") forState:UIControlStateNormal];
        
    }
    return _serTextf;
}
-(void)tapp{
    self.serTextf.text=@"";
    [self textFieldDidChange:self.serTextf];
    
}

#pragma  mark --SearbarDelegate--
-(void)textFieldDidChange:(UITextField *)theTextField{
    if(theTextField.text.length>0){
        self.btn.hidden=NO;
    }
    else{
        self.btn.hidden=YES;
    }
    
    [self.dataSearArr removeAllObjects];
    NSString*textStr=theTextField.text;
    NSString*searStr=[textStr  uppercaseString];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        if (textStr!=nil && textStr.length>0) {


            for(int i=0;i<self.dataArr.count;i++){
                symbolModel *model=self.dataArr[i];
                
                NSString *tempStr = model.symbol;
                NSString *tempStrr = model.contractId;
                
                if([tempStr containsString:searStr]||[tempStrr containsString:searStr]){
                  
                    [self.dataSearArr addObject:model];
                }
            }

        }
     
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(self.dataSearArr.count){
                
                self.noView.hidden=YES;
            }
            else{
                if(theTextField.text.length<=0){
                    self.noView.hidden=YES;
                    [self.dataSearArr addObjectsFromArray:self.dataArr];
                }
                else{
                self.noView.hidden=NO;
                }
            }
            [self.setTableView reloadData];
        });
    });
    
    
}


-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _headView.bottom, SCREEN_WIDTH, _sheetView.height-_headView.bottom) style:UITableViewStylePlain];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xfffffff);

//        _setTableView.tableHeaderView=self.headView;
        UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(60))];
        fotv.backgroundColor=[UIColor whiteColor];
        _setTableView.tableFooterView=fotv;
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[WalletTableViewCell class] forCellReuseIdentifier:@"setbiID"];
//        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(120))];
        
        
        
        _headView.backgroundColor=UIColorFromRGB(0xffffff);
        
        UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
        naLab.text=getLocalStr(@"xzzct");
        naLab.font=fontBoldNum(16);
        naLab.textAlignment=NSTextAlignmentCenter;
        naLab.textColor=ziColor;
        [_headView addSubview:naLab];
     
        UIButton*gbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        gbBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45),gdValue(13), gdValue(30), gdValue(30));
        [gbBtn setImage:imageName(@"gbin") forState:UIControlStateNormal];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
        [gbBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:gbBtn];
      
        
        [_headView addSubview:self.serTextf];
        
    }
    
    return _headView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
