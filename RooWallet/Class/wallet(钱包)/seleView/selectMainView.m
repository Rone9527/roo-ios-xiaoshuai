//
//  selectMainView.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "selectMainView.h"
@interface selectMainView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,assign)NSInteger seindx;
@property(nonatomic,copy)NSArray*titArr;
@end

@implementation selectMainView
- (instancetype)initWithFrame:(CGRect)frame  seleindx:(NSInteger)seleindx arr:(NSArray*)titArr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _titArr=titArr;
        _seindx=seleindx;
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
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,gdValue(100), SCREEN_WIDTH, SCREEN_HEIGHT-gdValue(100))];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
    [self.sheetView addSubview:self.headView];
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
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}

-(void)setType:(NSString *)type{
    _type=type;
    [self.setTableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"setID" forIndexPath:indexPath];
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
  
    UIImageView*cimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(25), gdValue(20), gdValue(30), gdValue(30))];
    NSString*str=[NSString stringWithFormat:@"%@",_titArr[indexPath.row]];
    if([str isEqualToString:getLocalStr(@"adm19")]){
        str=@"bqbu";
    }
    
    
  
    cimg.image=imageName(str);
    [cell.contentView addSubview:cimg];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(cimg.right+gdValue(10), gdValue(20), gdValue(200), gdValue(30))];
    if([_type isEqualToString:@"1"]){
        
//    tlab.text=_titArr[indexPath.row];
        
        NSString*str=[NSString stringWithFormat:@"%@ %@",_titArr[indexPath.row],getLocalStr(@"链")];
        tlab.text=str;
    }
    else{
        tlab.text= [NSString stringWithFormat:@"%@%@",_titArr[indexPath.row],getLocalStr(@"adm20")];
        if(indexPath.row==0){
            tlab.text=_titArr[indexPath.row];
        }
    }
   
    
    
    tlab.font=fontBoldNum(16);
    tlab.textColor=ziColor;
    [cell.contentView addSubview:tlab];
    
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(43), gdValue(52)/2, gdValue(18), gdValue(18))];
    seimg.image=imageName(@"selemain");
    [cell.contentView addSubview:seimg];
    seimg.hidden=YES;
  
    if(_seindx==indexPath.row){
        seimg.hidden=NO;
    }
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(70)-1, SCREEN_WIDTH, 1)];
    col.backgroundColor=cyColor;
    [cell.contentView addSubview:col];
    
    
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
   
    
    _seindx=indexPath.row;
    [self.setTableView reloadData];
    
    if(self.getselectIndx){
        self.getselectIndx(indexPath.row,_titArr[indexPath.row]);
    }
    
        [self hide];
    
        
   
}
-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _headView.bottom, SCREEN_WIDTH, _sheetView.height-_headView.bottom) style:UITableViewStylePlain];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xfffffff);

//            _setTableView.tableHeaderView=self.headView;
        
        UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(60))];
        fotv.backgroundColor=[UIColor whiteColor];
        _setTableView.tableFooterView=fotv;
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setID"];
//        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(56))];
        
        
        
        _headView.backgroundColor=UIColorFromRGB(0xffffff);
        
        UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
        naLab.text=getLocalStr(@"wasema");
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
