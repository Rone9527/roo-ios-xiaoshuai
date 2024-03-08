//
//  defiDetView.m
//  RooWallet
//
//  Created by mac on 2021/8/7.
//

#import "defiXQView.h"
#import "defiDetModel.h"
#import "defitshiView.h"

@interface defiXQView()

@property(nonatomic,copy)NSString*nastr;

@property(nonatomic,strong)UIButton*nameBtn;
@property(nonatomic,strong)UILabel*conLab;
@property(nonatomic,strong)UILabel*priceLab;
@property(nonatomic,strong)UILabel*timeLab;
@property(nonatomic,strong)UIView*col;

@property(nonatomic,strong)UILabel*ptLab;
@property(nonatomic,strong)UILabel*addnuLab;
@property(nonatomic,strong)UILabel*tradnuLab;

@end

@implementation defiXQView


- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)nameStr {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
       
        _nastr=[[nameStr componentsSeparatedByString:@"-"]lastObject];
        [self setUI];
        
    }
    
 
    return self;
}

-(void)setUI{
    
    [self addSubview:self.nameBtn];
    [self addSubview:self.priceLab];
    [self addSubview:self.timeLab];
    [self addSubview:self.col];
    
    
    
}

#pragma mark 数据处理
-(void)getdata:(defiDetModel*)model{
    self.conLab.text=model.token0Id;
    
    self.priceLab.text=[NSString stringWithFormat:@"1:%@",[Utility getnumstr:model.dinitPrice] ];
    self.timeLab.text=[Utility upTimeHHmm:model.createTimestamp geshi:@"yyyy/MM/dd HH:mm:ss"];
    self.ptLab.text=model.ascription;
    if(![Utility isBlankString:model.holders]){
        self.addnuLab.text=model.holders;
    }
   
    self.tradnuLab.text=model.txCount;
    
    
}
-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), _nameBtn.bottom+gdValue(112), self.width-gdValue(30), 1)];
        _col.backgroundColor=cyColor;
        
        NSArray*art=@[getLocalStr(@"Dex平台"),getLocalStr(@"持币地址数"),getLocalStr(@"转账次数")];
        for(int i=0;i<art.count;i++){
            UILabel*tlab=[[UILabel alloc]init];
            if(i==0){
                tlab.frame=CGRectMake(gdValue(15), _col.bottom+gdValue(13), gdValue(70), gdValue(20));
                _ptLab=[[UILabel alloc]initWithFrame:CGRectMake(tlab.x, tlab.bottom+gdValue(10),gdValue(100), gdValue(20))];
                _ptLab.text=@"---";
                _ptLab.font=fontMidNum(16);
                _ptLab.textColor=ziColor;
                [self addSubview:_ptLab];
                
            }
           else if(i==1){
                tlab.frame=CGRectMake((self.width-gdValue(80))/2, _col.bottom+gdValue(13), gdValue(80), gdValue(20));
               tlab.textAlignment=NSTextAlignmentCenter;
               
               _addnuLab=[[UILabel alloc]initWithFrame:CGRectMake((self.width-gdValue(80))/2, tlab.bottom+gdValue(10),gdValue(80), gdValue(20))];
               _addnuLab.text=@"---";
               _addnuLab.font=fontMidNum(16);
               _addnuLab.textColor=ziColor;
               [self addSubview:_addnuLab];
               _addnuLab.textAlignment=NSTextAlignmentCenter;
               
            }
            else if (i==2){
                tlab.frame=CGRectMake(self.width-gdValue(85), _col.bottom+gdValue(13), gdValue(70), gdValue(20));
                tlab.textAlignment=NSTextAlignmentRight;
                
                _tradnuLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(115), tlab.bottom+gdValue(10),gdValue(100), gdValue(20))];
                _tradnuLab.text=@"---";
                _tradnuLab.font=fontMidNum(16);
                _tradnuLab.textColor=ziColor;
                [self addSubview:_tradnuLab];
                _tradnuLab.textAlignment=NSTextAlignmentRight;
            }
            tlab.text=art[i];
            tlab.font=fontNum(14);
            tlab.textColor=zyincolor;
            [self addSubview:tlab];
            
        }
        
    }
    return _col;
}

