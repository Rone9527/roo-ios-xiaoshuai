//
//  tabFootView.m
//  RooWallet
//
//  Created by mac on 2021/8/6.
//

#import "tabFootView.h"

@interface tabFootView ()

@end

@implementation tabFootView

- (instancetype)initWithFrame:(CGRect)frame   titStr:(NSString*)str{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        CGFloat xy=(SCREEN_WIDTH-gdValue(224))/2;
        
        UIView*rcol=[[UIView alloc]initWithFrame:CGRectMake(xy, (self.height-1)/2, gdValue(54), 1)];
        rcol.backgroundColor=UIColorFromRGB(0xC4C9D8);
        [self addSubview:rcol];
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(rcol.right+gdValue(8), (self.height-gdValue(20))/2, gdValue(100), gdValue(20))];
        tlab.text=getLocalStr(str);
        tlab.font=fontNum(14);
        tlab.textColor=UIColorFromRGB(0xC4C9D8);
        tlab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:tlab];
        
        UIView*lcol=[[UIView alloc]initWithFrame:CGRectMake(tlab.right+gdValue(8), rcol.y, gdValue(54), 1)];
        lcol.backgroundColor=UIColorFromRGB(0xC4C9D8);
        [self addSubview:lcol];
        
    }
    
    return self;
}


//-(UILabel*)tlab{
//    if(!_tlab){
//        _tlab=[UILabel alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
