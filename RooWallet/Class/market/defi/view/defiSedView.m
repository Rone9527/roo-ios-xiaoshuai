//
//  defiSedView.m
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import "defiSedView.h"

@interface defiSedView()
@property(nonatomic,strong)UILabel*pricLab;
@property(nonatomic,strong)UILabel*pricLab1;
@property(nonatomic,strong)UILabel*zfdLab;
@property(nonatomic,strong)UIView*col;


@end

@implementation defiSedView

- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)nameStr {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        [self setUI:nameStr];
        
    }
    
 
    return self;
}

-(void)setUI:(NSString*)namer{
    
    UILabel*nalab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), self.width-gdValue(30), gdValue(20))];
    nalab.text=namer;//;
    nalab.font=fontNum(14);
    nalab.textColor=zyincolor;
    [self addSubview:nalab];
    
    [self addSubview:self.pricLab];
    [self addSubview:self.pricLab1];
    
    [self addSubview:self.zfdLab];
    
    
    
}

#pragma mark 数据处理
-(void)getdatarr:(NSArray*)arr  fl:(NSString*)flstr{
    
    if([Utility isBlankString:flstr]){
        self.pricLab.text=arr[0];
    }
    else{
        self.pricLab.text=arr[0];
        self.pricLab1.hidden=NO;
        self.pricLab1.text=flstr;
//        NSString*srt=[NSString stringWithFormat:@"%@ \n %@",arr[0],flstr];
//        self.pricLab.attributedText=[Utility getText:srt colo:zyincolor font:fontNum(14) rangText:flstr];
    }
    
   
    
    
    NSString*zdStr=[NSString stringWithFormat:@"%.2f%%",[arr[1] floatValue]*100 ]; ;
    if([zdStr containsString:@"-"]){
        zdStr=[[zdStr componentsSeparatedByString:@"-"]lastObject];
        
        _zfdLab.text=[NSString stringWithFormat:@"-%@%%",[Utility douVale:zdStr num:2]];
        _zfdLab.textColor=UIColorFromRGB(0xFA4400);
    }
    
    else {
       
        _zfdLab.text=[NSString stringWithFormat:@"+%@%%",[Utility douVale:zdStr num:2] ];
        _zfdLab.textColor=UIColorFromRGB(0x00B464);
        
        if ([zdStr floatValue]==0.00){
            _zfdLab.text=@"0.00%";
             _zfdLab.textColor=UIColorFromRGB(0xC4C9D8);
         }
       
    }
    _zfdLab.adjustsFontSizeToFitWidth=YES;
    self.pricLab.adjustsFontSizeToFitWidth=YES;
}

-(UILabel*)zfdLab{
    if(!_zfdLab){
        _zfdLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(85), _pricLab.y, gdValue(70), gdValue(28))];
        _zfdLab.textColor=ziColor;
        _zfdLab.font=fontMidNum(16);
        _zfdLab.text=@"----";
        _zfdLab.textAlignment=NSTextAlignmentRight;
    }
    return _zfdLab;
}
-(UILabel*)pricLab{
    if(!_pricLab){
        _pricLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(45), gdValue(240), gdValue(28))];
        _pricLab.textColor=ziColor;
        _pricLab.font=fontMidNum(20);
        
        _pricLab.text=@"----";
    }
    return _pricLab;
}
-(UILabel*)pricLab1{
    if(!_pricLab1){
        _pricLab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), _pricLab.bottom, gdValue(240), gdValue(20))];
        _pricLab1.textColor=zyincolor;
        _pricLab1.font=fontNum(14);
        _pricLab1.hidden=YES;
        _pricLab1.text=@"----";
    }
    return _pricLab1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
