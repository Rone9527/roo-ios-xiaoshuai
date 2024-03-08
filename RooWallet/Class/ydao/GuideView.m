//
//  GuideView.m
//  Welcome
//
//  Created by iOSCoderZhao on 2017/9/11.
//  Copyright © 2017年 iOSCoderZhao. All rights reserved.
//

#import "GuideView.h"
//#import "UIImage+GIF.h"
//#import "UIImageView+SDCategory.h"
#import "BaseTabBarViewController.h"
#import "NewAdWaletViewController.h"
#define K_Screen_width [UIScreen mainScreen].bounds.size.width
#define K_Screen_height [UIScreen mainScreen].bounds.size.height


@interface GuideView ()<UIScrollViewDelegate>

/**
 滚动视图
 */
@property (nonatomic,strong)UIScrollView *imageScrollView;
/**
 圆点
 */
@property (nonatomic,strong) UIPageControl *pageControl;

/**
 跳过按钮
 */
@property (nonatomic,strong)UIButton *cancelButton;

/**
 跟控制器
 */

@property (nonatomic,strong) UIButton*qdBtn;
@end

@implementation GuideView


- (void)viewDidLoad {
    [super viewDidLoad];
   

    
  
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(SCREEN_WIDTH*2+gdValue(35),K_Screen_height- gdValue(90), SCREEN_WIDTH-gdValue(70), gdValue(50));
        if(IS_iPhoneX){
            _qdBtn.frame=CGRectMake(SCREEN_WIDTH*2+gdValue(35),K_Screen_height- gdValue(130), SCREEN_WIDTH-gdValue(70), gdValue(50));
        }
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=mainColor;
    
        [  _qdBtn setTitle:getLocalStr(@"adm11") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [  _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _qdBtn.hidden=YES;
        
        [  _qdBtn addTarget:self action:@selector(dfCk) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return   _qdBtn;
}
- (void)createScrollView
{
    _imageScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _imageScrollView.delegate = self;
    _imageScrollView.bounces = YES;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.backgroundColor = [UIColor whiteColor];
    _imageScrollView.contentSize = CGSizeMake(K_Screen_width *self.imageArray.count, K_Screen_height);
    [self.view addSubview:_imageScrollView];
    for (int i = 0; i < self.imageArray.count; i++) {
        NSString *imageName = self.imageArray[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor =[UIColor whiteColor];
        imageView.frame = CGRectMake(K_Screen_width * i, gdValue(27), K_Screen_width, gdValue(500));
        if(IS_iPhoneX){
            imageView.frame = CGRectMake(K_Screen_width * i, gdValue(110), K_Screen_width, gdValue(500));
        }
        
        [_imageScrollView addSubview:imageView];
        // 判断是否为gif
        if ( [imageName.pathExtension.lowercaseString isEqualToString:@"gif"]) {
            // sd_animatedGIFNamed 不能带.gif 后缀否则只能加载第一张
            // 过滤掉 .gif
//            NSString *tureName = [imageName substringToIndex:imageName.length - 4];
//            imageView.image = [UIImage sd_animatedGIFNamed:tureName];
        }else{
            imageView.image = [UIImage imageNamed:imageName];
//            [imageView sd_setFadeImageWithURL:Url_Str(self.imageArray[i]) placeholderImage:nil];
        }
        
        UILabel*labt=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(423), SCREEN_WIDTH, gdValue(38))];
        labt.text=_titArray[i];
        labt.font=fontBoldNum(27);
        labt.textAlignment=NSTextAlignmentCenter;
        labt.textColor=ziColor;
        [imageView addSubview:labt];
        
        UILabel*labt1=[[UILabel alloc]initWithFrame:CGRectMake(0,labt.bottom+gdValue(15), SCREEN_WIDTH, gdValue(23))];
        labt1.text=_subArray[i];
        labt1.font=fontNum(16);
        labt1.textAlignment=NSTextAlignmentCenter;
        labt1.textColor=ziColor;
        [imageView addSubview:labt1];
        
        
    }
}

- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, K_Screen_height - gdValue(80), K_Screen_width, 30)];
    if(IS_iPhoneX){
        _pageControl.frame=CGRectMake(0,K_Screen_height- gdValue(120), SCREEN_WIDTH, gdValue(30));
    }
    _pageControl.hidden = _pageControlShow;
    _pageControl.pageIndicatorTintColor = _pageIndicatorColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorColor;
    _pageControl.numberOfPages = self.imageArray.count;
    [self.view addSubview:_pageControl];
}
-(void)setPageIndicatorColor:(UIColor *)pageIndicatorColor{
    _pageIndicatorColor=pageIndicatorColor;
}
-(void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor{
    _currentPageIndicatorColor=currentPageIndicatorColor;
}
- (void)createCancelButton
{
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.layer.cornerRadius = 2;
    _cancelButton.hidden = _cancelButtonShow;
    _cancelButton.titleLabel.font = fontNum(14);
    _cancelButton.backgroundColor = cyColor;
    _cancelButton.frame = CGRectMake(K_Screen_width - 95, 50, 70,34);
    [_cancelButton setTitle:getLocalStr(@"跳过") forState:UIControlStateNormal];
    [_cancelButton setTitleColor:ziColor forState:UIControlStateNormal];
   
    ViewBorderRadius(_cancelButton, gdValue(17), 1, UIColorFromRGB(0xC4C9D8));
    
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
}



- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    if(_imageArray.count){
       
        [self createScrollView];
        [self createPageControl];
    
//         [self createCancelButton];
    }
}

- (void)setCancelButtonShow:(BOOL)cancelButtonShow
{
    _cancelButtonShow = cancelButtonShow;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // pageControl 与 scrollView 联动
    CGFloat offsetWidth = scrollView.contentOffset.x;
    int pageNum = offsetWidth / [[UIScreen mainScreen] bounds].size.width;
    self.pageControl.currentPage = pageNum;
    
    if(offsetWidth>SCREEN_WIDTH+SCREEN_WIDTH/2){
        self.pageControl.hidden=YES;
    }
    else{
        self.pageControl.hidden=NO;
    }
    
//    if (scrollView.contentOffset.x == scrollView.contentSize.width - K_Screen_width + 40) {
      
      
//             [self windroot];
//    }
    
}

-(void)dfCk{
    [self windroot];
}
- (void)showGuideViewWithImageArray:(NSArray *)imageArray titArr:(NSArray *)titArr subArr:(NSArray *)subArr
{
  
    _imageArray = imageArray;
    _titArray=titArr;
    _subArray=subArr;
    if(_imageArray.count){
//        NSLog(@"sd==%@",_imageArray);
        [self createScrollView];
        [self createPageControl];
        [self.imageScrollView addSubview:self.qdBtn];
        [self createCancelButton];

    }
}

- (void)cancelButtonAction:(UIButton *)sender
{
    [self windroot];
}
-(void)dealloc{
    NSLog(@"advvvv==hui");
}
-(void)windroot{
  
    NewAdWaletViewController*adVc=[[NewAdWaletViewController alloc]init];
    adVc.seleType=0;
    UINavigationController*nac=[[UINavigationController alloc]initWithRootViewController:adVc];
    self.view.window.rootViewController= nac;
    
    
  
}
@end
