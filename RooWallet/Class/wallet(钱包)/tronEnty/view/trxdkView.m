//
//  trxdkView.m
//  RooWallet
//
//  Created by mac on 2021/9/3.
//

#import "trxdkView.h"
#import "SYLineProgressView.h"

@interface trxdkView ()
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)UILabel*everLab;
@property (nonatomic, strong) SYLineProgressView *lineProgress;

@property(nonatomic,strong)UILabel*djieLab;

@property(nonatomic,strong)UILabel*meLab;
@property(nonatomic,strong)UILabel*toLab;
@property(nonatomic,copy)NSString*dweiStr;


@end

@implementation trxdkView
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        self.backgroundColor=[UIColor whiteColor];
        _type=type;
      
        [self setUI];
        
    }
 
    return self;
}
-(void)setUI{
    
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(100), gdValue(23))];
    lab.textColor=ziColor;
    lab.font=fontMidNum(16);
    lab.text=getLocalStr(@"带宽");
    _dweiStr=@"KB";
    if(_type==1){
        lab.text=getLocalStr(@"能量");
        _dweiStr=@"μs";
        
    }
    
    [self addSubview:lab];
    
    [self addSubview:self.everLab];
    
    [self addSubview:self.lineProgress];
    [self.lineProgress initializeProgress];

    
    
    UILabel*labb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10)+_lineProgress.bottom, gdValue(100), gdValue(20))];
    labb.textColor=ziColor;
    labb.font=fontNum(12);
    labb.text=getLocalStr(@"冻结");
    [self addSubview:labb];
    [self addSubview:self.djieLab];
    [self addSubview:self.meLab];
    [self addSubview:self.toLab];
    
    
    
    
}

-(void)setModel:(trxModel *)model{
    
   
   
    if(_type==1){//能量
        
        
       if([model.ENfrozen_balance doubleValue]>0){
            _meLab.text=[NSString stringWithFormat:@"%@: %@ TRX(%@)",getLocalStr(@"自己"),model.ENfrozen_balance,model.isENEnd];
        }
        else{
            _meLab.text=[NSString stringWithFormat:@"%@: %@ TRX",getLocalStr(@"自己"),model.ENfrozen_balance];
        }
        _toLab.text=[NSString stringWithFormat:@"%@: %@ TRX",getLocalStr(@"他人"),model.ENAcqfrozen_balance];
//        _djieLab.text
       NSString*srt =[NSString stringWithFormat:@"%f",[model.ENfrozen_balance doubleValue]+[model.ENAcqfrozen_balance doubleValue]] ;
        
        _djieLab.text=[NSString stringWithFormat:@"%@ TRX",[Utility removeFloatAllZero:srt]];
        
        
        _everLab.text=[NSString stringWithFormat:@"%@ %@/TRX",model.Enfre,_dweiStr];
        
        _lineProgress.label.text=[NSString stringWithFormat:@"%@：%@ μs/%@ μs",getLocalStr(@"trawrt5"),model.Enky,model.Enall];
        
//        NSLog(@"sd--%f",[model.Enky floatValue] /[ model.Enall  floatValue]);
        if([Utility isBlankString:model.Enall]||[ model.Enall  floatValue]==0){
            self.lineProgress.progress=0;
        }
        else{
          
        self.lineProgress.progress = [model.Enky floatValue] /[ model.Enall  floatValue];
        }
        
//        _zbLab.text=[NSString stringWithFormat:@"%@：%@ μs/%@ μs",getLocalStr(@"trawrt5"),model.Enky,model.Enall];
    }
    
    else{//带宽
        
        if([model.KDfrozen_balance doubleValue]>0){
            _meLab.text=[NSString stringWithFormat:@"%@: %@ TRX(%@)",getLocalStr(@"自己"),model.KDfrozen_balance,model.isKDEnd];
        }
        else{
            _meLab.text=[NSString stringWithFormat:@"%@: %@ TRX",getLocalStr(@"自己"),model.KDfrozen_balance];
        }
        
        _toLab.text=[NSString stringWithFormat:@"%@: %@ TRX",getLocalStr(@"他人"),model.KDAcqfrozen_balance];
        NSString*srt =[NSString stringWithFormat:@"%f",[model.KDfrozen_balance doubleValue]+[model.KDAcqfrozen_balance doubleValue]] ;
         
         _djieLab.text=[NSString stringWithFormat:@"%@ TRX",[Utility removeFloatAllZero:srt]];
        _everLab.text=[NSString stringWithFormat:@"%@ %@/TRX",model.DKfre,_dweiStr];
        _lineProgress.label.text=[NSString stringWithFormat:@"%@：%@ KB/%@ KB",getLocalStr(@"trawrt5"),model.DKky,model.DKall];
//        NSLog(@"sd1--%f",[model.DKky floatValue] /[ model.DKall  floatValue]);
        
        if([Utility isBlankString:model.DKall]||[ model.DKall  floatValue]==0){
            self.lineProgress.progress=0;
        }
        else{
        self.lineProgress.progress = [model.DKky floatValue] /[ model.DKall  floatValue];
        }
//        _zbLab.text=[NSString stringWithFormat:@"%@：%@ KB/%@ KB",getLocalStr(@"trawrt5"),model.DKky,model.DKall];
        
    }
   
}

