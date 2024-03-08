//
//  collHeaView.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "collHeaView.h"

#import "dappModel.h"

@interface collHeaView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,strong)UICollectionView*headCollectionView;
@property(nonatomic,assign)NSInteger seIndx;
@property(nonatomic,assign)NSInteger tiIndx;
@property(nonatomic,strong)NSMutableArray*btnArr;
@property(nonatomic,strong)NSMutableArray*tllArr;
@property(nonatomic,strong)NSMutableArray*subArr;
@property(nonatomic,strong)NSMutableArray*dataArr;
@end

@implementation collHeaView
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray*)tllArr{
    if(!_tllArr){
        _tllArr=[NSMutableArray array];
    }
    return _tllArr;
}
-(NSMutableArray*)subArr{
    if(!_subArr){
        _subArr=[NSMutableArray array];
    }
    return _subArr;
}
-(NSMutableArray*)btnArr{
    if(!_btnArr){
        _btnArr=[NSMutableArray array];
    }
    return _btnArr;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _seIndx=0;
        _tiIndx=0;
        UIView*coll=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(7))];
        coll.backgroundColor=cyColor;
        [self addSubview:coll];
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, coll.bottom+gdValue(40)+1, SCREEN_WIDTH, 1)];
        col.backgroundColor=cyColor;
        [self addSubview:col];
        
        [self addSubview:self.headCollectionView];
        
        [self addSubview:self.mainCollectionView];
//        [self setUI];
       
        [self getuodate];
        
      
        
    }
 
    return self;
}
-(void)getuodate{
    
    [self getHCdata];
    
    [self geatRedata];
}
-(void)getHCdata{
    
    id responseObjectt=[XHNetworkCache cacheJsonWithURL:dapptyAPI];

    [self jsonJx:responseObjectt];
}
-(void)geatRedata{
      if(self.dataArr.count==0)
      {
          [MBProgressHUD showHUD];
          
      }
    
    [Request GET:dapptyAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"sdsd----%@",[Utility strData:responseObject]);
        
        [self jsonJx:responseObject];
        
    
        
       
      
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
//        NSLog(@"error----%@",[error localizedDescription]);
    }];
    
}

-(void)jsonJx:(id)responseObject{
    
    
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
      
        NSArray*art=responseObject[@"data"];;
        

        
        if(art.count){
            [self.tllArr removeAllObjects];
            [self.subArr  removeAllObjects];
            [self.dataArr removeAllObjects];
            
            for(NSDictionary*dict in art){
                
                dappModel*model=[dappModel mj_objectWithKeyValues:dict];
                [self.dataArr addObject:model];
                
                [self.tllArr addObject:model.name];
                
                NSMutableArray*arr=[NSMutableArray array];
                for(dappxqModel*xqmodel in model.list){
                    [arr addObject:xqmodel.name];
                }
                
                [self.subArr addObject:arr];
//
            }
            
         dappModel*model=self.dataArr[self.tiIndx];
            dappxqModel*xqmodel=model.list[_seIndx];
            NSArray*scouArr=xqmodel.list;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSLog(@"3秒后执行这个方法");
                if([self.delegate respondsToSelector:@selector(getReqDataArr:)]){
    //                NSLog(@"sssssss");
                    [self.delegate getReqDataArr:scouArr];

                }

            });
            
//            NSLog(@"sdd--%ld",scouArr.count);
          
            
           
        }
        [self.mainCollectionView reloadData];
        [self.headCollectionView reloadData];
        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:dapptyAPI];
        
    }
    
}


    
    
    
    
  
    



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(collectionView==self.headCollectionView){
        return _tllArr.count;
    }
    
    
