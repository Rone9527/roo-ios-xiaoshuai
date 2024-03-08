//
//  actShootView.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "actShootView.h"
@interface actShootView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,copy)NSArray*trr;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,copy)NSString*tishi;
@property(nonatomic,assign)CGFloat higt;
@end

@implementation actShootView
- (instancetype)initWithFrame:(CGRect)frame  arr:(NSArray*)titArr tis:(NSString*)tishi{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        
      
        if([Utility isBlankString:tishi]){
            _higt=gdValue(60)*titArr.count+gdValue(10);
        }
        else{
            _higt=gdValue(60)*titArr.count+gdValue(60)+gdValue(10);
        }
        _tishi=tishi;
        _trr=titArr;
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
//
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-_higt, SCREEN_WIDTH, _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
    [self.sheetView addSubview:self.setTableView];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _trr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"setID" forIndexPath:indexPath];
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UILabel*setlab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(20),SCREEN_WIDTH, gdValue(20))];
    setlab.text=getLocalStr(_trr[indexPath.row]) ;
    setlab.font=fontMidNum(16);
    setlab.textColor=ziColor;
    setlab.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:setlab];
    
    if(indexPath.row==_trr.count-1){
        UIView*vi=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(10))];
        [cell.contentView addSubview:vi];
        
        
        vi.backgroundColor=UIColorFromRGB(0xf5f6f9);
     
        setlab.frame=CGRectMake(0, gdValue(30),SCREEN_WIDTH, gdValue(20));
        
    }
    else if(indexPath.row==_trr.count-2){
        
      
        if(![setlab.text isEqualToString:getLocalStr(@"adm9")] ){
            
            setlab.textColor=UIColorFromRGB(0xFA6400);
            
            if([setlab.text isEqualToString:getLocalStr(@"adm8")]){
                
                setlab.textColor=ziColor;
                
                
            }
            
        }
        
       
    }
    else{
        
        UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(60)-1, SCREEN_WIDTH, 1)];
        bgv.backgroundColor=UIColorFromRGB(0xf5f6f9);
        [cell.contentView addSubview:bgv];
    }
  
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_trr.count-1){
        return gdValue(70);
    }
    return gdValue(60);
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
   
    
    if(indexPath.row==_trr.count-1){
        [self hide];
        
    }
    else{
      
    if(self.getIndx){
        self.getIndx(indexPath.row);
    }
        
        [self hide];
    }
        
   
}
-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:_sheetView.bounds style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xfffffff);
        if(![Utility isBlankString:_tishi]){
            _setTableView.tableHeaderView=self.headView;
        }
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(60))];
        
        
        
        _headView.backgroundColor=UIColorFromRGB(0xffffff);
        
        UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(5), SCREEN_WIDTH, gdValue(50))];
        naLab.text=_tishi;
        naLab.font=fontNum(16);
        naLab.textAlignment=NSTextAlignmentCenter;
        naLab.numberOfLines=2;
        naLab.textColor=zyincolor;
        [_headView addSubview:naLab];
        
        UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(60)-1, SCREEN_WIDTH, 1)];
        bgv.backgroundColor=UIColorFromRGB(0xf5f6f9);
        [_headView addSubview:bgv];
        
      
        
        
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
