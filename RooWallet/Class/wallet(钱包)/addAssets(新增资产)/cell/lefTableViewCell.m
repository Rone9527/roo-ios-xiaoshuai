//
//  lefTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "lefTableViewCell.h"

@interface lefTableViewCell()


@property(nonatomic,strong)UIView*col;
@end

@implementation lefTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}

-(void)setUI{
    [self.contentView addSubview:self.coinimg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.col];
    [self.contentView addSubview:self.ybgv];
    
}
-(UIView*)ybgv{
    if(!_ybgv){
    _ybgv=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(12), gdValue(3), gdValue(53))];
        _ybgv.backgroundColor=mainColor;
     
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_ybgv.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(gdValue(2), gdValue(2))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame = _ybgv.bounds;
               maskLayer.path = maskPath.CGPath;
        _ybgv.layer.mask = maskLayer;
        _ybgv.hidden=YES;
    }
    return _ybgv;
}
-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(75)-1, 0, 1, gdValue(80))];
        _col.backgroundColor=cyColor;
    }
    return _col;
}
-(UIImageView*)coinimg{
    if(!_coinimg){
        _coinimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(21), gdValue(12), gdValue(33), gdValue(33))];
//        ViewRadius(_coinimg, gdValue(33)/2);
        ViewBorderRadius(_coinimg, gdValue(33)/2, 1, cyColor);
//        _coinimg.image=imageName(@"icdf");
        
    }
    return _coinimg;
}

-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(2), _coinimg.bottom+gdValue(5), gdValue(71), gdValue(20))];
//        _nameLab.text=@"BTC";
        _nameLab.font=fontMidNum(14);
        _nameLab.textColor=zyincolor;
        _nameLab.textAlignment=NSTextAlignmentCenter;
        _nameLab.adjustsFontSizeToFitWidth=YES;
    }
    return _nameLab;
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
