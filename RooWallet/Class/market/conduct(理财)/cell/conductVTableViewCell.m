//
//  conductVTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/7/7.
//

#import "conductVTableViewCell.h"
#import "conduModel.h"
@interface conductVTableViewCell()
@property(nonatomic,strong)UIView*bgview;
@property(nonatomic,strong)UIImageView*icomg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UIView*bqianview;
@property(nonatomic,strong)UILabel*tshiLab;
@property(nonatomic,strong)UILabel*zfdLab;
@property(nonatomic,strong)UILabel*syiLab;
@property(nonatomic,strong)UIView*col;


@end

@implementation conductVTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=cyColor;
       [self setUI];
    }
    return self;
}
-(void)setUI{
    
    [self.contentView addSubview:self.bgview];
    [self.bgview addSubview:self.icomg];
    [self.bgview addSubview:self.nameLab];
    [self.bgview addSubview:self.bqianview];
    [self.bgview addSubview:self.tshiLab];
    [self.bgview addSubview:self.zfdLab];
    [self.bgview addSubview:self.syiLab];
    [self.bgview addSubview:self.col];
    
    
    
}

-(void)setModel:(conduModel *)model{
    _model=model;
    
//    [self.icomg sd_setImageWithURL:Url_Str(model.logo) placeholderImage:imageName(@"mrtu")];
    [self.icomg  sd_setFadeImageWithURL:Url_Str(model.logo) placeholderImage:imageName(@"mrtu")];
    self.nameLab.text=model.name;
    self.tshiLab.text= [NSString stringWithFormat:@"%@ %@", model.ascription,getLocalStr(@"提供")];
    self.zfdLab.text=[NSString stringWithFormat:@"%.2f%%",[model.rateOfReturn floatValue]*100 ];
    
    
    NSArray*art=[model.tag componentsSeparatedByString:@","];
    [self loadbqUI:art];
    
}
-(void)loadbqUI:(NSArray*)art{
    
    
//    NSArray*art=@[@"低风险",@"收益稳定"];
    for(UILabel*lab in self.bqianview.subviews){
        [lab removeFromSuperview];
        
    }
    CGFloat wdf=0.0;
    for(int i=0;i<art.count;i++){
        
        CGFloat wid=[Utility withForString:art[i] fontSize:11 andhig:gdValue(20)]+gdValue(20);
        
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(wdf, 0, wid, gdValue(20))];
        lab.text=art[i];
        lab.font=fontNum(11);
        lab.textAlignment=NSTextAlignmentCenter;
        lab.textColor=UIColorFromRGB(0xA8B0BC);
        lab.backgroundColor=[UIColorFromRGB(0x376AFF) colorWithAlphaComponent:0.06];
        ViewBorderRadius(lab, gdValue(3), 1, [UIColorFromRGB(0x376AFF) colorWithAlphaComponent:0.6]);
        
        wdf=wdf+wid+gdValue(14);
        [self.bqianview addSubview:lab];
        
    }
    
    
}

-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), _syiLab.bottom+gdValue(20), _bgview.width-gdValue(30), 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}

-(UIView*)bgview{
    if(!_bgview){
        _bgview=[[UIView alloc]initWithFrame:CGRectMake(gdValue(10), 0, SCREEN_WIDTH-gdValue(20), gdValue(124))];
        _bgview.backgroundColor=[UIColor whiteColor];
        ViewRadius(_bgview, gdValue(8));
        
    }
    return _bgview;
}
-(UIImageView*)icomg{
    if(!_icomg){
        _icomg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(30), gdValue(30))];
        ViewRadius(_icomg, gdValue(10));
        
//        _icomg.backgroundColor=[UIColor redColor];
    }
    return _icomg;
}
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(_icomg.right+gdValue(10), gdValue(19), gdValue(150), gdValue(22))];
//        _nameLab.text=@"质押挖矿 - USDT";
        _nameLab.font=fontBoldNum(16);
        _nameLab.textColor=ziColor;
    }
    return _nameLab;
}


-(UIView*)bqianview{
    if(!_bqianview){
        _bqianview=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), _icomg.bottom+gdValue(17), gdValue(240), gdValue(20))];
        _bqianview.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _bqianview;
}
-(UILabel*)tshiLab{
    if(!_tshiLab){
        _tshiLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), _bqianview.bottom+gdValue(18), gdValue(200), gdValue(15))];
        
//        _tshiLab.text=@"Uniswap 提供";
        _tshiLab.font=fontNum(11);
        _tshiLab.textColor=zyincolor;
        
    }
    return _tshiLab;
}
-(UILabel*)zfdLab{
    if(!_zfdLab){
        _zfdLab=[[UILabel alloc]initWithFrame:CGRectMake(_bgview.width-gdValue(145),gdValue(20), gdValue(130), gdValue(35))];
        
//        _zfdLab.text=@"35.42%";
        _zfdLab.font=fontBoldNum(25);
        _zfdLab.textColor=UIColorFromRGB(0xFA4400);
        _zfdLab.textAlignment=NSTextAlignmentRight;
    }
    return _zfdLab;
}
-(UILabel*)syiLab{
    if(!_syiLab){
        _syiLab=[[UILabel alloc]initWithFrame:CGRectMake(_bgview.width-gdValue(95),gdValue(3)+_zfdLab.bottom, gdValue(80), gdValue(16))];
        
        _syiLab.text=@"当前收益率";
        _syiLab.font=fontNum(12);
        _syiLab.textColor=zyincolor;
        _syiLab.textAlignment=NSTextAlignmentRight;
    }
    return _syiLab;
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
