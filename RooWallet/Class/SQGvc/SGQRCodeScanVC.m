//
//  SGQRCodeScanVC.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "SGQRCodeScanVC.h"
#import "SGQRCode.h"
@interface SGQRCodeScanVC () {
    SGQRCodeManager *manager;
}
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;;

@end

@implementation SGQRCodeScanVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 二维码开启方法
    [manager startRunningWithBefore:nil completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
    [self removeFlashlightBtn];
    [manager stopRunning];
}

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.baseLab.text=getLocalStr(@"sys");
    self.baseLab.textColor=[UIColor whiteColor];
    self.navHeadView.backgroundColor=[UIColor clearColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"roobackw"] forState:UIControlStateNormal];
   
    
    manager = [SGQRCodeManager QRCodeManager];
    
    [self setupQRCodeScan];

    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(70), WDNavHeight, gdValue(60), gdValue(25));
    [rBtn setTitle:getLocalStr(@"xced") forState:UIControlStateNormal];
    rBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rBtn.titleLabel.font=fontNum(15);
    [self.navHeadView addSubview:rBtn];
    [rBtn addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view bringSubviewToFront:self.navHeadView];
    
    
}

- (void)setupQRCodeScan {
    BOOL isCameraDeviceRearAvailable = manager.isCameraDeviceRearAvailable;
    if (isCameraDeviceRearAvailable == NO) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    manager.openLog = YES;
    manager.brightness = YES;
    
    [manager scanWithController:self resultBlock:^(SGQRCodeManager *manager, NSString *result) {
//        NSLog(@"sdd----%@",result);
        if (result) {
            [manager stopRunning];
            [manager playSoundName:@"SGQRCode.bundle/QRCodeScanEndSound.caf"];
//            if(weakSelf.type==1){
//            if ([result hasPrefix:@"0x"]) {
            if([weakSelf .delegate  respondsToSelector:@selector(getSGQECodeUrlStr:)]){
                [weakSelf .delegate getSGQECodeUrlStr:result];
                [weakSelf leftBarBtnClicked];
            }
                
//            }
//        }
        
//        else{
//            if([weakSelf .delegate  respondsToSelector:@selector(getSGQECodeUrlStr:)]){
//                [weakSelf .delegate getSGQECodeUrlStr:@""];
//                [weakSelf leftBarBtnClicked];
//            }
//
//        }
        }
    }];
    [manager scanWithBrightnessBlock:^(SGQRCodeManager *manager, CGFloat brightness) {
        if (brightness < - 1) {
            [weakSelf.view addSubview:weakSelf.flashlightBtn];
        } else {
            if (weakSelf.isSelectedFlashlightBtn == NO) {
                [weakSelf removeFlashlightBtn];
            }
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT)];
        _scanView.cornerColor=mainColor;
        _scanView.scanImageName=@"SGQsline";//QRCodeScanLine
        
        
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = getLocalStr(@"xced1");
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanView.frame))];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [manager turnOnFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->manager turnOffFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}


#pragma mark 相册点击
- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    
    [manager readWithResultBlock:^(SGQRCodeManager *manager, NSString *result) {
        [MBProgressHUD showHUD];
//        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在处理..." toView:weakSelf.view];
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showText:getLocalStr(@"cw3")];
//                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
//                [MBProgressHUD SG_showMBProgressHUDWithOnlyMessage:@"未发现二维码/条形码" delayTime:1.0];
            });
        } else {
            
            
//            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//            jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
//            if ([result hasPrefix:@"http"]) {
//                jumpVC.jump_URL = result;
//            } else {
//                jumpVC.jump_bar_code = result;
//            }
            NSLog(@"1111");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD SG_hideHUDForView:weakSelf.view];
                [MBProgressHUD hideHUD];
//                if(weakSelf.type==1){
//                if ([result hasPrefix:@"0x"]) {
                if([weakSelf .delegate  respondsToSelector:@selector(getSGQECodeUrlStr:)]){
                    [weakSelf .delegate getSGQECodeUrlStr:result];
                    [weakSelf leftBarBtnClicked];
                }
                    
//                }
//                }
//                else{
//                    if([weakSelf .delegate  respondsToSelector:@selector(getSGQECodeUrlStr:)]){
//                        [weakSelf .delegate getSGQECodeUrlStr:@""];
//                        [weakSelf leftBarBtnClicked];
//                    }
//                }
//                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            });
        }
    }];
    
    if (manager.albumAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [manager albumDidCancelBlock:^(SGQRCodeManager *manager) {
        [weakSelf.scanView addTimer];
    }];
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
