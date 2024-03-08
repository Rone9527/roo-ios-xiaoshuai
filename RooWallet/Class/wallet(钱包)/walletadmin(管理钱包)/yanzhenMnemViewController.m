//
//  yanzhenMnemViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/29.
//

#import "yanzhenMnemViewController.h"
#import "mnenCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "wallDetViewController.h"
@interface yanzhenMnemViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,assign)int starNum;
@property(nonatomic,assign)int endNum;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)NSMutableArray*scourArr;
@property(nonatomic,weak)UIButton*qbBtn;

@end

@implementation yanzhenMnemViewController
//获取一个随机整数，范围在[from,to]，包括from，包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
    
}

-(int)getRandomNumberr:(int)from to:(int)to
{
    int end=(int)(from + (arc4random() % (to-from + 1)));
    
    for(int i=0;i<9999999;i++){
        NSLog(@"次数==%d",i);
    if(end==_starNum){
        end=(int)(from + (arc4random() % (to-from + 1)));
    }
    else{
        return end;
    }

        
    }
    
    return end;
    
}
-(NSMutableArray*)scourArr{
    if(!_scourArr){
        _scourArr=[NSMutableArray array];
    }
    return _scourArr;
}
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=getLocalStr(@"rzt7");
    
    _starNum=[self getRandomNumber:0 to:11];
    _endNum=[self getRandomNumberr:0 to:11];
//
//
    
//    NSLog(@"ertt---sddsdsd-%@",_mneArr);
//    NSLog(@"sd---%@",[self randamArry:_mneArr]);
//
    [self.scourArr addObjectsFromArray:[self randamArry:_mneArr]];
//
//
//
//
////    NSLog(@"sd---%d   d---%d",_starNum,_endNum);
//
    [self setUI];
    

    
    // Do any additional setup after loading the view.
}
- (NSArray*)randamArry:(NSArray *)arry
{
    // 对数组乱序
    arry = [arry sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
  
    
    return arry;
    

}

-(NSMutableArray*)getRandomArrFrome:(NSArray*)arr
{
    NSMutableArray *newArr = [NSMutableArray new];
    
 
    
    while (newArr.count != arr.count) {
        //生成随机数
        
        int x =arc4random() % arr.count;
        
//        NSLog(@"sdd---%ld",newArr.count);
        
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}
-(void)setUI{
    
    UILabel*tslb=[[UILabel alloc]initWithFrame:CGRectMake(0, WD_StatusHight+gdValue(20), SCREEN_WIDTH, gdValue(20))];
    tslb.text=getLocalStr(@"rzt8");
    tslb.font=fontNum(14);
    tslb.textColor=UIColorFromRGB(0x666666);
    tslb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tslb];
    
    UILabel*tslb1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), tslb.bottom+gdValue(40), SCREEN_WIDTH, gdValue(23))];
    tslb1.text=[NSString stringWithFormat:getLocalStr(@"rzt9"),_starNum+1,_endNum+1];
    tslb1.font=fontNum(16);
    tslb1.textColor=ziColor;
//    tslb1.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tslb1];
    
    
    [self.view addSubview:self.mainCollectionView];
    
    
    
    

    UIButton*qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    qdBtn.frame=CGRectMake(gdValue(35), _mainCollectionView.bottom+gdValue(90), SCREEN_WIDTH-gdValue(70), gdValue(50));
    ViewRadius(qdBtn, gdValue(8));
    qdBtn.enabled=NO;
    self.qbBtn=qdBtn;

    qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
    [qdBtn setTitle:getLocalStr(@"rzt10") forState:UIControlStateNormal];
    qdBtn.titleLabel.font=fontNum(16);
    [qdBtn addTarget:self action:@selector(qdCk) forControlEvents:UIControlEventTouchUpInside];
    [qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:qdBtn];
    
   
    
}
-(void)qdCk{
    
    
    NSString*starstr=_mneArr[_starNum];
    NSString*endstr=_mneArr[_endNum];
    
    
    
   
    if([self.dataArr containsObject:starstr]&&[self.dataArr containsObject:endstr]){
        NSLog(@"验证完成");
//        UIPasteboard *pab = [UIPasteboard generalPasteboard];
//        pab.string = _mnemonics;
        
        [MBProgressHUD showText:getLocalStr(@"rzt12")];
        
        
        if(_type==1){
            
            if(self.block){
                self.block(@"1");
            }
            
            
        }
        else{
            
            userModel*userModell=[userModel bg_findAll:bg_tablename][selewalletIndex];
            userModell.isbackUps=@"1";
            [userModell bg_saveOrUpdate];
            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3]
                     animated:YES];
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[wallDetViewController class]]) {
//                [self.navigationController popToViewController:controller animated:YES];
//            }
//        }
            
        }
    }
    else{
        [MBProgressHUD showText:getLocalStr(@"rzt11")];
    }
    
    
    
   
    
    
    
//
    
   
  
    
}


#pragma mark --CollectDelgate--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.scourArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mnenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mnenedllId" forIndexPath:indexPath];
    cell.backgroundColor=cyColor;
    ViewRadius(cell, gdValue(6));
    cell.nrLab.text=[NSString stringWithFormat:@"%@",self.scourArr[indexPath.row]];
    
    if([self.dataArr containsObject:cell.nrLab.text]){
        cell.contentView.backgroundColor=mainColor;
        cell.nrLab.textColor=[UIColor whiteColor];
        
    }
    else{
        cell.contentView.backgroundColor=cyColor;
        cell.nrLab.textColor=ziColor;
    }
    
//    cell.numLab.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    
    return cell;
}



//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
   return CGSizeMake((SCREEN_WIDTH-gdValue(60))/3 ,gdValue(45));
}



/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
 
        return 3;
 
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return gdValue(15);
}
///** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return gdValue(15);
}
///** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(gdValue(15), gdValue(15),gdValue(15), gdValue(15));
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString*mnstr=self.scourArr[indexPath.row];
    
    if([self.dataArr containsObject:mnstr]){
        [self.dataArr removeObject:mnstr];
    }
    else{
        if(self.dataArr.count<2){
            [self.dataArr addObject:mnstr];
        }
        else{
            [MBProgressHUD showText:getLocalStr(@"rzt13")];
            
        }
    }
    
    if(self.dataArr.count==2){
        self.qbBtn.enabled=YES;
        self.qbBtn.backgroundColor=mainColor;
    }
    else{
        self.qbBtn.enabled=NO;
        self.qbBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        
        
    }
    [self.mainCollectionView reloadData];
    
    
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
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, WD_StatusHight+gdValue(110), SCREEN_WIDTH, gdValue(250)) collectionViewLayout:layout];
//        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
//        ViewRadius(_mainCollectionView, gdValue(20));
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[mnenCollectionViewCell class] forCellWithReuseIdentifier:@"mnenedllId"];
        
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