else{
    if(self.subArr.count){
        
    return [self.subArr[_tiIndx]count];
    }
        
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell*Cell=nil;
    
    if(collectionView==self.headCollectionView){
        UICollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hedllId" forIndexPath:indexPath];
        
         for(UIView*vv in cell.contentView.subviews){
             [vv removeFromSuperview];
         }
         
         UILabel*clab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
         clab.text=self.tllArr[indexPath.row];
         clab.textColor=ziColor;
       
         clab.font=fontNum(14);
         clab.textAlignment=NSTextAlignmentCenter;
 
        [cell.contentView addSubview:clab];
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake((cell.width-gdValue(15))/2, gdValue(40)-2, gdValue(15), 2)];
        col.backgroundColor=mainColor;
        [cell.contentView addSubview:col];
        col.hidden=YES;
        
         if(_tiIndx==indexPath.row){
             clab.textColor=mainColor;
             clab.font=fontBoldNum(14);
             col.hidden=NO;
             
         }
        
        Cell=cell;

    }
    
    else{
   UICollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lcellId" forIndexPath:indexPath];
   
    for(UIView*vv in cell.contentView.subviews){
        [vv removeFromSuperview];
    }
    
    UILabel*clab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    clab.text=self.subArr[_tiIndx][indexPath.row];
    clab.textColor=zyincolor;
    clab.backgroundColor=cyColor;
    clab.font=fontNum(11);
    clab.textAlignment=NSTextAlignmentCenter;
//    ViewRadius(clab, cell.height/2);
//    ViewRadius(
   ViewBorderRadius(clab, cell.height/2, 1, cyColor);
    [cell.contentView addSubview:clab];
    if(_seIndx==indexPath.row){
        clab.textColor=mainColor;
    }
        Cell=cell;
    }
    
    return Cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==self.mainCollectionView){
        CGFloat wid=[Utility withForString:self.subArr[_tiIndx][indexPath.row] fontSize:11 andhig:gdValue(25)]+gdValue(20);
        
        return CGSizeMake(wid, gdValue(25));
    }
    
    CGFloat wid=[Utility withForString: self.tllArr[indexPath.row] fontSize:14 andhig:gdValue(40)]+gdValue(20);
   
    
    return CGSizeMake(wid, gdValue(40));
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView==self.headCollectionView){
        _tiIndx=indexPath.row;
        [self.headCollectionView reloadData];
     
        _seIndx=0;
        [self.mainCollectionView reloadData];
        
        dappModel*model=self.dataArr[self.tiIndx];
           dappxqModel*xqmodel=model.list[0];
           NSArray*scouArr=xqmodel.list;
           
        
//        if(self.getBlock){
//            self.getBlock(scouArr);
//        }
           if([self.delegate respondsToSelector:@selector(getReqDataArr:)]){
               [self.delegate getReqDataArr:scouArr];

           }
//        if(self.getBlock){
//            self.getBlock(self.tllArr[self.tiIndx], self.subArr[self.tiIndx][0]);
//        }
    }
    else{
    _seIndx=indexPath.row;
    [self.mainCollectionView reloadData];
        dappModel*model=self.dataArr[self.tiIndx];
           dappxqModel*xqmodel=model.list[indexPath.row];
           NSArray*scouArr=xqmodel.list;
           
//        if(self.getBlock){
//            self.getBlock(scouArr);
//        }
           if([self.delegate respondsToSelector:@selector(getReqDataArr:)]){
               [self.delegate getReqDataArr:scouArr];

           }
//    if(self.getBlock){
//        self.getBlock(_tllArr[_tiIndx], self.subArr[_tiIndx][indexPath.row]);
//    }
    
    }
}

-(UICollectionView*)headCollectionView{
    if(!_headCollectionView){
   
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(gdValue(60), gdValue(40));//每一个cell的大小
           layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
          
           layout.sectionInset = UIEdgeInsetsMake(0,0, 0, gdValue(15));//四周的边距
           //设置最小边距
           layout.minimumLineSpacing = gdValue(10);
        //2.初始化collectionView
        _headCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,gdValue(7), SCREEN_WIDTH, gdValue(40)) collectionViewLayout:layout];
       
//        _mainCollectionView.pagingEnabled=YES;
        _headCollectionView.backgroundColor = [UIColor whiteColor];
       
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_headCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"hedllId"];
        
     
        _headCollectionView.showsHorizontalScrollIndicator=NO;
        _headCollectionView.showsVerticalScrollIndicator=NO;
        //4.设置代理
        _headCollectionView.delegate = self;
        _headCollectionView.dataSource = self;
        
        
    }
    return _headCollectionView;
}
-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
   
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(gdValue(45), gdValue(25));//每一个cell的大小
           layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
          
           layout.sectionInset = UIEdgeInsetsMake(0,gdValue(15), 0, gdValue(15));//四周的边距
           //设置最小边距
           layout.minimumLineSpacing = gdValue(10);
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, gdValue(55), SCREEN_WIDTH, gdValue(30)) collectionViewLayout:layout];
//        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
       
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"lcellId"];
        
     
        _mainCollectionView.showsHorizontalScrollIndicator=NO;
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
