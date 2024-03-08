//
//  tradDetTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "tradDetTableViewCell.h"
#import "tranDetModel.h"
#import  "Lottie.h"


@interface  tradDetTableViewCell()

@property(nonatomic,strong)UILabel*adrLab;
@property(nonatomic,strong)UILabel*timeLab;
@property(nonatomic,strong)UILabel*prLab;
@property(nonatomic,strong)LOTAnimationView *lottielogo;

@end

@implementation tradDetTableViewCell
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
    [self.contentView addSubview:self.adrLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.prLab];
    [self.ztimg addSubview:self.lottielogo];
    
}

-(void)setModel:(tranDetModel*)model{
    self.lottielogo.hidden=YES;
    if(model.staues==0){
        _ztimg.image=imageName(@"trddet_3");
        
    }
    else if (model.staues==1){
        if(model.type==1){//转账
            _ztimg.image=imageName(@"trddet_1");
            self.adrLab.text=model.toAddr;
            self.prLab.text=[NSString stringWithFormat:@"- %@",model.amount];
        }
        else{//收款
            _ztimg.image=imageName(@"trddet_2");
            self.adrLab.text=model.fromAddr;
            self.prLab.text=[NSString stringWithFormat:@"+ %@",model.amount];
        }
    }
    else{
        
        self.lottielogo.hidden=NO;
             [self.lottielogo play];
        
        
    }
    
    if(model.type==1){//转账
  
        self.adrLab.text=model.toAddr;
        self.prLab.text=[NSString stringWithFormat:@"- %@",model.amount];
    }
    else{//收款
      
        self.adrLab.text=model.fromAddr;
        self.prLab.text=[NSString stringWithFormat:@"+ %@",model.amount];
    }
    
    
    self.timeLab.text=[Utility upTimeHHmm:model.timeStamp];
    
    
    
    
}
-(LOTAnimationView*)lottielogo{
    if(!_lottielogo){
     _lottielogo = [LOTAnimationView animationNamed:@"dabao"];

        _lottielogo.frame=_ztimg.bounds;
        _lottielogo.loopAnimation=YES;
        _lottielogo.hidden=YES;
    _lottielogo.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _lottielogo;
}
-(LLGifImageView*)ztimg{
    if(!_ztimg){
        _ztimg=[[LLGifImageView alloc]initWithFrame:CGRectMake(gdValue(16), gdValue(20), gdValue(30), gdValue(30))];
        _ztimg.image=imageName(@"trddet_1");
//        _ztimg.backgroundColor=UIColorFromRGB(0x333333);
//        ViewRadius(_ztimg, gdValue(15));
    }
    
    return _ztimg;
}

-(UILabel*)adrLab{
    if(!_adrLab){
        _adrLab=[[UILabel alloc]initWithFrame:CGRectMake(_ztimg.right+gdValue(10), gdValue(17), gdValue(156), gdValue(20))];
//        _adrLab.text=@"asdadadadqdasdasasasasasascas";
        _adrLab.font=fontNum(14);
        _adrLab.textColor=ziColor;
        _adrLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _adrLab;
}
-(UILabel*)timeLab{
    if(!_timeLab){
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_ztimg.right+gdValue(10), _adrLab.bottom+1, gdValue(156), gdValue(15))];
//        _timeLab.text=@"09/04/2020 14:32:52";
        _timeLab.font=fontNum(11);
        _timeLab.textColor=zyincolor;
      
        
    }
    return _timeLab;
}

-(UILabel*)prLab{
    if(!_prLab){
        _prLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(155), gdValue(25), gdValue(140), gdValue(20))];
//        _prLab.text=@"-3.34534533";
        _prLab.font=fontNum(14);
        _prLab.textColor=ziColor;
        _prLab.textAlignment=NSTextAlignmentRight;
      
        
    }
    return _prLab;
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
