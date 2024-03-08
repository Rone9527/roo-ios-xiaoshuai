//
//  walletHeadView.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "walletHeadView.h"
#import "walletCollectionViewCell.h"
#import "seleBiView.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "symbolModel.h"
#import "swapViewController.h"
#import "authsmView.h"
#import "addAsstsViewController.h"


@interface walletHeadView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,strong)walletModel*model;
@property(nonatomic,copy)NSString*allPrc;


@end
@implementation walletHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
      
        
    
     
        [self setUI];
        
      
        
    }
 
    return self;
}
-(void)setUsModel:(userModel *)usModel{
    _usModel=usModel;
   
    [self.mainCollectionView reloadData];
}
-(void)setModel:(walletModel *)model{
   
    
}
-(void)setAllArr:(NSArray *)allArr{
    
    _allArr=allArr;
   double allPrice=0.00;
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
   
   
    for(symbolModel*model in allArr){
        
        if([model.symbol isEqualToString:@"USDT"]){
            model.price=@"1";
            model.pricdecimals=@"4";
            
        }
        
        
        allPrice=allPrice+[model.price doubleValue]*[tare doubleValue]*[model.numRest doubleValue];
        
       

    }
    
    NSString*prc=[NSString stringWithFormat:@"%f",allPrice];
//    allPrice=[Utility douVale:atrr num:[model.decimals intValue]]
    
   _allPrc=[NSString stringWithFormat:@"%@",[Utility douVale:prc num:2]];//总价
   
    [self.mainCollectionView reloadData];
    
    
    
}
-(BOOL)getisKydji{
    BOOL isdj=NO;
  
    
    if(_usModel.walletArray.count>0){
        isdj=YES;
        
    }
    
    return isdj;;
}
-(void)setUI{
    [self addSubview:self.mainCollectionView];
}

#pragma mark --CollectDelgate--
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    walletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
   
//    cell.model=_model;
    
//    NSLog(@"sd2222----%@",_usModel.isHide?@"1":@"2");
    BOOL isyin=[[NSUserDefaults standardUserDefaults]boolForKey:isYinPrice];
    
    cell.isHid=isyin;//_usModel.isHide;
    cell.allprc=self.allPrc;
    
    WeakSelf;
    cell.getwaBlock1 = ^(int indx) {
        
            
        if(indx==2){
            
            [MBProgressHUD showText:getLocalStr(@"暂未开放")];
            return;;
            
            userModel*usermodl=[userModel bg_findAll:bg_tablename][selewalletIndex];


             NSArray*userWallArr= usermodl.walletArray;

            NSMutableArray*tiarr=[NSMutableArray array];
            
            
     //
             for(walletModel*modl in userWallArr){
                 
                 [tiarr addObject:modl.name];
                 
             }
            
            if([tiarr containsObject:@"ETH"]){
                swapViewController*swapvc=[[swapViewController alloc]init];
                swapvc.sendlx=0;
                swapvc.nameStr=@"ETH";
                [swapvc setHidesBottomBarWhenPushed:YES];
                [[Utility dc_getCurrentVC].navigationController pushViewController:swapvc animated:YES];
                return;
            }
            else if ([tiarr containsObject:@"BSC"]){
                swapViewController*swapvc=[[swapViewController alloc]init];
                swapvc.sendlx=1;
                swapvc.nameStr=@"BSC";
                [swapvc setHidesBottomBarWhenPushed:YES];
                [[Utility dc_getCurrentVC].navigationController pushViewController:swapvc animated:YES];
                return;
            }
            else{
                userModel*usModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
                        //        WeakSelf;
                                authsmView*view=[[authsmView alloc]initWithFrame:SCREEN_FRAME tit:@"ETH"];
                                view.numblock = ^{
                                    addAsstsViewController*addVc=[[addAsstsViewController alloc]init];
//                                    addVc.userModel=usModel;
                                    [addVc setHidesBottomBarWhenPushed:YES];
                                    [[Utility dc_getCurrentVC].navigationController pushViewController:addVc animated:YES];
                
                                };
                
                                return;
            }
            
   
            
            
//            [MBProgressHUD showText:getLocalStr(@"jdaits")];
        }
        
        else{
            if(weakSelf.allArr.count>0){
            seleBiView*view=[[seleBiView alloc]initWithFrame:SCREEN_FRAME type:indx Tokenarr:weakSelf.allArr];
            
            [view show];
            }
            else{
                [MBProgressHUD showText:getLocalStr(@"adm23")];
            }
        }
       
       
    };
    
  
    
    
//    cell.zcPriceLab.text=[NSString stringWithFormat:@"s---%ld",imageNum];
    
    
    return cell;
}



#pragma mark - Handle Click
//- (void)currentPageChanged:(LWDPageControl *)pageControl{
//    [self.mainCollectionView scrollRectToVisible:CGRectMake(pageControl.currentPage*self.mainCollectionView.frame.size.width, 0, self.mainCollectionView.frame.size.width, self.mainCollectionView.frame.size.height) animated:YES];
//}



-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
   
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, self.height);//每一个cell的大小
           layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
          
           layout.sectionInset = UIEdgeInsetsMake(0,0, 0, 0);//四周的边距
           //设置最小边距
           layout.minimumLineSpacing = 0;
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
       
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[walletCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        
     
        _mainCollectionView.showsHorizontalScrollIndicator=NO;
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
