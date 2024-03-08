//
//  defiDetTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/8/7.
//

#import "defiDetTableViewCell.h"
#import "defiJYModel.h"
@interface  defiDetTableViewCell()
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,strong)UILabel*ztlab;
@property(nonatomic,strong)UILabel*timelab;
@property(nonatomic,strong)UILabel*numlab1;
@property(nonatomic,strong)UILabel*namelab1;
@property(nonatomic,strong)UILabel*numlab2;
@property(nonatomic,strong)UILabel*namelab2;
@property(nonatomic,strong)UIImageView*img;


@end

@implementation defiDetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=cyColor;
       [self loadUI];
        
        
    }
    return self;
}

-(void)loadUI{
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.ztlab];
    [self.bgView addSubview:self.timelab];
    [self.bgView addSubview:self.numlab1];
    [self.bgView addSubview:self.namelab1];
    [self.bgView addSubview:self.img];
    
    [self.bgView addSubview:self.numlab2];
    [self.bgView addSubview:self.namelab2];
}

-(void)setModel:(defiJYModel *)model{
    
    self.ztlab.text=[self getmtype:model.type];
    self.timelab.text=[Utility upTimeHHmm:model.timestamp geshi:@"MM/dd HH:mm"];
    
    
    
    self.numlab1.text= [Utility changeAsset:[Utility getnumstr:model.token1Amount]]    ;
    self.namelab1.text=model.token1Symbol;
    
//    NSLog(@"s--%@   d--%@",model.token0Amount,[Utility getnumstr:model.token0Amount]);
    self.numlab2.text=[Utility changeAsset:[Utility getnumstr:model.token0Amount]]   ;
    self.namelab2.text=model.token0Symbol;
    
    self.namelab1.adjustsFontSizeToFitWidth=YES;
    self.namelab2.adjustsFontSizeToFitWidth=YES;
    self.numlab1.adjustsFontSizeToFitWidth=YES;
    self.numlab2.adjustsFontSizeToFitWidth=YES;
}

-(NSString*)getmtype:(NSString*)type{//buy(买入)、sell(卖出)、mint(增加流动性)、burn(减少流动性
    NSString*str=@"--";
    if([type isEqualToString:@"buy"]){
        
        str=getLocalStr(@"买入");
        self.img.image=imageName(@"defjy_4");
        self.ztlab.textColor=UIColorFromRGB(0x00B464);
    }
    else if([type isEqualToString:@"sell"]){
        str=getLocalStr(@"卖出");
        self.img.image=imageName(@"defjy_1");
        self.ztlab.textColor=UIColorFromRGB(0xFA4400);
    }
    else if([type isEqualToString:@"mint"]){
        str=getLocalStr(@"增加流动性");
        self.img.image=imageName(@"defjy_2");
        self.ztlab.textColor=UIColorFromRGB(0x00B464);
    }
    else if([type isEqualToString:@"burn"]){
        str=getLocalStr(@"减少流动性");
        self.img.image=imageName(@"defjy_3");
        self.ztlab.textColor=UIColorFromRGB(0xFA4400);
    }
    
    return str;
    
}

-(UIView*)bgView{
    if(!_bgView){
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), 0, SCREEN_WIDTH-gdValue(30), gdValue(60))];
        _bgView.backgroundColor=[UIColor whiteColor];
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(60)-1, _bgView.width-gdValue(30), 1)];
        col.backgroundColor=cyColor;
        [_bgView addSubview:col];
        
    }
    return _bgView;
}
-(UILabel*)ztlab{
    if(!_ztlab){
        _ztlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), gdValue(10), gdValue(80), gdValue(20))];
        _ztlab.text=@"";
        _ztlab.font=fontMidNum(15);
        
    }
    return _ztlab;
}
-(UILabel*)timelab{
    if(!_timelab){
        _timelab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), _ztlab.bottom+gdValue(2), gdValue(90), gdValue(20))];
        _timelab.text=@"";
        _timelab.font=fontNum(14);
        _timelab.textColor=zyincolor;
    }
    return _timelab;
}
-(UILabel*)numlab1{
    if(!_numlab1){
        _numlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(25)+_ztlab.right, gdValue(10), gdValue(80), gdValue(20))];
        _numlab1.text=@"";
        _numlab1.font=fontBoldNum(15);
        
    }
    return _numlab1;
}
-(UILabel*)namelab1{
    if(!_namelab1){
        _namelab1=[[UILabel alloc]initWithFrame:CGRectMake(_numlab1.x, _numlab1.bottom+gdValue(2), gdValue(80), gdValue(20))];
        _namelab1.text=@"";
        _namelab1.font=fontNum(14);
        _namelab1.textColor=ziColor;
        
    }
    return _namelab1;
}

-(UIImageView*)img{
    if(!_img){
        _img=[[UIImageView alloc]initWithFrame:CGRectMake(_numlab1.right+gdValue(7), gdValue(45)/2, gdValue(15), gdValue(15))];
        
    }
    return _img;
}

-(UILabel*)numlab2{
    if(!_numlab2){
        _numlab2=[[UILabel alloc]initWithFrame:CGRectMake(_bgView.width-gdValue(105), gdValue(10), gdValue(90), gdValue(20))];
        _numlab2.text=@"";
        _numlab2.font=fontBoldNum(15);
        _numlab2.textAlignment=NSTextAlignmentRight;
    }
    return _numlab2;
}
-(UILabel*)namelab2{
    if(!_namelab2){
        _namelab2=[[UILabel alloc]initWithFrame:CGRectMake(_numlab2.x, _numlab2.bottom, gdValue(90), gdValue(20))];
        _namelab2.text=@"";
        _namelab2.font=fontNum(14);
        _namelab2.textColor=ziColor;
        _namelab2.textAlignment=NSTextAlignmentRight;
    }
    return _namelab2;
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
