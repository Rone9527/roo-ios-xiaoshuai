//
//  noDataView.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "noDataView.h"
@interface noDataView()
@property(nonatomic,strong)UIImageView*noImg;
@property(nonatomic,strong)UILabel*nolab;

@end

@implementation noDataView
- (instancetype)initWithFrame:(CGRect)frame  imgstr:(NSString*)imganme tis:(NSString*)tishi{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        [self setUI];
        
        self.noImg.image=imageName(imganme);
        self.nolab.text=tishi;
        
    }
 
    return self;
}
-(void)setUI{
    [self addSubview:self.noImg];
    [self addSubview:self.nolab];
    
    
}
-(UIImageView*)noImg{
    if(!_noImg){
        _noImg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(210))/2, (self.height-gdValue(225))/2, gdValue(210), gdValue(180))];
        
    }
    return _noImg;
}
-(UILabel*)nolab{
    if(!_nolab){
        _nolab=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(300))/2, _noImg.bottom, gdValue(300), gdValue(45))];
//        _nolab.text=getLocalStr(@"anodata");
        _nolab.font=fontNum(16);
        _nolab.textColor=UIColorFromRGB(0xA8B0BC);
        _nolab.numberOfLines=2;
        _nolab.textAlignment=NSTextAlignmentCenter;
        
    }
    return _nolab;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
