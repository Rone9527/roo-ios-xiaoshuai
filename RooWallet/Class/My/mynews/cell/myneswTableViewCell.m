//
//  myneswTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "myneswTableViewCell.h"
#import "tranDetModel.h"
@interface myneswTableViewCell()
@property(nonatomic,strong)UIImageView*ztimg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*adrLab;
@property(nonatomic,strong)UILabel*timeLab;
@property(nonatomic,strong)UIImageView*rimgh;
@end


@implementation myneswTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self setUI];
    }
    return self;
}

-(void)setUI{
    
    [self.contentView addSubview:self.ztimg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.adrLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.rimgh];
    
    
}
-(void)setModel:(tranDetModel *)model{
    
    self.nameLab.text=[NSString stringWithFormat:@"%@ %@ %@",model.amount,model.token,getLocalStr(@"收款成功")];
    self.adrLab.text=[NSString stringWithFormat:@"%@：%@",getLocalStr(@"接收地址"),model.toAddr];
    self.timeLab.text=[Utility upTimeHHmm:model.timeStamp];
    
    
}
-(UIImageView*)rimgh{
    if(!_rimgh){
        _rimgh=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(27), gdValue(34), gdValue(6), gdValue(12))];
        _rimgh.image=imageName(@"dlad");
        
    }
    return _rimgh;
}
-(UIImageView*)ztimg{
    if(!_ztimg){
        _ztimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(16), gdValue(25), gdValue(30), gdValue(30))];
        _ztimg.image=imageName(@"trddet_2");
        
    }
    
    return _ztimg;
}
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(_ztimg.right+gdValue(10), gdValue(12), gdValue(230), gdValue(20))];
//        _nameLab.text=@"273823.31 FNC 收款成功";
        _nameLab.font=fontNum(14);
        _nameLab.textColor=ziColor;
        _nameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _nameLab;
}
-(UILabel*)adrLab{
    if(!_adrLab){
        _adrLab=[[UILabel alloc]initWithFrame:CGRectMake(_ztimg.right+gdValue(10), gdValue(3)+_nameLab.bottom, gdValue(230), gdValue(15))];
//        _adrLab.text=@"接收地址：747846gddisddgsdsdsdsdsdsd";
        _adrLab.font=fontMidNum(11);
        _adrLab.textColor=zyincolor;
        _adrLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _adrLab;
}
-(UILabel*)timeLab{
    if(!_timeLab){
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_ztimg.right+gdValue(10), _adrLab.bottom+gdValue(3), gdValue(230), gdValue(15))];
//        _timeLab.text=@"09/04/2020 14:32:52";
        _timeLab.font=fontNum(11);
        _timeLab.textColor=zyincolor;
      
        
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
