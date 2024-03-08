//
//  coltCollectionViewCell.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "coltCollectionViewCell.h"
#import "dapptyModel.h"
@interface coltCollectionViewCell()
@property(nonatomic,strong)UIImageView*img;
@property(nonatomic,strong)UILabel*titLab;
@end

@implementation coltCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
       
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self.contentView addSubview:self.img];
    [ self.contentView addSubview:self.titLab];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _img.frame=CGRectMake((self.width-gdValue(36))/2, 0, gdValue(36), gdValue(36));
    _titLab.frame=CGRectMake(gdValue(5), _img.bottom+gdValue(6), self.width-gdValue(5), gdValue(15));
    
    
}
-(void)setModel:(dapptyModel *)model{
    
    self.titLab.text=model.name;

//    if([model.tyy isEqualToString:@"0"]){
      
//        [self.img sd_setImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
        [self.img sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
        
//    }
//    else{
////    [self.img sd_setImageWithURL:Url_Str(model.icon) placeholderImage:[Utility vireimg:[model.name substringToIndex:1] hig:gdValue(30)]];
//        [self.img sd_setFadeImageWithURL:Url_Str(model.icon) placeholderImage:imageName(@"mrtu")];
//    }
}

-(UIImageView*)img{
    if(!_img){
        _img=[[UIImageView alloc]initWithFrame:CGRectMake((self.width-gdValue(36))/2, 0, gdValue(36), gdValue(36))];
        
//        _img.contentMode=UIViewContentModeScaleAspectFill;
//        _img.clipsToBounds=YES;
//        ViewRadius(_img, gdValue(10));
        ViewBorderRadius(_img, gdValue(8), 0.5, [UIColor clearColor]);
        
    }
    return _img;
}

-(UILabel*)titLab{
    if(!_titLab){
        _titLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(5), _img.bottom+gdValue(6), self.width-gdValue(5), gdValue(15))];
        _titLab.textColor=UIColorFromRGB(0x333333);
        _titLab.font=fontNum(11);
        
        _titLab.textAlignment=NSTextAlignmentCenter;
        
    }
    return _titLab;
}

@end
