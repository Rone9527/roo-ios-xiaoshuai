//
//  WalletTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "WalletTableViewCell.h"
#import "symbolModel.h"
#import "coinsModel.h"
#import "ratesModel.h"

@interface WalletTableViewCell()

@property(nonatomic,strong)UIImageView*iconImg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*priceLab;
@property(nonatomic,strong)UILabel*numLab;
@property(nonatomic,strong)UILabel*danpriceLab;
@property(nonatomic,copy)NSString*price;
@property(nonatomic,copy)NSString*allPrc;
@end

@implementation WalletTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}

-(void)setUI{
    
    
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.priceLab];
    [self.contentView addSubview:self.numLab];
    [self.contentView addSubview:self.danpriceLab];
    
}
-(void)setModel:(symbolModel *)model{
    
    _model=model;
    self.nameLab.text=model.symbol;
    
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
    if([model.symbol isEqualToString:@"USDT"]){
        model.price=@"1";
        model.pricdecimals=@"4";
        
    }
    if([Utility isBlankString:model.pricdecimals]){
        model.pricdecimals=@"4";
    }
    
    NSString*atr=[NSString stringWithFormat:@"%f",[model.price doubleValue]*[tare doubleValue]];

    
    _price=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility douVale:atr num:[model.pricdecimals intValue]]];
    
    //总价=价格*数量
    NSString*atrr=[NSString stringWithFormat:@"%f",[model.price doubleValue]*[tare doubleValue]*[model.numRest doubleValue]];
    
    
    _allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility douVale:atrr num:[model.pricdecimals intValue]]];//总价
    
    if(_isYinc){
       
        self.numLab.text=@"****";
        self.danpriceLab.text=@"****";
    }
    else{
       
      
        self.numLab.text=model.numRest;
        if([Utility isBlankString:model.numRest]){
            self.numLab.text=@"0";
        }
      
        self.danpriceLab.text=_allPrc;
        
        
    }
    self.nameLab.text=model.symbol;
    self.priceLab.text=_price;
    
//    NSLog(@"sdf---%@",model.icon);
//    [self.iconImg sd_setImageWithURL:Url_Str(model.icon) placeholderImage:[Utility vireimg:[self.nameLab.text substringToIndex:1] hig:gdValue(30)]];
    
    [self.iconImg sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
}

-(void)setIsYinc:(BOOL)isYinc{
    _isYinc=isYinc;
    if(isYinc){
        self.priceLab.text=@"****";
        self.numLab.text=@"****";
        self.danpriceLab.text=@"****";
    }
    else{
        self.priceLab.text=_price;
        self.nameLab.text=_model.symbol;
        self.numLab.text=_model.numRest;
        if([Utility isBlankString:_model.numRest]){
            self.numLab.text=@"0";
        }
      
        self.danpriceLab.text=_allPrc;
    }
}
-(UILabel*)danpriceLab{
    if(!_danpriceLab){
        _danpriceLab=[[UILabel alloc]initWithFrame:CGRectMake(_numLab.x+gdValue(30), gdValue(2)+_numLab.bottom, _numLab.width-gdValue(30), gdValue(17))];
//        _danpriceLab.text=@"￥4,222.34";
        _danpriceLab.font=fontNum(12);
        _danpriceLab.textColor=UIColorFromRGB(0xA8B0BC);
        _danpriceLab.textAlignment=NSTextAlignmentRight;
    }
    return  _danpriceLab;
}
-(UILabel*)numLab{
    if(!_numLab){
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(215), _nameLab.y, gdValue(200), gdValue(23))];
        _numLab.text=@"0.00";
        _numLab.font=fontMidNum(16);
        _numLab.textAlignment=NSTextAlignmentRight;
        _numLab.textColor=UIColorFromRGB(0x333333);
        
    }
    return _numLab;
}

-(UILabel*)priceLab{
    if(!_priceLab){
        _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(_nameLab.x, gdValue(2)+_nameLab.bottom, gdValue(125), gdValue(17))];
//        _priceLab.text=@"￥1123.231";
        _priceLab.font=fontNum(12);
        _priceLab.textColor=UIColorFromRGB(0xA8B0BC);
        
    }
    return _priceLab;
}

-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(_iconImg.right+gdValue(10), gdValue(15), gdValue(100), gdValue(23))];
//        _nameLab.text=@"BTC";
        _nameLab.font=fontBoldNum(16);
        _nameLab.textColor=UIColorFromRGB(0x333333);
        
    }
    return _nameLab;
}
-(UIImageView*)iconImg{
    if(!_iconImg){
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectIntegral(CGRectMake(gdValue(15), gdValue(20), gdValue(30), gdValue(30)))];
        _iconImg.image=imageName(@"icdm");
//        ViewRadius(_iconImg, gdValue(15));
//        ViewBorderRadius(_iconImg, gdValue(5), 1,[UIColor whiteColor]);
    }
    return _iconImg;
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
