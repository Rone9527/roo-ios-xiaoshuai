//
//  walletCollectionViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "walletCollectionViewCell.h"
#import "coinsModel.h"
@interface walletCollectionViewCell()

@property(nonatomic,strong)UIButton*tranBtn;//转账
@property(nonatomic,strong)UIButton*collBtn;//收款
@property(nonatomic,strong)UIButton*fcanBtn;//闪兑
@property(nonatomic,strong)UIView*bgview;
@property(nonatomic,strong)UILabel*zcLab;
@property(nonatomic,strong)UIButton*zcbtn;//隐藏btn;
@end


@implementation walletCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self setUI];
    }
    return self;
}
-(UIView*)bgview{
    if(!_bgview){
        _bgview=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(150))];
        _bgview.backgroundColor=mainColor;
        ViewRadius(_bgview, gdValue(14));
        
    }
    
    return _bgview;
}
-(UILabel*)zcLab{
    if(!_zcLab){
        _zcLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), gdValue(20), gdValue(90), gdValue(20))];
       
        coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
        
        _zcLab.text=[NSString stringWithFormat: getLocalStr(@"wawddzc"),cmod.icon];
        _zcLab.font=fontNum(15);
        _zcLab.textColor=UIColorFromRGB(0xffffff);
    }
    
    return _zcLab;
}

-(UIButton*)zcbtn{
    if(!_zcbtn){
        _zcbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _zcbtn.frame=CGRectMake(_zcLab.right, gdValue(15), gdValue(30), gdValue(30));
        [_zcbtn setImage:imageName(@"zcxs") forState:UIControlStateNormal];
        [_zcbtn setImage:imageName(@"zcyc") forState:UIControlStateSelected];
        [_zcbtn addTarget:self action:@selector(yxsClick:) forControlEvents:UIControlEventTouchUpInside];
//        _zcbtn.backgroundColor=[UIColor redColor];
    }
    
    return _zcbtn;
}
-(void)setUI{
    
    
    [self.contentView addSubview:self.bgview];

//    [self setcolorjb:self.bgview];
 
   
    [self.bgview addSubview:self.zcLab];
    
    

    [self.bgview addSubview:self.zcbtn];
   
    [self.bgview addSubview:self.zcPriceLab];
    
    
    [self.bgview addSubview:self.tranBtn];
    [self.bgview addSubview:self.collBtn];
    [self.bgview addSubview:self.fcanBtn];
   
    
  
    
}

-(void)setIsHid:(BOOL)isHid{
    _isHid=isHid;
    if(isHid){
       
        self.zcbtn.selected=YES;
        self.zcPriceLab.text=@"*********";
//        [self yxsClick:self.zcbtn];
        
    }
    else{
        
        self.zcbtn.selected=NO;
        self.zcPriceLab.text=_allprc;
    }
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    _zcLab.text=[NSString stringWithFormat: getLocalStr(@"wawddzc"),cmod.icon];
}
-(void)setAllprc:(NSString *)allprc{
    _allprc=allprc;
    if(self.zcbtn.selected){
        self.zcPriceLab.text=@"*********";
    }
    else{
        self.zcPriceLab.text=allprc;
    }
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    _zcLab.text=[NSString stringWithFormat: getLocalStr(@"wawddzc"),cmod.icon];
}
#pragma mark 显示隐藏
-(void)yxsClick:(UIButton*)sender{
    
    sender.selected=!sender.selected;
    
    if(sender.selected){
        self.zcPriceLab.text=@"*********";
        
    }
    else{
        self.zcPriceLab.text=_allprc;
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"yincnot" object:@(sender.selected)];
    
}

-(UIButton*)tranBtn{
    if(!_tranBtn){
        _tranBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _tranBtn.frame=CGRectMake(gdValue(30), _zcPriceLab.bottom+gdValue(13), gdValue(60), gdValue(30));
        
        [_tranBtn setTitle:getLocalStr(@"watran") forState:UIControlStateNormal];
        [_tranBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _tranBtn.titleLabel.font=fontNum(15);
        [_tranBtn setImage:imageName(@"tran_1") forState:UIControlStateNormal];
        [_tranBtn addTarget:self action:@selector(tracCkl) forControlEvents:UIControlEventTouchUpInside];
        
        [_tranBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(8)];
    }
    
    return _tranBtn;
}
-(UIButton*)collBtn{
    if(!_collBtn){
        _collBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _collBtn.frame=CGRectMake(_tranBtn.right+(self.bgview.width-gdValue(240))/2, _tranBtn.y, gdValue(60), gdValue(30));
        
        [_collBtn setTitle:getLocalStr(@"wacloo") forState:UIControlStateNormal];
        [_collBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _collBtn.titleLabel.font=fontNum(15);
        [_collBtn setImage:imageName(@"tran_2") forState:UIControlStateNormal];
        [_collBtn addTarget:self action:@selector(tracCkl2) forControlEvents:UIControlEventTouchUpInside];
        [_collBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(8)];
    }
    
    return _collBtn;
}
-(UIButton*)fcanBtn{
    if(!_fcanBtn){
        _fcanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _fcanBtn.frame=CGRectMake(_collBtn.right+(self.bgview.width-gdValue(240))/2, _tranBtn.y, gdValue(60), gdValue(30));
        
        [_fcanBtn setTitle:getLocalStr(@"wafcan") forState:UIControlStateNormal];
        [_fcanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fcanBtn.titleLabel.font=fontNum(15);
        [_fcanBtn setImage:imageName(@"tran_3") forState:UIControlStateNormal];
        [_fcanBtn addTarget:self action:@selector(tracCkl3) forControlEvents:UIControlEventTouchUpInside];
        [_fcanBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(8)];
    }
    
    return _fcanBtn;
}
-(UILabel*)zcPriceLab{
    if(!_zcPriceLab){
        _zcPriceLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), gdValue(50), self.bgview.width-gdValue(40), gdValue(42))];
        _zcPriceLab.font=fontBoldNum(30);
        _zcPriceLab.textColor=[UIColor whiteColor];
//        _zcPriceLab.text=@"0.000";
        
    }
    return _zcPriceLab;
}
-(void)setcolorjb:(UIView*)gradationView{
   
        
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradationView.bounds;
    // 渐变色颜色数组,可多个
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x2052FF) CGColor], (id)[UIColorFromRGB(0x6BA1FF) CGColor], nil];
    // 渐变的开始点 (不同的起始点可以实现不同位置的渐变,如图)
    gradientLayer.startPoint = CGPointMake(0, 0.5f); //(0, 0)
    // 渐变的结束点
    gradientLayer.endPoint = CGPointMake(1, 0.5f); //(1, 1)
    [gradationView.layer insertSublayer:gradientLayer atIndex:0];
}
-(void)tracCkl{
    
    if(self.getwaBlock1){
        self.getwaBlock1(0);
        
    }
}
-(void)tracCkl2{
    
    if(self.getwaBlock1){
        self.getwaBlock1(1);
        
    }
}
-(void)tracCkl3{
    
    if(self.getwaBlock1){
        self.getwaBlock1(2);
        
    }
}

@end
