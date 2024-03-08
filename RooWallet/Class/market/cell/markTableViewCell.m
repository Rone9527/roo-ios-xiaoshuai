//
//  markTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "markTableViewCell.h"
#import "marktModel.h"
#import "coinsModel.h"
#import "ratesModel.h"
@interface markTableViewCell()

@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*zjLab;
@property(nonatomic,strong)UILabel*peicLab;
@property(nonatomic,strong)UILabel*usdLab;
@property(nonatomic,strong)UILabel*zfdLab;
@property(nonatomic,strong)UIView*col;


@end


@implementation markTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}


-(void)setUI{
    [self.contentView addSubview:self.tsLab];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.zjLab];
    [self.contentView addSubview:self.usdLab];
    [self.contentView addSubview:self.peicLab];
    [self.contentView addSubview:self.zfdLab];
    
    [self.contentView addSubview:self.col];
    
    
}
-(void)setModel:(marktModel *)model{
    

//    NSLog(@"sd---%@   %@",model.marketCapUsd  ,[Utility changeAsset:model.marketCapUsd]);
    
    
    
    self.nameLab.text=model.baseAsset;
    
    self.usdLab.text=[Utility douVale:model.price num:[model.decimals intValue]];
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
//    NSLog(@"s--%@  %@  %@",tare,model.price,rmod.CNY);
   
    NSString*atr=[NSString stringWithFormat:@"%f",[model.price doubleValue]*[tare doubleValue]];
    NSString*atrt=[NSString stringWithFormat:@"%f",[model.marketCapUsd doubleValue]*[tare doubleValue]];
    
    NSString*price=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility douVale:atr num:[model.decimals intValue]]];
    
    
    self.zjLab.text= [NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility changeAsset:[Utility douVale:atrt num:2]]];
    
    self.peicLab.text=  price ;
    
    NSString*zdStr=model.priceChangePercent;
    
    if([model.priceChangePercent containsString:@"-"]){
        zdStr=[[zdStr componentsSeparatedByString:@"-"]lastObject];
        
        _zfdLab.text=[NSString stringWithFormat:@"-%@%%",[Utility douVale:zdStr num:2]];
        _zfdLab.backgroundColor=outColor;
    }
    
    else {
       
        _zfdLab.text=[NSString stringWithFormat:@"+%@%%",[Utility douVale:zdStr num:2] ];
        _zfdLab.backgroundColor=upColor;
        
        if ([model.priceChangePercent floatValue]==0.00){
            _zfdLab.text=@"0.00%";
             _zfdLab.backgroundColor=UIColorFromRGB(0xC4C9D8);
         }
       
    }
  
   
    
  
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _zfdLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft  | UIRectCornerBottomRight cornerRadii:CGSizeMake(gdValue(8), gdValue(8))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame =  _zfdLab.bounds;
           maskLayer.path = maskPath.CGPath;
    _zfdLab.layer.mask = maskLayer;
    
}
-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(60)-1, SCREEN_WIDTH, 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}
-(UILabel*)tsLab{
    if(!_tsLab){
        _tsLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(20), gdValue(20), gdValue(20))];
        _tsLab.textColor=zyincolor;
        _tsLab.font=fontMidNum(13);
    }
    return _tsLab;
}

-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(5)+_tsLab.right, gdValue(10), gdValue(100), gdValue(23))];
        _nameLab.textColor=ziColor;
        _nameLab.font=fontMidNum(16);
//        _nameLab.text=@"BTC";
    }
    return _nameLab;
}
-(UILabel*)zjLab{
    if(!_zjLab){
        _zjLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(5)+_tsLab.right, _nameLab.bottom, gdValue(100), gdValue(17))];
        _zjLab.textColor=zyincolor;
        _zjLab.font=fontMidNum(12);
//        _zjLab.text=@"￥4.37万亿";
    }
    return _zjLab;
}
-(UILabel*)usdLab{
    if(!_usdLab){
        _usdLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(310), gdValue(10), gdValue(200), gdValue(23))];
        _usdLab.textColor=ziColor;
        _usdLab.font=fontBoldNum(16);
//        _peicLab.text=@"￥22.83万";
        _usdLab.textAlignment=NSTextAlignmentRight;
    }
    return _usdLab;
}
-(UILabel*)peicLab{
    if(!_peicLab){
        _peicLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(310), gdValue(2)+_usdLab.bottom, gdValue(200), gdValue(17))];
        _peicLab.textColor=zyincolor;
        _peicLab.font=fontMidNum(12);
//        _peicLab.text=@"￥22.83万";
        _peicLab.textAlignment=NSTextAlignmentRight;
    }
    return _peicLab;
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
