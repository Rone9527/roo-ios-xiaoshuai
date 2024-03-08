//
//  remView.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "remView.h"
#import "WSLWaterFlowLayout.h"
#import "coltCollectionViewCell.h"
#import "dappDetViewController.h"
#import "dapptyModel.h"
#import "walletNodesModel.h"
#import "blockModel.h"



@interface remView()<UICollectionViewDataSource,UICollectionViewDelegate,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,strong)NSMutableArray*dataArr;

@end

@implementation remView
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    
    return _dataArr;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        [self setUI];
      
        [self update];
        
      
        
    }
 
    return self;
}
-(void)update{
    
    [self resqList];
}
-(void)setUI{
    
    
    
    UILabel*ldb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(50), gdValue(23))];
    ldb.text=getLocalStr(getLocalStr(@"adm4"));
    ldb.font=fontMidNum(16);
    ldb.textColor=ziColor;
    [self addSubview:ldb];
    
    

    
    [self addSubview:self.mainCollectionView];
    
 
}

-(void)resqList{
    
    
    id responseObject=[XHNetworkCache cacheJsonWithURL:dahotsAPI];
    [self jsonJx:responseObject];
    
    NSDictionary*dic=@{@"hots":@"1"};
    
    [Request GET:dahotsAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//        NSLog(@"sdsds----%@",[Utility strData:responseObject]);
        
        [self jsonJx:responseObject];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    

}

-(void)jsonJx:(id)responseObject{
    
//    NSLog(@"sdf---%@",[Utility strData:responseObject]);
    
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
        [self.dataArr removeAllObjects];
        NSArray*art=responseObject[@"data"];
       
        
        for(NSDictionary*dict in art){
            dapptyModel*model =[dapptyModel mj_objectWithKeyValues:dict];
       
           
            [self.dataArr addObject:model];
            
        }
        if(self.dataArr.count>10){
            
            NSArray*aty=[self.dataArr subarrayWithRange:NSMakeRange(0, 10)];
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:aty];
            
        }
    
        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:dahotsAPI];
        [self.mainCollectionView reloadData];
        
    }
        
        
    
    
}


#pragma mark --CollectDelgate--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    coltCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dtllId" forIndexPath:indexPath];
   
    cell.model=self.dataArr[indexPath.row];
    
//    cell.img.image=imageName(@"icdm");
//    cell.titLab.text=@"Uniswap";
    
    
    return cell;
}
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
   return CGSizeMake(gdValue(70) ,gdValue(70));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    dapptyModel*model=self.dataArr[indexPath.row];
    model= [Utility setmodelValue:model];
   
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DAPPtangck" object:model];
//    if([Utility isBlankString:model.addres]){
//
//        NSString*srt=[NSString stringWithFormat:@"没有该%@链资产",model.chain];
//        [MBProgressHUD showText:srt];
//        return;
//    }
//
//
//
//    dappDetViewController*depVc=[[dappDetViewController alloc]init];
//    [depVc setHidesBottomBarWhenPushed:YES];
//
////    NSLog(@"dddd---%@",model.links);
//    depVc.dappmodel=model;
//
//    [depVc setHidesBottomBarWhenPushed:YES];
//
//    [[Utility dc_getCurrentVC].navigationController pushViewController:depVc animated:YES];
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
 
        return 5;
 
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return gdValue(5);
}
///** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return gdValue(5);
}
///** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(0, gdValue(5),gdValue(5), 0);
}






-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
//
        WSLWaterFlowLayout*layout =[[WSLWaterFlowLayout alloc] init];
        layout.delegate = self;
        
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,gdValue(50), SCREEN_WIDTH,self.height-gdValue(50)) collectionViewLayout:layout];
//        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
   
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[coltCollectionViewCell class] forCellWithReuseIdentifier:@"dtllId"];
        
        _mainCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mainCollectionView.showsVerticalScrollIndicator=NO;
        //4.设置代理
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        
    }
    return _mainCollectionView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
