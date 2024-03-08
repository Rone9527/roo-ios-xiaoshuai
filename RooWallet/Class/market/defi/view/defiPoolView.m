//
//  defiPoolView.m
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import "defiPoolView.h"
#import "defiSedView.h"
#import "defiDetModel.h"


@interface defiPoolView()
@property(nonatomic,strong)defiSedView*seview;
@property(nonatomic,strong)UIImageView*img1;
@property(nonatomic,strong)UIImageView*img2;
@property(nonatomic,strong)UILabel*nameLabe1;
@property(nonatomic,strong)UILabel*nameLabe2;
@end


@implementation defiPoolView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        [self setUI];
        
    }
    
 
    return self;
}

-(void)setUI{

    [self addSubview:self.seview];
    
    [self addSubview:self.img1];
    [self addSubview:self.img2];
    [self addSubview:self.nameLabe1];
    [self addSubview:self.nameLabe2];
    
    
}

#pragma mark 数据处理
-(void)getdata:(defiDetModel*)model{
    
    NSString*pr=[NSString stringWithFormat:@"$ %@",[Utility douVale:model.reserveUSD num:2]];
    
    NSString*zfd=model.rateOfReserveUSD;
    NSArray*art=@[pr,zfd];
    
    [_seview getdatarr:art fl:@""];
    
    [self.img1 sd_setImageWithURL:Url_Str(model.baseLogo) placeholderImage:imageName(@"mrtu")];
    [self.img2 sd_setImageWithURL:Url_Str(model.logo) placeholderImage:imageName(@"mrtu")];
    self.nameLabe1.text=[NSString stringWithFormat:@"%@ %@",[Utility douVale:model.token1Reserve num:2],model.token1Symbol];
    self.nameLabe2.text=[NSString stringWithFormat:@"%@ %@",[Utility douVale:model.token0Reserve num:2],model.token0Symbol];
}

-(UILabel*)nameLabe1{
    if(!_nameLabe1){
        _nameLabe1=[[UILabel alloc]initWithFrame:CGRectMake(_img1.right+gdValue(7), _img1.y-gdValue(2), gdValue(300), gdValue(24))];
        _nameLabe1.text=@"----";
        _nameLabe1.font=fontNum(16);
        _nameLabe1.textColor=ziColor;
    }
    return _nameLabe1;
}
-(UILabel*)nameLabe2{
    if(!_nameLabe2){
        _nameLabe2=[[UILabel alloc]initWithFrame:CGRectMake(_img2.right+gdValue(7), _img2.y-gdValue(2), gdValue(300), gdValue(24))];
        _nameLabe2.text=@"----";
        _nameLabe2.font=fontNum(16);
        _nameLabe2.textColor=ziColor;
    }
    return _nameLabe2;
}
-(UIImageView*)img1{
    if(!_img1){
        _img1=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), _seview.bottom+gdValue(18), gdValue(20), gdValue(20))];
        _img1.image=imageName(@"mrtu");
    }
    return _img1;
}
-(UIImageView*)img2{
    if(!_img2){
        _img2=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), _img1.bottom+gdValue(15), gdValue(20), gdValue(20))];
        _img2.image=imageName(@"mrtu");
    }
    return _img2;
}
-(defiSedView*)seview{
    if(!_seview){
        _seview=[[defiSedView alloc]initWithFrame:CGRectMake(0, 0, self.width, gdValue(88)) tit:getLocalStr(@"流动资金池")];
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), _seview.bottom, self.width-gdValue(30), 1)];
        col.backgroundColor=cyColor;
        [self addSubview:col];
        
    }
    return _seview;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
