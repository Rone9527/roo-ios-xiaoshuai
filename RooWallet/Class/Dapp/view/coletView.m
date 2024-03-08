//
//  coletView.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "coletView.h"
#import "WSLWaterFlowLayout.h"
#import "coltCollectionViewCell.h"
#import "dappDetViewController.h"
#import "dapptyModel.h"
#import "walletNodesModel.h"
#import "blockModel.h"
#import "collecZJViewController.h"



@interface coletView()<UICollectionViewDataSource,UICollectionViewDelegate,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,strong)NSMutableArray*btnArr;
@property(nonatomic,copy)NSArray*collArr;
@property(nonatomic,copy)NSArray*zjArr;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UIView*noView;
@property(nonatomic,weak)UILabel*tslab;
@property(nonatomic,strong)UIButton*moreBtn;


@end

@implementation coletView
-(NSMutableArray*)btnArr{
    if(!_btnArr){
        _btnArr=[NSMutableArray array];
    }
    return _btnArr;
}
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _index=0;
        [self setUI];
        
      
        
    }
 
    return self;
}
-(void)getdata{
   
    _collArr=[dapptyModel bg_findAll:bg_cooletname];
//    _collArr=[dapptyModel bg_find:bg_cooletname limit:5 orderBy:@"num" desc:YES];
    

    _zjArr=[dapptyModel bg_findAll:bg_zuijinname];
   
 
   
    [self.dataArr removeAllObjects];
    
    _zjArr=[[_zjArr reverseObjectEnumerator] allObjects];
    _collArr=[[_collArr reverseObjectEnumerator] allObjects];
    
    if( _zjArr.count>5){
        
        for(int i=0;i<_zjArr.count;i++){
            if(i<_zjArr.count-5){
                [dapptyModel bg_delete:bg_zuijinname row:i+1];
            }
        }
    }
 
    
    if(_index==0){//收藏
        self.tslab.text=getLocalStr(@"flsht28");
        
        [self.dataArr addObjectsFromArray:_collArr];
        
        if(self.dataArr.count){
        self.moreBtn.hidden=NO;
        NSString*numstr=[NSString stringWithFormat:getLocalStr(@"flsht30"),self.dataArr.count];
        [self.moreBtn setTitle:numstr forState:UIControlStateNormal];
        [_moreBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(8)];
        }
        else{
        self.moreBtn.hidden=YES;
        }
        
    }
    else{//浏览
        self.moreBtn.hidden=YES;
        self.tslab.text=getLocalStr(@"flsht29");
        
        for(dapptyModel*mm in _zjArr){
            if([mm.pxnum isEqualToString:@"1"]){
                [self.dataArr removeObject:mm];
                [self.dataArr insertObject:mm atIndex:0];
                
            }
            else{
                [self.dataArr addObject:mm];
            }
            
        }
       
    }
    

    if(self.dataArr.count){
        self.noView.hidden=YES;
       
    }
    else{
        
        self.noView.hidden=NO;
       
        
        
    }
    [self.mainCollectionView reloadData];
    
    
    
}
-(void)setUI{
    NSArray*rt=@[getLocalStr(@"adm2"),getLocalStr(@"adm3")];
    
    for(int i=0;i<2;i++){
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(10)+gdValue(70)*i, gdValue(5), gdValue(50), gdValue(40));
        [btn setTitle:rt[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [btn setTitleColor:mainColor forState:UIControlStateSelected];
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font=fontNum(14);
//        btn.backgroundColor=[UIColor redColor];
        btn.tag=1008+i;
        [self addSubview:btn];
        if(i==0){
            btn.selected=YES;
            btn.titleLabel.font=fontMidNum(16);
        }
        [self.btnArr addObject:btn];
        
        [btn addTarget:self action:@selector(bck:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.noView];
    [self addSubview:self.moreBtn];
    
    
}

-(void)bck:(UIButton*)sender{
    
  
    _index=sender.tag-1008;
    
    for(UIButton*btn in self.btnArr){
        if(sender.tag==btn.tag){
            btn.selected=YES;
            btn.titleLabel.font=fontMidNum(16);
        }
        else{
            btn.selected=NO;
            btn.titleLabel.font=fontNum(14);
        }
    }
    [self getdata];
    
}

-(void)moreclick{
    
    collecZJViewController*clooVC=[[collecZJViewController alloc]init];
    
    clooVC.scourArr=self.dataArr;
   
    
    [clooVC setHidesBottomBarWhenPushed:YES];
    
    [[Utility dc_getCurrentVC].navigationController pushViewController:clooVC animated:YES];
    
    
}
#pragma mark --CollectDelgate--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(self.dataArr.count>5){
        return 5;
    }
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    coltCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dtllId" forIndexPath:indexPath];
    
    cell.model=self.dataArr[indexPath.row];
   
    
    return cell;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(gdValue(70) ,gdValue(70));
//}
//
//
////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//
//    return UIEdgeInsetsMake(gdValue(0), gdValue(0),0, gdValue(0));
//
//
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return gdValue(10);
//}


//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
   return CGSizeMake(gdValue(70) ,gdValue(70));
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
    
    return UIEdgeInsetsMake(gdValue(0), gdValue(0),0, gdValue(0));
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    dapptyModel*model=self.dataArr[indexPath.row];
    
    if([model.tyy isEqualToString:@"0"]){
       
        
        dappDetViewController*depVc=[[dappDetViewController alloc]init];
         model= [Utility setmodelValue:model];
 
             
               depVc.dappmodel=model;
       
               [depVc setHidesBottomBarWhenPushed:YES];
       
               [[Utility dc_getCurrentVC].navigationController pushViewController:depVc animated:YES];
    }
    else{
    model.addres=@"";
    
    model= [Utility setmodelValue:model];

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DAPPtangck" object:model];
    }
    
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



-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
//

//
        WSLWaterFlowLayout*layout =[[WSLWaterFlowLayout alloc] init];
        layout.delegate = self;
        
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        //设置collectionView滚动方向
//        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        layout.itemSize = CGSizeMake(gdValue(108), gdValue(94));//每一个cell的大小
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
//
//        layout.sectionInset = UIEdgeInsetsMake(0,gdValue(15), 0, gdValue(15));//四周的边距
//        //设置最小边距
//        layout.minimumLineSpacing = gdValue(10);
        
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,gdValue(55), SCREEN_WIDTH,self.height-gdValue(60)) collectionViewLayout:layout];
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

