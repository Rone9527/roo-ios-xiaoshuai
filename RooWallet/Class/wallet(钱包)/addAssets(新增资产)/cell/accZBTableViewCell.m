//
//  accZBTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/9/15.
//

#import "accZBTableViewCell.h"

@interface accZBTableViewCell()
@property(nonatomic,strong)UIImageView*coinimg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*addreLab;

@property(nonatomic,strong)UIView*col;
@end

@implementation accZBTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
  
    _col.frame=CGRectMake(0, gdValue(70)-1, self.width, 1);
//    [self setUI];
}

-(void)setModel:(myAssectModel *)model{
//    self.coinimg.image=;
   
    _model=model;
   

    [self.coinimg sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];

    
    NSString*availableBalance=[NSString stringWithFormat:@"%@",model.availableBalance];
    
    availableBalance=  [Utility removeFloatAllZero:[Utility douVale:availableBalance num:6]];
    self.addreLab.text=[NSString stringWithFormat:getLocalStr(@"flsht1"),availableBalance];
//        self.addreLab.text=model.name;
    

//    NSLog(@"sdsdsdsd----%@",model.symbol);
    self.nameLab.text=model.symbol;
   
    
   

    
    
}
-(void)setUI{
    [self.contentView addSubview:self.coinimg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.addreLab];
    
    [self.contentView addSubview:self.col];
    
}

-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(70)-1, self.width, 1)];
        _col.backgroundColor=cyColor;
        
    }
    return _col;
}
-(UIImageView*)coinimg{
    if(!_coinimg){
        _coinimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(17), gdValue(20), gdValue(30), gdValue(30))];
//        _coinimg.image=imageName(@"icdm");
//        ViewRadius(_coinimg, gdValue(15));
        ViewBorderRadius(_coinimg, gdValue(15), 1, cyColor);
    }
    return _coinimg;
}

-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10)+_coinimg.right,gdValue(15), gdValue(200), gdValue(23))];
        _nameLab.text=@"BTC";
        _nameLab.font=fontMidNum(16);
        _nameLab.textColor=ziColor;
    
    }
    return _nameLab;
}

-(UILabel*)addreLab{
    if(!_addreLab){
        _addreLab=[[UILabel alloc]initWithFrame:CGRectMake(_nameLab.x,_nameLab.bottom, gdValue(240), gdValue(17))];
//        _addreLab.text=@"YRISTDFJFD77FGAGFKFGerwfsdfsfasfcasdfasd";
        _addreLab.font=fontNum(12);
        _addreLab.textColor=ziColor;
        _addreLab.text=[NSString stringWithFormat:getLocalStr(@"flsht1"),@"0.00"];
//        _addreLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    }
    return _addreLab;
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