-(UILabel*)djieLab{
    if(!_djieLab){
        _djieLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), _everLab.bottom+gdValue(57), gdValue(150),    gdValue(20))];
        
        _djieLab.text=@"~ TRX";
        _djieLab.font=fontMidNum(14);
        _djieLab.textColor=ziColor;
    }
    
    return _djieLab;
}

-(SYLineProgressView*)lineProgress{
    if(!_lineProgress){
        _lineProgress=[[SYLineProgressView alloc]initWithFrame:CGRectMake(gdValue(15),_everLab.bottom+gdValue(10), self.width-gdValue(30), gdValue(16))];
        ViewRadius( _lineProgress, gdValue(8));
       _lineProgress.progressColor =mainColor;
       _lineProgress.defaultColor = UIColorFromRGB(0xB5C6F9);
      _lineProgress.label.textColor = [UIColor whiteColor];
       _lineProgress.label.hidden = NO;
        _lineProgress.isAnimation=YES;
        _lineProgress.label.text=[NSString stringWithFormat:@"~ %@/~ %@",_dweiStr,_dweiStr];
        _lineProgress.label.font=fontNum(11);
       _lineProgress.animationText = YES;
    }
    
    return _lineProgress;
}

-(UILabel*)meLab{
    if(!_meLab){
        _meLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(215), _everLab.bottom+gdValue(35), gdValue(200), gdValue(20))];
        _meLab.text=[NSString stringWithFormat:@"%@: ~ TRX",getLocalStr(@"自己")];
        _meLab.textColor=zyincolor;
        _meLab.font=fontNum(12);
        _meLab.textAlignment=NSTextAlignmentRight;
        
    }
    
    return _meLab;
}
-(UILabel*)toLab{
    if(!_toLab){
        _toLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(165), _meLab.bottom+gdValue(2), gdValue(150), gdValue(20))];
        _toLab.text=[NSString stringWithFormat:@"%@: ~ TRX",getLocalStr(@"他人")];
        _toLab.textColor=zyincolor;
        _toLab.font=fontNum(12);
        _toLab.textAlignment=NSTextAlignmentRight;
        
    }
    
    return _toLab;
}
-(UILabel*)everLab{
    if(!_everLab){
        _everLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(215), gdValue(15), gdValue(200), gdValue(23))];
        _everLab.textColor=zyincolor;
        _everLab.font=fontNum(14);
        _everLab.text=[NSString stringWithFormat:@"~ %@/TRX",_dweiStr];
        _everLab.textAlignment=NSTextAlignmentRight;
    }
    return _everLab;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
