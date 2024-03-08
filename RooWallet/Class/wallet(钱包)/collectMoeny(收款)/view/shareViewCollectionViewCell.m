//
//  shareViewCollectionViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "shareViewCollectionViewCell.h"

@interface shareViewCollectionViewCell()

@end
@implementation shareViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=cyColor;
       
    }
    return self;
}
-(void)setUpUI{
    [self.contentView addSubview:self.img];
    [ self.contentView addSubview:self.titLab];
}
-(UIImageView*)img{
    if(!_img){
        _img=[[UIImageView alloc]initWithFrame:CGRectMake((self.width-gdValue(50))/2, 0, gdValue(50), gdValue(50))];
        
    }
    return _img;
}
-(UILabel*)titLab{
    if(!_titLab){
        _titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _img.bottom+gdValue(6), self.width, gdValue(15))];
        _titLab.textColor=UIColorFromRGB(0x333333);
        _titLab.font=fontNum(11);
        
        _titLab.textAlignment=NSTextAlignmentCenter;
        
    }
    return _titLab;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
    
}
@end
