//
//  MnemonViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "MnemonViewController.h"
#import "mnemView.h"
#import "mnenCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "yanzhenMnemViewController.h"
@interface MnemonViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)UICollectionView*mainCollectionView;

@property(nonatomic,copy)NSArray*mneArr;
@end

@implementation MnemonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.type==1){
        self.leftBtn.hidden=YES;
        
    }
    self.baseLab.text=getLocalStr(@"wamne");
    mnemView*view=[[mnemView alloc]initWithFrame:SCREEN_FRAME];
    [view show];
    
    _mneArr=[_mnemonics componentsSeparatedByString:@" "];
    
       
    
    [self setUI];
    
    
    // Do any additional setup after loading the view.
}

-(void)setUI{
    
    UILabel*tslb=[[UILabel alloc]initWithFrame:CGRectMake(0, WD_StatusHight+gdValue(45), SCREEN_WIDTH, gdValue(20))];
    tslb.text=getLocalStr(@"wabfts");
    tslb.font=fontNum(14);
    tslb.textColor=UIColorFromRGB(0x666666);
    tslb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tslb];
    
    [self.view addSubview:self.mainCollectionView];
    
    
    UIButton*fzbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fzbtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(87), _mainCollectionView.bottom+gdValue(10), gdValue(70), gdValue(25));
    [fzbtn setTitle:getLocalStr(@"wafzjx") forState:UIControlStateNormal];
    [fzbtn setTitleColor:mainColor forState:UIControlStateNormal];
    fzbtn.titleLabel.font=fontNum(14);
    [fzbtn addTarget:self  action:@selector(fzCk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fzbtn];
    
    
    UIButton*qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    qdBtn.frame=CGRectMake(gdValue(35), _mainCollectionView.bottom+gdValue(90), SCREEN_WIDTH-gdValue(70), gdValue(50));
    ViewRadius(qdBtn, gdValue(8));
   
    qdBtn.backgroundColor=mainColor;
    [qdBtn setTitle:getLocalStr(@"waqdbf") forState:UIControlStateNormal];
    qdBtn.titleLabel.font=fontNum(16);
    [qdBtn addTarget:self action:@selector(qdCk) forControlEvents:UIControlEventTouchUpInside];
    [qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:qdBtn];
    
    
    UIButton*xhBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    xhBtn.frame=CGRectMake((SCREEN_WIDTH-gdValue(80))/2, qdBtn.bottom+gdValue(30), gdValue(80), gdValue(30));
    
   
    xhBtn.backgroundColor=[UIColor whiteColor];
    [xhBtn setTitle:getLocalStr(@"waxhbf") forState:UIControlStateNormal];
    xhBtn.titleLabel.font=fontBoldNum(16);
    [xhBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [xhBtn addTarget:self  action:@selector(xhbeifen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xhBtn];
    
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_type==1){
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
          self.navigationController.interactivePopGestureRecognizer.enabled = NO;
      }
    }
}
    

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_type==1){
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
           self.navigationController.interactivePopGestureRecognizer.enabled = YES;
       }
        
    }
}


#pragma mark --稍后备份
-(void)xhbeifen{
    
    if(_type==1){
        
    if(self.block){
        self.block(@"0");
        
    }
        
    }
    else{
     
        [self leftBarBtnClicked];
        
    }
    
}
#pragma mark 验证
-(void)qdCk{
    
    NSLog(@"111111");
    yanzhenMnemViewController*yzmnVC=[[yanzhenMnemViewController alloc]init];
    yzmnVC.mneArr=_mneArr;
    yzmnVC.mnemonics=_mnemonics;
    yzmnVC.type=_type;
    
    [self.navigationController pushViewController:yzmnVC animated:YES];
    
    WeakSelf;
    yzmnVC.block = ^(NSString * _Nullable blockStr) {
        
        if(weakSelf.block){
            weakSelf.block(blockStr);
            
        }
    };
    
    
   
    

    
}
-(void)fzCk{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = _mnemonics;
       if (pab == nil) {
         
       } else {
           [MBProgressHUD showText:getLocalStr(@"wafbfc")];
       }
}


#pragma mark --CollectDelgate--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _mneArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mnenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mnenellId" forIndexPath:indexPath];
    cell.backgroundColor=cyColor;
    cell.nrLab.text=[NSString stringWithFormat:@"%@",_mneArr[indexPath.row]];
    cell.numLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    
    return cell;
}



//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
   return CGSizeMake((SCREEN_WIDTH-gdValue(34)-4)/3 ,gdValue(55));
}



/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
 
        return 3;
 
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}
///** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}
///** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(gdValue(0), gdValue(0),0, gdValue(0));
}






-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
//
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        //设置collectionView滚动方向
////        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        layout.itemSize = CGSizeMake(gdValue(107), gdValue(55));//每一个cell的大小
//           layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
//
//           layout.sectionInset = UIEdgeInsetsMake(0.5,1,1,0.5);//四周的边距
//           //设置最小边距
//           layout.minimumLineSpacing = 0.5;
//
        
        WSLWaterFlowLayout*layout =[[WSLWaterFlowLayout alloc] init];
        layout.delegate = self;
        
        
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(gdValue(17), WD_StatusHight+gdValue(98), SCREEN_WIDTH-gdValue(34), gdValue(230)) collectionViewLayout:layout];
//        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        ViewRadius(_mainCollectionView, gdValue(20));
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[mnenCollectionViewCell class] forCellWithReuseIdentifier:@"mnenellId"];
        
        _mainCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mainCollectionView.showsVerticalScrollIndicator=NO;
        //4.设置代理
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        
    }
    return _mainCollectionView;
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
