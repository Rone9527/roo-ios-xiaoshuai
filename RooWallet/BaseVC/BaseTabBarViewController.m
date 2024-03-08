//
//  BaseTabBarViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "BaseTabBarViewController.h"
#import "WalletViewController.h"
#import "MarketViewController.h"
#import "DappViewController.h"
#import "MyViewController.h"
#import "HBDNavigationController.h"
#import  "Lottie.h"
#import "markettViewController.h"

@interface BaseTabBarViewController ()<UITabBarControllerDelegate>
/// 关联到 controller 原因：解决快速点击两个不一样的 tabbar 后，需要关闭第一次点击的动画
@property(nonatomic, strong) LOTAnimationView *animationView;
@end

@implementation BaseTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.tabBar setTranslucent:NO];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [self LoadabbarUI];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
        appearance.backgroundImage = [self imageWithColor:UIColorFromRGB(0xFfffff)];
        appearance.shadowColor = UIColorFromRGB(0xF0ECE8);
        self.tabBar.standardAppearance = appearance;
    } else {
        self.tabBar.backgroundImage = [self imageWithColor:UIColorFromRGB(0xFfffff)];
        self.tabBar.shadowImage = [self imageWithColor:UIColorFromRGB(0xF0ECE8)];;
    }
//    UIView *customBackgroundView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//       customBackgroundView.backgroundColor = UIColorFromRGB(0xF0ECE8);
//       [[UITabBar appearance] insertSubview:customBackgroundView atIndex:0];
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)LoadabbarUI{
     
    WalletViewController *oneVC = [[WalletViewController alloc]init];

    MarketViewController*twoVC=[[MarketViewController alloc]init];
//    markettViewController*twoVC=[[markettViewController alloc]init];
    DappViewController*sanVC=[[DappViewController  alloc]init];
 
    MyViewController*sivc=[[MyViewController alloc]init];
   
//
     
//    UINavigationController *firstNC = [[UINavigationController alloc]initWithRootViewController:oneVC];
//
//     UINavigationController *towNC = [[UINavigationController alloc]initWithRootViewController:twoVC];
//       UINavigationController *threNC = [[UINavigationController alloc]initWithRootViewController:sanVC];
//
//    UINavigationController *fourNC = [[UINavigationController alloc]initWithRootViewController:sivc];
//
//
//
////   UINavigationController *fourNC = [[UINavigationController alloc]initWithRootViewController:fourvc];
//
//    self.viewControllers=@[firstNC, towNC,threNC,fourNC];


    [self  setVCName:oneVC  nameStr:getLocalStr(@"钱包") image:[UIImage imageNamed:@"tab_wal_n"] seleimage:[UIImage imageNamed:@"tab_wal_s"] titcolo:[UIColor blueColor] vc:oneVC];
    
    [self  setVCName:twoVC nameStr:getLocalStr(@"市场") image:[UIImage imageNamed:@"tab_mark_n"] seleimage:[UIImage imageNamed:@"tab_mark_s"] titcolo:[UIColor blueColor] vc:twoVC];
     [self  setVCName:sanVC   nameStr:@"DApp" image:[UIImage imageNamed:@"tab_dap_n"] seleimage:[UIImage imageNamed:@"tab_dap_s"] titcolo:[UIColor blueColor] vc:sanVC];
    [self  setVCName:sivc    nameStr:getLocalStr(@"myd") image:[UIImage imageNamed:@"tab_set_n"] seleimage:[UIImage imageNamed:@"tab_set_s"] titcolo:[UIColor blueColor] vc:sivc];
    



}


-(void)setVCName:(UIViewController*)view  nameStr:(NSString*)str image:(UIImage*)image seleimage:(UIImage*)seleimage titcolo:(UIColor*)color vc:(UIViewController*)vc;
{
    //    view.title=str;
    
    
    
    HBDNavigationController*navi=[[HBDNavigationController alloc]initWithRootViewController:view];
    
    navi.edgesForExtendedLayout = UIRectEdgeNone ;
    navi.navigationController.navigationBar.translucent = NO ;
    navi.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    navi.tabBarItem.selectedImage = [seleimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navi.tabBarItem.title = str;
    [self addChildViewController:navi];
    
//
//    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)}   forState:UIControlStateNormal];

    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
//
//    view.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x037ffe);
}


- (void)addCustomChildVC:(UIViewController *)vc title:(NSString *)title imageName:(UIImage*)image seleimage:(UIImage*)seleimage {
    
 image=[image   imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setImage:image];
    //    view.tabBarItem.sol_title=str;
        vc.tabBarItem.title=title;
     
        seleimage=[seleimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setSelectedImage:seleimage ];
        
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)}   forState:UIControlStateNormal];

//         [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0xe1014a)} forState:UIControlStateSelected];

       [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    
    
//     vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
   
    
    [self addChildViewController:nav];
    
}
#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupAnaimationWithTabBarController:tabBarController selectViewController:viewController];
//    });
    
  
}

#pragma mark - Animation

- (void)setupAnaimationWithTabBarController:(UITabBarController *)tabBarController selectViewController:(UIViewController *)viewController {
    
    if (self.animationView) {
        [self.animationView stop];
    }
    
    //1.
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    
    __block NSMutableArray <UIImageView *>*tabBarSwappableImageViews = [NSMutableArray arrayWithCapacity:4];
    
    //2.
    for (UIView *tempView in tabBarController.tabBar.subviews) {
        
        if ([tempView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            //2.1
            for (UIImageView *tempImageView in tempView.subviews) {
                if ([tempImageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [tabBarSwappableImageViews addObject:tempImageView];
                }
            }
        }
    }
    
    //3.
    __block UIImageView *currentTabBarSwappableImageView = tabBarSwappableImageViews[index];
    
    //4.
    CGRect frame = currentTabBarSwappableImageView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    __block LOTAnimationView *animationView = [self getAnimationViewAtTabbarIndex:index frame:frame];
    self.animationView = animationView;
    animationView.center = currentTabBarSwappableImageView.center;
    [currentTabBarSwappableImageView.superview addSubview:animationView];
    currentTabBarSwappableImageView.hidden = YES;

    //5.
    [animationView playFromProgress:0 toProgress:1 withCompletion:^(BOOL animationFinished) {
        currentTabBarSwappableImageView.hidden = NO;
        [animationView removeFromSuperview];
        animationView = nil;
    }];
}

- (LOTAnimationView *)getAnimationViewAtTabbarIndex:(NSInteger)index frame:(CGRect)frame {
    
    // tabbar1 。。。 tabbar3
    LOTAnimationView *view = [LOTAnimationView animationNamed:[NSString stringWithFormat:@"tabbar_%ld",index+1]];
    view.frame = frame;
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.animationSpeed = 1;
    return view;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
