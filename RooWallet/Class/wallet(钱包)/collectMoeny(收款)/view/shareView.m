//
//  shareView.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "shareView.h"
#import "shareViewCollectionViewCell.h"
//#import <UShareUI/UShareUI.h>


@interface shareView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,strong)UIView*fotView;
@property (strong , nonatomic)UICollectionView *collectionView;
@property(nonatomic,copy)NSArray*tuArr;
@property(nonatomic,copy)NSArray*titArr;
@property(nonatomic,strong)UIImage*shareImg;
@end

@implementation shareView
- (instancetype)initWithFrame:(CGRect)frame  shaimg:(UIImage*)img {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _shareImg=img;
        _tuArr=@[@"share_1",@"share_2",@"share_3",@"share_4"];
        _titArr=@[getLocalStr(@"share1"),getLocalStr(@"share2"),getLocalStr(@"share3"),getLocalStr(@"share4")];
        
        [self setUI];
        
      
        
    }
 
    return self;
}
-(void)setUI{
    self.frame=SCREEN_FRAME;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
    [self addGestureRecognizer:tap];
//
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-gdValue(175), SCREEN_WIDTH, gdValue(175))];
    sheetView.backgroundColor = cyColor;
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sheetView.bounds;
           maskLayer.path = maskPath.CGPath;
    sheetView.layer.mask = maskLayer;
    
    [self loadUI];
    
}
-(void)loadUI{
    [self.sheetView addSubview:self.collectionView];
    [self.sheetView addSubview:self.fotView];
    
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    shareViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.img.image=imageName(self.tuArr[indexPath.row]);
    cell.titLab.text=self.titArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"第%zd分享平台",indexPath.row);
//    if(indexPath.row==0||indexPath.row==1){
//        if([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]){
//            [self getshareTag:indexPath.row];
//        }
//        else{
//            [MBProgressHUD  showText:getLocalStr(@"cw1")];
//        }
//    }
//    else if (indexPath.row==2){
//        if([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]){
//              [self getshareTag:indexPath.row];
//        }
//        else{
//            [MBProgressHUD  showText:getLocalStr(@"cw2")];
//        }
//    }
//    else{
//         [self getshareTag:indexPath.row];
//
//    }
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getshareTag:(NSInteger)btnTag{
//
//    if(btnTag<3){
//        UMSocialPlatformType platform=UMSocialPlatformType_UnKnown;
//        switch (btnTag) {
//            case 0:
//                // 微信{
//
//                    platform=UMSocialPlatformType_WechatSession;
//
//
//
//                break;
//            case 1:
//                // 微信朋友圈
//                    platform=UMSocialPlatformType_WechatTimeLine;
//
//                break;
//            case 2:
//                // QQ
//                    platform= UMSocialPlatformType_QQ;
//
//                break;
//            case 3:
//                // QQ空间
//                    platform=UMSocialPlatformType_Qzone;
//
//                break;
//            case 4:
//                // 微博
////               platform=UMSocialPlatformType_Sina;
//
//                break;
//
//            default:
//
//                break;
//        }
//
//
//
//    [self getshare:platform];
//
//    }
//    else{//二维码
//        [self loadImageFinished:_shareImg];
//
////        if(self.getStrBlock){
////            self.getStrBlock();
////        }
//        [self hide];
//
//    }

    
}

//-(void)getshare:(UMSocialPlatformType)platform {
//    [self hide];
//    
////    NSLog(@"s---%@",_shareImg);
//    
//    
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//     //创建图片内容对象
//     UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//     //如果有缩略图，则设置缩略图
////     shareObject.thumbImage = [UIImage imageNamed:@"tab_dap_s"];
//     [shareObject setShareImage:_shareImg];
//     //分享消息对象设置分享内容对象
//     messageObject.shareObject = shareObject;
//     //调用分享接口
//     [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:[Utility dc_getCurrentVC] completion:^(id data, NSError *error) {
//         if (error) {
//             [MBProgressHUD showText:@"分享失败"];
//             NSLog(@"************Share fail with error %@*********",error);
//         }else{
//             NSLog(@"response data is %@",data);
//         }
//     }];
//    
//    
//    
//  
//}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-gdValue(60))/4, gdValue(80));
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(gdValue(5),gdValue(10), gdValue(5), gdValue(10));
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return gdValue(10);
}

 -(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture

{

//if(gesture.state==UIGestureRecognizerStateBegan)
//
//{
//   UIImageView*img = (UIImageView*)[gesture view];
//    [self loadImageFinished:img.image];
//
//}

}
- (void)loadImageFinished:(UIImage *)image
{
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if(!error){
        [MBProgressHUD showText:getLocalStr(@"sbdg")];
    }
}



-(NSArray*)tuArr{
    if(!_tuArr){
        _tuArr=@[@"share_wx",@"share_pyq",@"share_qq",@"share_qz"];
    }
    return _tuArr;
}
-(NSArray*)titArr{
    if(!_titArr){
        _titArr=@[@"微信",@"朋友圈",@"QQ",@"QQ空间"];
    }
    return _titArr;
    
}


/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT;
    WeakSelf;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.sheetView.frame = rect;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.sheetView removeFromSuperview];
//
    }];
}
-(void)delView{
    [self removeFromSuperview];
    [self.sheetView removeFromSuperview];
}
-(void)dealloc{
    NSLog(@"menhui");
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT-gdValue(175);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,gdValue(20), SCREEN_WIDTH, gdValue(98)) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor=cyColor;
        //注册
      [_collectionView registerClass:[shareViewCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
       
    }
    return _collectionView;
}
-(UIView*)fotView{
    if(!_fotView){
        _fotView=[[UIView alloc]initWithFrame:CGRectMake(0,_collectionView.bottom, SCREEN_WIDTH, gdValue(57))];
        _fotView.backgroundColor=[UIColor whiteColor];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, _fotView.width, _fotView.height);
        [btn setTitle:getLocalStr(@"waqux") forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font=fontNum(18);
        [_fotView addSubview:btn];
        [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
      
    }
    return _fotView;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