-(UIButton*)nameBtn{
    if(!_nameBtn){
        _nameBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat wid=[Utility withForString:_nastr fontSize:20 andhig:gdValue(30)]+gdValue(15);
        
        _nameBtn.frame=CGRectMake(gdValue(13), gdValue(15), wid+gdValue(25), gdValue(30));
        [_nameBtn setTitle:_nastr forState:UIControlStateNormal];
        [_nameBtn setTitleColor:ziColor forState:UIControlStateNormal];
        _nameBtn.titleLabel.font=fontBoldNum(20);
        [_nameBtn addTarget:self action:@selector(tchuang) forControlEvents:UIControlEventTouchUpInside];
        [_nameBtn setImage:imageName(@"defitshi") forState:UIControlStateNormal];
        [_nameBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(8)];
        
        NSArray*art=@[getLocalStr(@"合约地址"),getLocalStr(@"上线价格"),getLocalStr(@"上线时间")];
        
        for(int i=0; i<art.count;i++){
            UILabel*nlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), _nameBtn.bottom+gdValue(13)+i*gdValue(32), gdValue(60 ),gdValue(20) )];
            nlab.text=art[i];
            nlab.font=fontNum(14);
            nlab.textColor=zyincolor;
            [self addSubview:nlab];
            
            if(i==0){
                UIButton*btn =[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(self.width-gdValue(175), nlab.y-gdValue(2), gdValue(160), gdValue(24));
                
                [self addSubview:btn];
                [btn addTarget:self  action:@selector(fzconidk) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(144),gdValue(4), gdValue(16), gdValue(16))];
                img.image=imageName(@"defifz");
                [btn addSubview:img];
                [btn addSubview:self.conLab];
                
            }
            
            
        }
        
    }
    return _nameBtn;
}


-(void)tchuang{
    defitshiView*view=[[defitshiView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"交易风险提示") nr:getLocalStr(@"任何人都可以在以太坊上创建任意名字的代币，任何人也同样可以在去中心化交易所上架任意代币对，所以去中心化交易所充斥了大量同名假币以及无法卖出的诈骗代币，请一定做好研究与官方确认好合约地址再进行兑换操作。")];
    
    [view show];
}
-(void)fzconidk{
    
    
    if(![Utility isBlankString:_conLab.text]){
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = _conLab.text;
       if (pab == nil) {
         
       } else {
           [MBProgressHUD showText:getLocalStr(@"复制成功")];
       }
        
    }
    
}
-(UILabel*)conLab{
    if(!_conLab){
        _conLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(2),gdValue(134), gdValue(20))];
        _conLab.text=@"----";
        _conLab.font=fontNum(14);
        _conLab.textColor=ziColor;
        _conLab.textAlignment=NSTextAlignmentRight;
        _conLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
    }
    return _conLab;
}
-(UILabel*)priceLab{
    if(!_priceLab){
        _priceLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(175), _nameBtn.bottom+gdValue(45),gdValue(160), gdValue(20))];
        _priceLab.text=@"---";
        _priceLab.font=fontNum(14);
        _priceLab.textColor=ziColor;
        _priceLab.textAlignment=NSTextAlignmentRight;
      
    }
    return _priceLab;
}
-(UILabel*)timeLab{
        if(!_timeLab){
            _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(self.width-gdValue(175), _priceLab.bottom+gdValue(12),gdValue(160), gdValue(20))];
            _timeLab.text=@"---";
            _timeLab.font=fontNum(14);
            _timeLab.textColor=ziColor;
            _timeLab.textAlignment=NSTextAlignmentRight;
          
        }
        return _timeLab;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
