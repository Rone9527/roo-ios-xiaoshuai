//
//  defiMarkView.m
//  RooWallet
//
//  Created by mac on 2021/8/3.
//

#import "defiMarkView.h"

#import "JXCategoryView.h"
#import "defiDetView.h"

@interface defiMarkView()<JXCategoryViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView*scroView;
@property(nonatomic,strong)JXCategoryTitleView*jxgtiView;
@property(nonatomic,strong)NSMutableArray*varr;
@end

@implementation defiMarkView

-(NSMutableArray*)varr{
    if(!_varr){
        _varr=[NSMutableArray array];
    }
    return _varr;
}
- (instancetype)initWithFrame:(CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=cyColor;
        [self setUI];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatermb) name:usdcnyname object:nil];
    }
    
 
    return self;
}


-(void)setUI{
  
    [self addSubview:self.jxgtiView];
    
  [self addSubview:self.scroView];
    [self actsetui];
//
    
}
-(void)actsetui{
    
    [self.varr removeAllObjects];
    for(int i=0;i<5;i++){
     
            defiDetView*view=[[defiDetView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _scroView.height) type:i];
        
            [_scroView addSubview:view];
     
        [self.varr addObject:view];
        
    
}

}

-(void)updatermb{
    
    for(defiDetView *view in self.varr){
        [view updatermb];
        
    }
}
-(void)qiuData{
    
    if(self.varr.count){
    defiDetView*view=self.varr[1];
    [view qiuData];
        
    }
  
}
-(JXCategoryTitleView*)jxgtiView{
    if(!_jxgtiView){
        _jxgtiView=[[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(45))];
        _jxgtiView.delegate = self;
        _jxgtiView.defaultSelectedIndex=1;
        _jxgtiView.titles = @[getLocalStr(@"自选"), getLocalStr(@"热门"),getLocalStr(@"资金榜"),getLocalStr(@"涨幅榜"),getLocalStr(@"新上线")];
        _jxgtiView.contentEdgeInsetLeft=gdValue(15);
        _jxgtiView.contentEdgeInsetRight=gdValue(15);
        _jxgtiView.titleColorGradientEnabled = YES;
        _jxgtiView.titleColor=zyincolor;
        _jxgtiView.titleSelectedColor=ziColor;
//        _jxgtiView.titleLabelVerticalOffset=10;
//        _categoryView.cellSpacing=gdValue(10);
        _jxgtiView.titleFont=fontBoldNum(14);
        _jxgtiView.titleSelectedFont=fontBoldNum(14);
       

        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = ziColor;
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
//        lineView.indicatorWidthIncrement=gdValue(30);
        _jxgtiView.indicators = @[lineView];
    }
    return _jxgtiView;
}

-(UIScrollView*)scroView{
    if(!_scroView){
        _scroView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,_jxgtiView.bottom, SCREEN_WIDTH,self.height-_jxgtiView.bottom)];
        _scroView.contentSize=CGSizeMake(SCREEN_WIDTH*5, 0);
        _scroView.pagingEnabled=YES;
        [_scroView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
//        _scroView.scrollEnabled=NO;
        _scroView.showsHorizontalScrollIndicator=NO;
        _scroView.delegate=self;
        _scroView.bounces=NO;
        _scroView.backgroundColor=[UIColor whiteColor];
     
    }
    return _scroView;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView==self.scroView){
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;

        [self.jxgtiView selectItemAtIndex:page];

    }
}

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
 
//    if(index==0){
//        
    defiDetView*view=self.varr[index];
    [view qiuData];
    
//        
//    }
    
    [self.scroView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
