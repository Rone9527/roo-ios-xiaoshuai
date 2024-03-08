//
//  dappswapView.m
//  RooWallet
//
//  Created by mac on 2021/7/20.
//

#import "dappswapView.h"
#import "authsmView.h"
#import "addAsstsViewController.h"
@interface dappswapView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)NSMutableArray*titArr;
@property(nonatomic,strong)NSMutableArray*titArr1;
@property(nonatomic,assign)NSInteger seindx;

@end

@implementation dappswapView
-(NSMutableArray*)titArr1{
    if(!_titArr1){
        _titArr1=[NSMutableArray array];
    }
    return _titArr1;
}
-(NSMutableArray*)titArr{
    if(!_titArr){
        _titArr=[NSMutableArray array];
    }
    return _titArr;
}
- (instancetype)initWithFrame:(CGRect)frame  seleindx:(NSInteger)seleindx{
    
    self = [super initWithFrame:frame];
    if (self) {
     

        
       userModel*usermodl=[userModel bg_findAll:bg_tablename][selewalletIndex];


        NSArray*userWallArr= usermodl.walletArray;

//
        [self.titArr1 removeAllObjects];
//
        for(walletModel*modl in userWallArr){

            [self.titArr1 addObject:modl.name];
        }
        
        [self.titArr addObjectsFromArray:chinaCodeArr];
        
//        [self.titArr addObject:@"ETH"];
//        [self.titArr addObject:@"BSC"];
//        [self.titArr addObject:@"HECO"];
        
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
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-gdValue(460), SCREEN_WIDTH, gdValue(460))];
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
    rect.origin.y = SCREEN_HEIGHT-gdValue(460);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titArr.count;
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
  
    cimg.image=imageName(str);
    [cell.contentView addSubview:cimg];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(cimg.right+gdValue(10), gdValue(20), gdValue(200), gdValue(30))];
    tlab.text=[NSString stringWithFormat:@"%@%@",_titArr[indexPath.row],getLocalStr(@"钱包")];
    tlab.font=fontBoldNum(16);
    tlab.textColor=ziColor;
    [cell.contentView addSubview:tlab];
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(70)-1, SCREEN_WIDTH, 1)];
    col.backgroundColor=cyColor;
    [cell.contentView addSubview:col];
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(43), gdValue(52)/2, gdValue(18), gdValue(18))];
    seimg.image=imageName(@"selemain");
    [cell.contentView addSubview:seimg];
    seimg.hidden=YES;
  
    if(_seindx==indexPath.row){
        seimg.hidden=NO;
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
   
   
    [self.setTableView reloadData];
    
    [self hide];
    
    if(![self.titArr1 containsObject:self.titArr[indexPath.row]]){
       
//        WeakSelf;
        authsmView*view=[[authsmView alloc]initWithFrame:SCREEN_FRAME tit:self.titArr[indexPath.row]];
        view.numblock = ^{
            addAsstsViewController*addVc=[[addAsstsViewController alloc]init];
//            addVc.userModel=usModel;
            [addVc setHidesBottomBarWhenPushed:YES];
            [[Utility dc_getCurrentVC].navigationController pushViewController:addVc animated:YES];
            
        };
        
        return;
    }
    else{
    
    if(self.getselectIndx){
        self.getselectIndx(indexPath.row,_titArr[indexPath.row]);
    }
        
    }
    
        [self hide];
    
        
   
}
-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:_sheetView.bounds style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= UIColorFromRGB(0xfffffff);

            _setTableView.tableHeaderView=self.headView;
        
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(56))];
        
        
        
        _headView.backgroundColor=UIColorFromRGB(0xffffff);
        
        UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
        naLab.text=getLocalStr(@"选择钱包");
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
