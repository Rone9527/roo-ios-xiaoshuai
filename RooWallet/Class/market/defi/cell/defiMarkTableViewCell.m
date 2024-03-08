//
//  defiMarkTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/8/3.
//

#import "defiMarkTableViewCell.h"
#import "defiModel.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "WaterRippleAndView.h"

@interface defiMarkTableViewCell()
@property(nonatomic,strong)UIImageView*logo;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*bqLab;
@property(nonatomic,strong)UILabel*tvlLab;
@property(nonatomic,strong)UILabel*blLab;
@property(nonatomic,strong)UILabel*pricLab;
@property(nonatomic,strong)UILabel*zfdLab;
@property(nonatomic,strong)UIView*col;
@property (nonatomic, strong) WaterRippleAndView *BackView;
@end

@implementation defiMarkTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self loadUI];
        
        
    }
    return self;
}
-(void)loadUI{
    
//    [self.contentView addSubview:self.BackView];
    
//    [self.contentView addSubview:self.logo];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.bqLab];
    [self.contentView addSubview:self.zfdLab];
    [self.contentView addSubview:self.col];
    [self.contentView addSubview:self.tvlLab];
    [self.contentView addSubview:self.blLab];
    [self.contentView addSubview:self.pricLab];
   
    
}
-(WaterRippleAndView*)BackView{
    if(!_BackView){
        _BackView=[[WaterRippleAndView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(60)-1)];
        _BackView.backgroundColor=[UIColor whiteColor];
    }
    
    return _BackView;
}
-(void)setModel:(defiModel *)model{
    
    
//    [self.logo sd_setFadeImageWithURL:Url_Str(model.logo) placeholderImage:imageName(@"mrtu")];
    
    self.nameLab.text=model.pairName;
    
    
    CGFloat wid=[Utility withForString:model.ascription fontSize:12 andhig:gdValue(20)]+gdValue(10);
    
    self.bqLab.frame=CGRectMake(gdValue(15), gdValue(3)+_nameLab.bottom, wid, gdValue(20));
    self.bqLab.text=model.ascription;
    self.tvlLab.frame=CGRectMake(_bqLab.right+gdValue(5), _bqLab.y, gdValue(110), gdValue(20));
    
    
    
    self.blLab.text=[NSString stringWithFormat:@"1:%@",model.price];
    
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
//    NSLog(@"s--%@  %@  %@",tare,model.price,rmod.CNY);
   
    NSString*atr=[NSString stringWithFormat:@"%f",[model.priceUSD doubleValue]*[tare doubleValue]];
    NSString*atrr=[NSString stringWithFormat:@"%f",[model.volumeUSD doubleValue]*[tare doubleValue]];
    
    NSString*price=[NSString stringWithFormat:@"≈%@ %@",cmod.icon,[Utility douVale:atr num:2]];
    NSString*pricee=[NSString stringWithFormat:@"TVL:%@ %@",cmod.icon,[Utility changeAsset:[Utility douVale:atrr num:2]]];
//    [NSString stringWithFormat:@"TVL:%@ %@",cmod.icon,[Utility douVale:atrr num:2]];
    
    self.pricLab.text=  price ;
    self.tvlLab.text=pricee;
    
    
    NSString*zdStr=[NSString stringWithFormat:@"%.2f%%",[model.rateOfPrice floatValue]*100 ]; ;
    
    if([zdStr containsString:@"-"]){
        zdStr=[[zdStr componentsSeparatedByString:@"-"]lastObject];
        
        _zfdLab.text=[NSString stringWithFormat:@"-%@%%",[Utility douVale:zdStr num:2]];
        _zfdLab.backgroundColor=outColor;
    }
    
    else {
       
        _zfdLab.text=[NSString stringWithFormat:@"+%@%%",[Utility douVale:zdStr num:2] ];
        _zfdLab.backgroundColor=upColor;
        
        if ([zdStr floatValue]==0.00){
            _zfdLab.text=@"0.00%";
             _zfdLab.backgroundColor=UIColorFromRGB(0xC4C9D8);
         }
       
    }
  
   
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _zfdLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft  | UIRectCornerBottomRight cornerRadii:CGSizeMake(gdValue(8), gdValue(8))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame =  _zfdLab.bounds;
           maskLayer.path = maskPath.CGPath;
    _zfdLab.layer.mask = maskLayer;
    
    _zfdLab.adjustsFontSizeToFitWidth=YES;
    
    
}



-(UIImageView*)logo{
    if(!_logo){
        _logo=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(11), gdValue(15), gdValue(15))];
        ViewBorderRadius(_logo, gdValue(15)/2, 0.5, UIColorFromRGB(0xffffff));
        
    }
    return _logo;
}

-(UILabel*)nameLab{
    
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(7), gdValue(120), gdValue(23))];
        _nameLab.textColor=ziColor;
        _nameLab.font=fontMidNum(16);
        _nameLab.text=@"";
    }
    return _nameLab;
}

-(UILabel*)bqLab{
    
    if(!_bqLab){
        _bqLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(3)+_nameLab.bottom, gdValue(50), gdValue(20))];
        _bqLab.textColor=zyincolor;
        _bqLab.font=fontNum(12);
        _bqLab.textAlignment=NSTextAlignmentCenter;
        _bqLab.text=@"";
        ViewBorderRadius(_bqLab, gdValue(3), 0.5, UIColorFromRGB(0xffffff));
        _bqLab.backgroundColor=cyColor;
        
    }
    return _bqLab;
}
-(UILabel*)tvlLab{
    
    if(!_tvlLab){
        _tvlLab=[[UILabel alloc]initWithFrame:CGRectMake(_bqLab.right+gdValue(5), _bqLab.y, gdValue(100), gdValue(20))];
        _tvlLab.textColor=zyincolor;
        _tvlLab.font=fontNum(12);
        _tvlLab.text=@"";
    }
    return _tvlLab;
}
-(UILabel*)blLab{
    
    if(!_blLab){
        _blLab=[[UILabel alloc]initWithFrame:CGRectMake(_zfdLab.x-gdValue(125), gdValue(7), gdValue(110), gdValue(23))];
        _blLab.textColor=ziColor;
        _blLab.font=fontBoldNum(16);
//        _blLab.text=@"111";
        _blLab.textAlignment=NSTextAlignmentRight;
    }
    return _blLab;
}
-(UILabel*)pricLab{
    
    if(!_pricLab){
        _pricLab=[[UILabel alloc]initWithFrame:CGRectMake(_blLab.x, _tvlLab.y, _blLab.width, gdValue(17))];
        _pricLab.textColor=zyincolor;
        _pricLab.font=fontNum(12);
//        _pricLab.text=@"111";
        _pricLab.textAlignment=NSTextAlignmentRight;
    }
    return _pricLab;
}


-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(60)-1, SCREEN_WIDTH, 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}
-(UILabel*)zfdLab{
    if(!_zfdLab){
        _zfdLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(90), gdValue(25)/2, gdValue(80), gdValue(35))];
        _zfdLab.textColor=[UIColor whiteColor];
        _zfdLab.font=fontBoldNum(15);
        _zfdLab.textAlignment=NSTextAlignmentCenter;
    }
    return _zfdLab;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
