//
//  frsitFWView.m
//  RooWallet
//
//  Created by mac on 2021/9/8.
//

#import "frsitFWView.h"
@interface frsitFWView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *fotView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)dapptyModel*model;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)NSMutableArray*dataArr1;
@property(nonatomic,assign)CGFloat hig;
@end

@implementation frsitFWView
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[[NSMutableArray alloc]initWithObjects:getLocalStr(@"DApp名称："), getLocalStr(@"简介："),getLocalStr(@"网址："),nil];
    }
    return _dataArr;
}
-(NSMutableArray*)dataArr1{
    if(!_dataArr1){
        _dataArr1=[NSMutableArray array];
    }
    return _dataArr1;
}
- (instancetype)initWithFrame:(CGRect)frame  modell:(dapptyModel*)model{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        [self.dataArr1 addObject:model.name];
        [self.dataArr1 addObject:model.discription];
        [self.dataArr1 addObject:model.links];
        
      
        _hig=[Utility heightForString:model.discription fontSize:gdValue(14) andWidth:SCREEN_WIDTH-gdValue(127)]+gdValue(10);
        if(_hig<gdValue(30)){
            _hig=gdValue(30);
        }
        
        else if (_hig>gdValue(70)){
            _hig=gdValue(70);
        }
       
        
        if(![Utility isBlankString:model.officialEmail]){
            [self.dataArr addObject:getLocalStr(@"邮箱：")];
            [self.dataArr1 addObject:model.officialEmail];
        }
        if(![Utility isBlankString:model.telegram]){
            [self.dataArr addObject:getLocalStr(@"Telegram：")];
            [self.dataArr1 addObject:model.telegram];
        }
        if(![Utility isBlankString:model.twitter]){
            [self.dataArr addObject:getLocalStr(@"Twitter：")];
            [self.dataArr1 addObject:model.twitter];
        }
        
        _higt=gdValue(370)+gdValue(35)*5+_hig;
        
        _model=model;
        [self setUI];
        
      
        
    }
 
    return self;
}


-(void)setUI{
    self.frame=SCREEN_FRAME;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
    [self addGestureRecognizer:tap];
////
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-_higt, SCREEN_WIDTH, _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sheetView.bounds;
           maskLayer.path = maskPath.CGPath;
    sheetView.layer.mask = maskLayer;
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
    naLab.text=getLocalStr(@"dapts1");
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
    
    [_sheetView addSubview:self.mainTableview];
    

    CGFloat wid=(SCREEN_WIDTH-gdValue(55))/2;
    for(int i=0;i<2;i++){
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(15)+(wid+gdValue(25))*i, _mainTableview.bottom+gdValue(15), wid, gdValue(50));
    
        btn.titleLabel.font=fontMidNum(16);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ViewRadius(btn, gdValue(8));
        if(i==0){
            [btn setTitle:getLocalStr(@"dapts5") forState:UIControlStateNormal];
            btn.backgroundColor=UIColorFromRGB(0x5F69E8);
            
        }
        else{
            [btn setTitle:getLocalStr(@"dapts6") forState:UIControlStateNormal];
            btn.backgroundColor=mainColor;
        }
        
        btn.tag=2325+i;
        [btn addTarget:self action:@selector(trackk:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetView addSubview:btn];
        
    }
   
    
}




#pragma mark --TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"fwID" forIndexPath:indexPath];
     
     for(UIView * vi in cell.contentView.subviews){
               [vi removeFromSuperview];
           }
      cell.backgroundColor= [UIColor whiteColor];
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), 0, gdValue(80), gdValue(35))];
    tlab.text=self.dataArr[indexPath.row];
    tlab.font=fontNum(14);
    tlab.textColor=zyincolor;
    [cell.contentView addSubview:tlab];
    
    UILabel*tlabb=[[UILabel alloc]initWithFrame:CGRectMake(tlab.right+gdValue(14), 0, SCREEN_WIDTH-gdValue(127), gdValue(35))];
    tlabb.text=self.dataArr1[indexPath.row];
    tlabb.font=fontNum(14);
    tlabb.textColor=ziColor;
   
    [cell.contentView addSubview:tlabb];
    
    if(indexPath.row==1){
        tlabb.frame=CGRectMake(tlab.right+gdValue(14), 0, SCREEN_WIDTH-gdValue(127), _hig);
        tlabb.numberOfLines=0;
    }
    else if (indexPath.row>1){
        
        CGFloat wid=[Utility withForString:self.dataArr1[indexPath.row] fontSize:gdValue(14) andhig:gdValue(35)]+gdValue(10);
        
        if(wid>gdValue(200)){
            wid=gdValue(200);
            
        }
        tlabb.frame=CGRectMake(tlab.right+gdValue(14), 0, wid, gdValue(35));
        
        UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(tlabb.right+gdValue(5), gdValue(10), gdValue(15), gdValue(15))];
        img.image=imageName(@"dappfz");
        [cell.contentView addSubview:img];
        
        
    }
    
    
    return cell;
    
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
    
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(indexPath.row==1){
        return _hig;
    }
    return gdValue(35);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if(indexPath.row>1){
        NSString*srt=self.dataArr1[indexPath.row];
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = srt;
           if (pab == nil) {
             
           } else {
               [MBProgressHUD showText:getLocalStr(@"复制成功")];
           }
            
        
    }
    
 
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,gdValue(58), SCREEN_WIDTH,_sheetView.height-gdValue(58)-gdValue(90)) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=[UIColor whiteColor];
       
        [_mainTableview registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"fwID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.tableHeaderView=self.headView;
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        _mainTableview.tableFooterView=self.fotView;
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(10))];//457 372
        _headView.backgroundColor=[UIColor whiteColor];
      

    }
    return _headView;
}

-(UIView*)fotView{
    if(!_fotView){
        _fotView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(180))];//457 372
        _fotView.backgroundColor=[UIColor whiteColor];
        
        UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(50), SCREEN_WIDTH-gdValue(30), gdValue(130))];
        ViewRadius(bgv, gdValue(8));
        bgv.backgroundColor=cyColor;
        [_fotView addSubview:bgv];
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(18), gdValue(20), gdValue(100), gdValue(20))];
        tlab.text=getLocalStr(@"风险提示");
        tlab.font=fontMidNum(16);
        tlab.textColor=ziColor;
        [bgv addSubview:tlab];
        
        UILabel*tlabb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(18),tlab.bottom+gdValue(10), bgv.width-gdValue(36), gdValue(60))];
        tlabb.text=getLocalStr(@"Roo walle上所展示的信息，均来自于第三方，仅供参考，项目具体情况需用户自行查证，Roo wallet 不承担任何保证责任");
        tlabb.numberOfLines=0;
        tlabb.font=fontNum(14);
        tlabb.textColor=ziColor;
        [bgv addSubview:tlabb];
        
    
        
    }
    return _fotView;
}







-(void)trackk:(UIButton*)sender{
    [self hide];
    
    if(sender.tag==2326){
      
        if(self.block){
            self.block();
            
        }
    }
    
   
    
}
-(void)selewtCkk:(UIButton*)sender{
    sender.selected=!sender.selected;
}
/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT;
    WeakSelf;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.sheetView.frame = rect;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.sheetView removeFromSuperview];
        
    }];
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT-_higt;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}
-(void)dealloc{
    NSLog(@"tis__hui");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
