//
//  jysmarkTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/7/30.
//

#import "jysmarkTableViewCell.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "jysmarkModel.h"

@interface jysmarkTableViewCell()
@property(nonatomic,strong)UIImageView*logoimg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*zjLab;
@property(nonatomic,strong)UILabel*peicLab;
@property(nonatomic,strong)UILabel*zfdLab;
@property(nonatomic,strong)UIView*col;

@end

@implementation jysmarkTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}

-(void)setUI{
    
    [self.contentView addSubview:self.logoimg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.zjLab];
    [self.contentView addSubview:self.peicLab];
    [self.contentView addSubview:self.zfdLab];
    [self.contentView addSubview:self.col];
    
    
}
-(void)setModel:(jysmarkModel *)model{
    

//    NSLog(@"sd---%@   %@",model.marketCapUsd  ,[Utility changeAsset:model.marketCapUsd]);
    
    
    [self.logoimg sd_setFadeImageWithURL:Url_Str(model.logo) placeholderImage:imageName(@"mrtu")];
    
    if(![Utility isBlankString:model.nameZh]){
        self.nameLab.text=model.nameZh;
    }
    else{
    self.nameLab.text=model.name;
    }
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];

    NSDictionary*dc=[rmod mj_keyValues];//汇率

    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
//    NSLog(@"s--%@  %@  %@",tare,model.price,rmod.CNY);

    NSString*atr=[NSString stringWithFormat:@"%f",[model.price doubleValue]*[tare doubleValue]];
    NSString*atrt=[NSString stringWithFormat:@"%.2f",[model.vol doubleValue]];

    NSString*price=[NSString stringWithFormat:@"%@",[Utility douVale:atr num:2]];


    self.zfdLab.text= [NSString stringWithFormat:@"%@",[Utility changeAsset:atrt]];

    self.peicLab.text= [NSString stringWithFormat:@"%@",[Utility changeAsset:price]] ;
    
    self.zjLab.text=[NSString stringWithFormat:@"%@/%@",model.pair1,model.pair2];//model.symbolPair;
    

    
    
    
}
-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(60)-1, SCREEN_WIDTH-gdValue(30), 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}
-(UIImageView*)logoimg{
    if(!_logoimg){
        _logoimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(30), gdValue(30))];
//        _logoimg.contentMode=UIViewContentModeScaleAspectFill;
//        _logoimg.clipsToBounds=YES;
        ViewBorderRadius(_logoimg, gdValue(8), 1, [UIColor whiteColor]);
    }
    return _logoimg;
}

-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10)+_logoimg.right, gdValue(10), gdValue(100), gdValue(23))];
        _nameLab.textColor=ziColor;
        _nameLab.font=fontMidNum(14);
        _nameLab.adjustsFontSizeToFitWidth=YES;
//        _nameLab.text=@"BTC";
    }
    return _nameLab;
}
-(UILabel*)zjLab{
    if(!_zjLab){
        _zjLab=[[UILabel alloc]initWithFrame:CGRectMake(_nameLab.x, _nameLab.bottom, gdValue(100), gdValue(17))];
        _zjLab.textColor=zyincolor;
        _zjLab.font=fontNum(12);
//        _zjLab.text=@"￥4.37万亿";
    }
    return _zjLab;
}

-(UILabel*)peicLab{
    if(!_peicLab){
        _peicLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(210), gdValue(18), gdValue(80), gdValue(24))];
        _peicLab.textColor=ziColor;
        _peicLab.font=fontMidNum(14);
//        _peicLab.text=@"￥22.83万";
        _peicLab.textAlignment=NSTextAlignmentRight;
    }
    return _peicLab;
}

-(UILabel*)zfdLab{
    if(!_zfdLab){
        _zfdLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(115), gdValue(15), gdValue(100), gdValue(30))];
        _zfdLab.textColor=ziColor;
        _zfdLab.font=fontMidNum(14);
        _zfdLab.textAlignment=NSTextAlignmentRight;
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
