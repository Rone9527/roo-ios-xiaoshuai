//
//  dappTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "dappTableViewCell.h"
#import "dapptyModel.h"
@interface dappTableViewCell()
@property(nonatomic,strong)UIView*bgview;
@property(nonatomic,strong)UIImageView*iconImg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*priceLab;


@end


@implementation dappTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}
-(void)setUI{
   
//    [self.contentView addSubview:self.bgview];
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.priceLab];
   
    
}

-(void)setModel:(dapptyModel *)model{
    
    self.nameLab.text=model.name;

//    [self.iconImg sd_setImageWithURL:Url_Str(model.icon) placeholderImage:[Utility vireimg:[model.name substringToIndex:1] hig:gdValue(36)]];
//    NSLog(@"sdsdsds---%@",model.icon);
//    
    [self.iconImg sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
    self.priceLab.text=model.discription;
}


-(UILabel*)priceLab{
    if(!_priceLab){
        _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(_nameLab.x, gdValue(2)+_nameLab.bottom, gdValue(220), gdValue(17))];
//        _priceLab.text=@"Uniswap是建立在以太坊区块链上的首个...";
        _priceLab.font=fontNum(12);
        _priceLab.textColor=zyincolor;
        
    }
    return _priceLab;
}

-(UIView*)bgview{
    if(!_bgview){
        _bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(70))];
        _bgview.backgroundColor=[UIColor whiteColor];
    }
    return _bgview;
}
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(_iconImg.right+gdValue(10), gdValue(15), gdValue(190), gdValue(23))];
        _nameLab.text=@"Uniswap";
        _nameLab.font=fontMidNum(16);
        _nameLab.textColor=UIColorFromRGB(0x333333);
        
    }
    
    return _nameLab;
}
-(UIImageView*)iconImg{
    if(!_iconImg){
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(17), gdValue(36), gdValue(36))];
//        ViewRadius(_iconImg, gdValue(10));
        
        ViewBorderRadius(_iconImg, gdValue(8), 0.1, [UIColor clearColor]);
//        _iconImg.image=imageName(@"icdm");
 
        
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
