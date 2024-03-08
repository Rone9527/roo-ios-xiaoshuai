//
//  tranCollectionViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "tranCollectionViewCell.h"
#import "TraGasmodel.h"


@interface tranCollectionViewCell()



@property(nonatomic,strong)UIImageView*img;
@end


@implementation tranCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=cyColor;
        ViewRadius(self, gdValue(10));
        
        [self setUI];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
   _img.frame=CGRectMake(self.width-gdValue(17), gdValue(5), gdValue(12), gdValue(12));
    _tsLab.frame=CGRectMake(0, gdValue(14), self.width, gdValue(20));
   _numLab.frame=CGRectMake(0, gdValue(5)+_tsLab.bottom, self.width, gdValue(21));
    _timeLab.frame=CGRectMake(0, gdValue(10)+_numLab.bottom, self.width, gdValue(15));
    
    
}
-(void)setIsSeled:(BOOL)isSeled{
    if(isSeled){
        ViewBorderRadius(self.contentView, gdValue(10), gdValue(1.5), mainColor);
        self.img.hidden=NO;
    }
    else{
        ViewBorderRadius(self.contentView, gdValue(10), gdValue(1.5), cyColor);
        self.img.hidden=YES;
    }
}
-(void)setUI{
    
    [self.contentView addSubview:self.tsLab];
    [self.contentView addSubview:self.numLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.img];
    
    
}


-(UIImageView*)img{
    if(!_img){
        _img=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-gdValue(17), gdValue(5), gdValue(12), gdValue(12))];
        _img.image=imageName(@"selemain");
        _img.hidden=YES;
    }
    return _img;
}
-(UILabel*)tsLab{
    if(!_tsLab){
        _tsLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(14), self.width, gdValue(20))];
        _tsLab.font=fontNum(15);
        _tsLab.textColor=ziColor;
        _tsLab.textAlignment=NSTextAlignmentCenter;
        
//        _tsLab.text=getLocalStr(@"trawrt6");
    }
    return _tsLab;
}

-(UILabel*)numLab{
    if(!_numLab){
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(5)+_tsLab.bottom, self.width, gdValue(21))];
        _numLab.font=fontMidNum(15);
        _numLab.textColor=ziColor;
        _numLab.textAlignment=NSTextAlignmentCenter;
        _numLab.adjustsFontSizeToFitWidth=YES;
//        _numLab.text=@"23.38Gwei";
    }
    return _numLab;
}

-(UILabel*)timeLab{
    if(!_timeLab){
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(10)+_numLab.bottom, self.width, gdValue(15))];
        _timeLab.font=fontNum(11);
        _timeLab.textColor=ziColor;
        _timeLab.textAlignment=NSTextAlignmentCenter;
//        _timeLab.text=@"0.2s";
    }
    return _timeLab;
}


@end
