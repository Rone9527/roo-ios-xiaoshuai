//
//  mnenCollectionViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "mnenCollectionViewCell.h"
@interface mnenCollectionViewCell()

@end

@implementation mnenCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
       
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    [self.contentView addSubview:self.nrLab];
    [self.contentView addSubview:self.numLab];
    
}

-(UILabel*)nrLab{
    if(!_nrLab){
        _nrLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(12), self.width, gdValue(23))];
//        _nrLab.text=@"BTCF";
        _nrLab.font=fontBoldNum(16);
        _nrLab.textColor=ziColor;
        _nrLab.textAlignment=NSTextAlignmentCenter;
    }
    
    return _nrLab;
}

-(UILabel*)numLab{
    if(!_numLab){
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _nrLab.bottom, self.width, gdValue(15))];
   
        _numLab.font=fontNum(13);
        _numLab.textColor=UIColorFromRGB(0x999999);
        _numLab.textAlignment=NSTextAlignmentCenter;
    }
    return _numLab;
}

@end
