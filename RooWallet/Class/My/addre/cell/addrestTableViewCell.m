//
//  addrestTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "addrestTableViewCell.h"
#import "addreModel.h"
@interface addrestTableViewCell()
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,strong)UIImageView*icimg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*addrsLab;
@property(nonatomic,strong)UILabel*msLab;

@end

@implementation addrestTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=cyColor;
       [self setUI];
    }
    return self;
}
-(void)setUI{
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.icimg];
    [self.bgView addSubview:self.nameLab];
    [self.bgView addSubview:self.addrsLab];
    [self.bgView addSubview:self.msLab];
    
}
-(void)setModel:(addreModel *)model
{
    
    self.icimg.image=imageName(model.ChinaCode);
    self.nameLab.text=model.name;
    self.addrsLab.text=model.addreStr;
    self.msLab.text=model.subStr;
    
    
    
}
-(UIView*)bgView{
    if(!_bgView){
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(gdValue(12), 0, SCREEN_WIDTH-gdValue(24), gdValue(113))];
        ViewRadius(_bgView, gdValue(8));
        _bgView.backgroundColor=[UIColor whiteColor];
        
    }
    return _bgView;
}
-(UIImageView*)icimg{
    if(!_icimg){
        _icimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(12), gdValue(11), gdValue(25), gdValue(25))];
        _icimg.image=imageName(@"icdm");
    }
    return _icimg;
}
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(_icimg.right+gdValue(10), gdValue(12),_bgView.width-gdValue(65), gdValue(23))];
        _nameLab.text=@"小明USDT";
        _nameLab.textColor=ziColor;
        _nameLab.font=fontBoldNum(16);
    }
    return _nameLab;
}
-(UILabel*)addrsLab{
    if(!_addrsLab){
        _addrsLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(12), gdValue(12)+_icimg.bottom,_bgView.width-gdValue(30), gdValue(23))];
//        _addrsLab.text=@"JHSDGF355345HHK56345JHSDGF355345HHK56345";
        _addrsLab.textColor=ziColor;
        _addrsLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
        _addrsLab.font=fontNum(14);
    }
    return _addrsLab;
}
-(UILabel*)msLab{
    if(!_msLab){
        _msLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(12), gdValue(9)+_addrsLab.bottom,_bgView.width-gdValue(62), gdValue(23))];
        _msLab.text=@"概要概要概要概要概要概要概要概要概要概要";
        _msLab.textColor=zyincolor;
        _msLab.font=fontNum(14);
    }
    return _msLab;
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
