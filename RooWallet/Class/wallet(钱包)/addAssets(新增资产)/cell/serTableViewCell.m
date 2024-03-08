//
//  serTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "serTableViewCell.h"
#import "blockModel.h"
@interface serTableViewCell()
@property(nonatomic,strong)UIImageView*coinimg;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*addreLab;

@property(nonatomic,strong)UIView*col;

@end

@implementation serTableViewCell
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
    _col.frame=CGRectMake(0, self.height-1, self.width, 1);
  
}
-(void)setModel:(btokensModel *)model{
//    self.coinimg.image=;
    _model=model;
//    [self.coinimg sd_setImageWithURL:Url_Str(model.icon) placeholderImage:[Utility vireimg:[model.symbol substringToIndex:1] hig:gdValue(30)]];
    
    [self.coinimg sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
  
    self.addreLab.text=model.contractId;
    NSString*namer;
    NSString*namerr;
    namer=model.symbol;
    
//    if(![model.chainCode isEqualToString:model.symbol]){
//        namerr=[NSString stringWithFormat:@"(%@ Token)",model.chainCode];
//     namer=[NSString stringWithFormat:@"%@ %@",model.symbol,namerr];
//    }
    
    
    if(![model.isCode isEqualToString:@"1"]){
        namerr=[NSString stringWithFormat:@"(%@ Token)",model.chainCodenameEn];
     namer=[NSString stringWithFormat:@"%@ %@",model.symbol,namerr];
        self.addreLab.text=model.contractId;
    }
    else{
        self.addreLab.text=model.name;
    }
    
    
    self.nameLab.attributedText=[Utility getText:namer colo:zyincolor font:fontNum(14) rangText:namerr];
    
    
    if(model.isSeled){
        _adBtn.image=imageName(@"addactS");
     
    }
    else{
        _adBtn.image=imageName(@"addactN");
       
    }
    

}
-(void)setUI{
    [self.contentView addSubview:self.coinimg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.addreLab];
    [self.contentView addSubview:self.adBtn];
    [self.contentView addSubview:self.col];
    
}

-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}
-(UIImageView*)coinimg{
    if(!_coinimg){
        _coinimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(17), gdValue(20), gdValue(30), gdValue(30))];
//        ViewRadius(_coinimg, gdValue(15));
        ViewBorderRadius(_coinimg, gdValue(15), 1, cyColor);
    }
    return _coinimg;
}

-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10)+_coinimg.right,gdValue(15), gdValue(200), gdValue(23))];
//        _nameLab.text=@"BTC";
        _nameLab.font=fontBoldNum(16);
        _nameLab.textColor=ziColor;
//        _nameLab.attributedText=[Utility getText:@"BTC(BTC Token)" colo:zyincolor font:fontNum(14) rangText:@"(BTC Token)"];
    }
    return _nameLab;
}

-(UILabel*)addreLab{
    if(!_addreLab){
        _addreLab=[[UILabel alloc]initWithFrame:CGRectMake(_nameLab.x,gdValue(2)+_nameLab.bottom, gdValue(240), gdValue(17))];
//        _addreLab.text=@"YRISTDFJFD77FGAGFKFGerwfsdfsfasfcasdfasd";
        _addreLab.font=fontNum(12);
        _addreLab.textColor=zyincolor;
        _addreLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    }
    return _addreLab;
}

-(UIImageView*)adBtn{
    if(!_adBtn){
        _adBtn=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-gdValue(40), gdValue(25), gdValue(20), gdValue(20))];
        _adBtn.image=imageName(@"addactN");
        
    }
    return _adBtn;
}

//-(void)addCk:(UIButton*)sender{
//
//    if([_model.isCode intValue]!=1){
//    sender.selected=!sender.selected;
//
//    if(sender.selected){
//    self.contentView.backgroundColor=cyColor;
//    }
//    else{
//        self.contentView.backgroundColor=[UIColor whiteColor];
//    }
//
//
//    if(self.getBtnBlock){
//        self.getBtnBlock(sender.selected);
//    }
//
//    }
//    else{
//        if(!_model.isSeled){
//            sender.selected=YES;
//            if(self.getBtnBlock){
//                self.getBtnBlock(YES);
//            }
//        }
//        else{
//            if(self.getBtnBlock){
//                self.getBtnBlock(NO);
//            }
//        }
//
//    }
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
