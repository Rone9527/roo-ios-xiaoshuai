//
//  defiKLineView.m
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import "defiKLineView.h"
#import "jysMarkView.h"
@interface defiKLineView()
@property(nonatomic,strong)jysMarkView*markView;
@property(nonatomic,copy)NSString*asctr;
@property(nonatomic,copy)NSString*conidstr;

@end

@implementation defiKLineView


- (instancetype)initWithFrame:(CGRect)frame defi:(NSString*)ascription conid:(NSString*)conid {
    self = [super initWithFrame:frame];
    if (self) {
        _asctr=ascription;
        _conidstr=conid;
        
        self.backgroundColor=[UIColor whiteColor];
        [self setUI];
        
    }
    
 
    return self;
}
-(void)setUI{
    
    UILabel*nalab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(200), gdValue(20))];
    nalab.text=getLocalStr(@"价格走势图");//;
    nalab.font=fontNum(14);
    nalab.textColor=zyincolor;
    [self addSubview:nalab];
    
    [self addSubview:self.markView];
    
    
}

-(jysMarkView*)markView{
    if(!_markView){
        _markView=[[jysMarkView alloc]initWithFrame:CGRectMake(0, gdValue(35),self.width, gdValue(187)) defi:_asctr conid:_conidstr];
        _markView.backgroundColor=[UIColor whiteColor];
    }
    return _markView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
