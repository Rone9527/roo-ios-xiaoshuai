//
//  accsctTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/9/14.
//

#import "accsctTableViewCell.h"
#import "blockModel.h"

@interface accsctTableViewCell()
@property(nonatomic,strong)UIImageView*coinimg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*addreLab;
@property(nonatomic,strong)UILabel*numLab;
@property(nonatomic,strong)UIView*col;

@end

@implementation accsctTableViewCell
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
    _adBtn.frame=CGRectMake(self.width-gdValue(40), gdValue(25), gdValue(20), gdValue(20));
    _col.frame=CGRectMake(0, gdValue(70)-1, self.width, 1);
//    [self setUI];
}

-(void)setModel:(myAssectModel *)model{
//    self.coinimg.image=;
   
    _model=model;
   

    [self.coinimg sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
//    self.nameLab.text=model.symbol;
    NSString*namer;
    NSString*namerr;
    namer=model.tokenVO.symbol;
    
//    if(![Utility isBlankString:model.contractId]){
        namerr=[NSString stringWithFormat:@"(%@ Token)",model.chainCode];
     namer=[NSString stringWithFormat:@"%@ %@",model.tokenVO.symbol,namerr];
        self.addreLab.text=model.contractId;
//    }
    
    NSString*availableBalance=[NSString stringWithFormat:@"%@",model.availableBalance];
    
    availableBalance=  [Utility removeFloatAllZero:[Utility douVale:availableBalance num:6]];
    self.numLab.text=[NSString stringWithFormat:getLocalStr(@"flsht1"),availableBalance];
    
    
    _nameLab.attributedText=[Utility getText:namer colo:zyincolor font:fontNum(12) rangText:namerr];
   
    
    if(model.isSeled){

//        _adBtn.selected=YES;
        
        _adBtn.image=imageName(@"addactS");
    }
    else{
        _adBtn.image=imageName(@"addactN");
//        _adBtn.selected=NO;

    }
    

    
    
}
-(void)setUI{
    [self.contentView addSubview:self.coinimg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.addreLab];
    [self.contentView addSubview:self.numLab];
    [self.contentView addSubview:self.adBtn];
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
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10)+_coinimg.right,gdValue(7), gdValue(200), gdValue(23))];
        _nameLab.text=@"--";
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
        _addreLab.textColor=zyincolor;
        _addreLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    }
    return _addreLab;
}

-(UILabel*)numLab{
    if(!_numLab){
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake(_addreLab.x, _addreLab.bottom, _addreLab.width, gdValue(17))];
        _numLab.font=fontNum(12);
        _numLab.textColor=ziColor;
        _numLab.text=[NSString stringWithFormat:getLocalStr(@"flsht1"),@"0.00"];
    }
    return _numLab;
}

-(UIImageView*)adBtn{
    if(!_adBtn){
        _adBtn=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-gdValue(40), gdValue(25), gdValue(20), gdValue(20))];
        _adBtn.image=imageName(@"addactN");
//        _adBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        _adBtn.frame=CGRectMake(self.width-gdValue(40), gdValue(20), gdValue(30), gdValue(30));
//        _adBtn.enabled=NO;
//        [_adBtn setImage:imageName(@"addactN") forState:UIControlStateNormal];
//        [_adBtn setImage:imageName(@"addactS") forState:UIControlStateSelected];
//        [_adBtn addTarget:self action:@selector(addCk:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _adBtn;
}

//-(void)addCk:(UIButton*)sender{
//
//
//
//
//    sender.selected=!sender.selected;
//
//
//
//
//    if(self.getBtnBlock){
//        self.getBtnBlock(sender.selected);
//    }
//
//
//
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