-(UIView*)noView{
    if(!_noView){
        _noView=[[UIView alloc]initWithFrame:CGRectMake(0,gdValue(30), SCREEN_WIDTH,self.height-gdValue(30))];
        
        UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(35))/2, gdValue(5), gdValue(35), gdValue(40))];
        img.image=imageName(@"noscd");
        [_noView addSubview:img];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+gdValue(10), SCREEN_WIDTH, gdValue(23))];
        lab.text=getLocalStr(@"flsht28");
        lab.font=fontNum(14);
        lab.textColor=UIColorFromRGB(0xC4C9D8);
        lab.textAlignment=NSTextAlignmentCenter;
        self.tslab=lab;
        
        [_noView addSubview:lab];
        
        _noView.hidden=YES;
        
        
        
    }
    return _noView;
}

-(UIButton*)moreBtn{
    if(!_moreBtn){
        _moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        _moreBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(100), gdValue(10), gdValue(80), gdValue(30));
        [_moreBtn setTitle:@"" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font=fontNum(14);
        [_moreBtn setImage:imageName(@"dlad") forState:UIControlStateNormal];
        _moreBtn.hidden=YES;
        _moreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [_moreBtn addTarget:self action:@selector(moreclick) forControlEvents:UIControlEventTouchUpInside];
      
        [_moreBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(8)];
    }
    
    return _moreBtn;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
