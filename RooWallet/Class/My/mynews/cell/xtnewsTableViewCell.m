//
//  xtnewsTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/8/17.
//

#import "xtnewsTableViewCell.h"
#import "neswModel.h"

@interface xtnewsTableViewCell()

@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*crtLab;
@property(nonatomic,strong)UILabel*timeLab;
@property(nonatomic,strong)UIView*col;

@end

@implementation xtnewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}

-(void)setUI{
    
    
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.crtLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.col];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.crtLab.frame=CGRectMake(gdValue(15), gdValue(7)+_nameLab.bottom, SCREEN_WIDTH-gdValue(38), self.height-gdValue(50));
    
    _col.frame=CGRectMake(0, self.height-1, SCREEN_WIDTH, 1);
    
}
-(void)setModel:(neswModel *)model{
    
    self.nameLab.text=model.msgTitle;
    self.crtLab.text=model.msgContent;
    
    
    self.timeLab.text=[Utility  upTimeHHmm:model.publishTime geshi:@"MM/dd HH:mm"];
    
}

-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(100)-1, SCREEN_WIDTH, 1)];
        _col.backgroundColor=cyColor;
    }
    
    return _col;
}
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(18), gdValue(260), gdValue(20))];
//        _nameLab.text=@"273823.31 FNC 收款成功";
        _nameLab.font=fontMidNum(14);
        _nameLab.textColor=ziColor;
//        _nameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _nameLab;
}
-(UILabel*)crtLab{
    if(!_crtLab){
        _crtLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(7)+_nameLab.bottom, SCREEN_WIDTH-gdValue(38), gdValue(40))];
//        _crtLab.text=@"273823.31 FNC 收款成功273823.31 FNC 收款成功273823.31 FNC 收款成功273823.31 FNC 收款成功273823.31 FNC 收款成功273823.31 FNC 收款成功273823.31 FNC 收款成功273823.31 FNC 收款成功";
        _crtLab.font=fontMidNum(11);
        _crtLab.textColor=zyincolor;
        _crtLab.numberOfLines=2;
//        _nameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _crtLab;
}
-(UILabel*)timeLab{
    if(!_timeLab){
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(115), _nameLab.y,gdValue(100), gdValue(20))];
//        _timeLab.text=@"2323232";
        _timeLab.font=fontMidNum(11);
        _timeLab.textAlignment=NSTextAlignmentRight;
        _timeLab.textColor=zyincolor;
      
//        _nameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _timeLab;
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
