//
//  jysMarkView.m
//  RooWallet
//
//  Created by mac on 2021/8/2.
//

#import "jysMarkView.h"
#import "YASimpleGraphView.h"
#import "hqmarmodel.h"
#import "coinsModel.h"
#import "ratesModel.h"


@interface jysMarkView()<YASimpleGraphDelegate>
 @property(nonatomic,strong) NSMutableArray *allValues;
@property(nonatomic,strong) NSMutableArray *allDates;
@property(nonatomic,strong) NSMutableArray *tewAlldata;
@property(nonatomic,copy)NSString*namestr;
@property(nonatomic,strong)YASimpleGraphView *graphView;
@property(nonatomic,copy)NSString*comb;

@property(nonatomic,strong)noDataView*noView;
@end

@implementation jysMarkView
-(NSMutableArray*)allDates{
    if(!_allDates){
        _allDates=[NSMutableArray array];
    }
    return _allDates;
}
-(NSMutableArray*)tewAlldata{
    if(!_tewAlldata){
        _tewAlldata=[NSMutableArray array];
    }
    return _tewAlldata;
}

-(NSMutableArray*)allValues{
    if(!_allValues){
        _allValues=[NSMutableArray array];
    }
    return _allValues;
}
- (instancetype)initWithFrame:(CGRect)frame defi:(NSString*)ascription conid:(NSString*)conid{
   
   self = [super initWithFrame:frame];
   if (self) {
    
     
    
       
       [self defiData:ascription comid:conid];
       
       
   }

   return self;
}
- (instancetype)initWithFrame:(CGRect)frame baseAsset:(NSString*)namestr{
   
   self = [super initWithFrame:frame];
   if (self) {
    
       _namestr=namestr;
      
     
    
       
       [self reqsData];
       
       
   }

   return self;
}

-(void)setUI{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.33, 0.67, 0.93, 0.25,
        1.0, 1.0, 1.0, 1.0
    };
    
   _graphView = [[YASimpleGraphView alloc]init];
    _graphView.frame = self.bounds;
    _graphView.backgroundColor = [UIColor whiteColor];
//
    _graphView.defaultShowIndex = _allDates.count-1;
    _graphView.delegate = self;
    _graphView.lineColor =mainColor;
    _graphView.lineWidth = 1;
    _graphView.lineAlpha = 1.0;
//    graphView.enableTouchLine = YES;
    
    
   _graphView.allValues = self.allValues;
    _graphView.allDates = self.allDates;
       
    
//    graphView.topAlpha = 1.0;
//    graphView.topColor = [UIColor orangeColor];
//    graphView.topGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    
    _graphView.bottomAlpha = 1.0;

    _graphView.bottomColor=mainColor;
    _graphView.bottomGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    [self addSubview:_graphView];
    [_graphView startDraw];
}

#pragma mark defikline

-(void)defiData:(NSString*)astr comid:(NSString*)conid{
    
    
    NSDictionary*dic=@{@"ascription":astr,@"id":conid};
    [Request GET:defplichartAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"dattt---%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
          NSArray*arr=responseObject[@"data"];
            
            if(arr.count>2){
            for(NSDictionary*dict in arr){
                
                
                hqmarmodel*model=[hqmarmodel mj_objectWithKeyValues:dict];
                
//
                
                [self.allValues addObject:model.price];
                
                [self.allDates addObject:[Utility upTimeHHmm:model.timestamp geshi:@"HH:mm"]];
           
                
            }
            
        
        if(self.allValues.count){
            [self gettwvoid];
            [self setUI];
       
        }
        }
            else{
                
//                [self addSubview:self.noView];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noKline" object:nil];
                
            }
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, gdValue(10), self.width,self.height-gdValue(10))imgstr:@"nodata" tis:@""];
       
    }
    
    return _noView;
}
#pragma mark 代币kline
-(void)reqsData{
    
    NSDictionary*dic=@{@"baseAsset":_namestr};
    
    [Request GET:getKlinAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
        
//        NSLog(@"baser---%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
          NSArray*arr=responseObject[@"data"];
            
//            coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
//            ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
//
//            self.comb=cmod.icon;
            
//            NSDictionary*dc=[rmod mj_keyValues];//汇率
//
//            NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
//
//            NSMutableArray*aty=[NSMutableArray array];
            
                
                for(NSDictionary*dict in arr){
                    
                    
                    hqmarmodel*model=[hqmarmodel mj_objectWithKeyValues:dict];
                    
//                    NSString*atr=[NSString stringWithFormat:@"%f",[model.closePrice doubleValue]*[tare doubleValue]];
//
//                    NSString*price=[NSString stringWithFormat:@"%@",[Utility douVale:atr num:2]];
//
                    
                    
                    [self.allValues addObject:model.closePrice];
                    
                    [self.allDates addObject:[Utility upTimeHHmm:model.time geshi:@"HH:mm"]];
               
                    
                }
                
            
            if(self.allValues.count){
                
                [self gettwvoid];
            
                [self setUI];
                
           
            }
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)gettwvoid{
    
    [self.tewAlldata removeAllObjects];
    

    [self.allValues enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString*srt=@"0.0";
//        NSLog(@"sdsd--%@",obj);
        if([obj doubleValue]>=1){
           srt=[NSString stringWithFormat:@"%.2f",[obj doubleValue]];
            
//            NSLog(@"sdsdds---%@",srt);
        }
        else {
            
            NSString*testNumber=[[obj componentsSeparatedByString:@"."]lastObject];
            NSString * s = nil;
            NSInteger offset = 0;
            NSInteger cout = 0;
            for(int i=0;i<testNumber.length;i++){
                s = [testNumber substringWithRange:NSMakeRange(i, 1)];
                if([s intValue]==0){
                    offset++;
                }
                else{
                    
                    if(cout==2){
                        
                        
                        break;;
                    }
                    else{
                        offset++;
                        cout++;
                    }
                }
            }
            
          srt = [testNumber substringToIndex:offset];
            
            srt=[NSString stringWithFormat:@"%@.%@",[[obj componentsSeparatedByString:@"."]firstObject],srt];
            //
        }
//        NSLog(@"sdsdds2---%@",srt);
        [self.tewAlldata addObject:srt];
        
            
    }];
    
//    NSLog(@"sd---%ld",self.tewAlldata.count);
    
}

//自定义X轴 显示标签索引
- (NSArray *)incrementPositionsForXAxisOnLineGraph:(YASimpleGraphView *)graph {
    return self.allDates;
}

//Y轴坐标点数
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(YASimpleGraphView *)graph {
    return 5;
}

//自定义popUpView
- (UIView *)popUpViewForLineGraph:(YASimpleGraphView *)graph {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.backgroundColor =[cyColor colorWithAlphaComponent:1.0];//[UIColor colorWithRed:146/255.0 green:191/255.0 blue:239/255.0 alpha:1];
    label.numberOfLines = 0;
    ViewBorderRadius(label, 7, 1,[UIColor whiteColor]);
    label.alpha=1.0;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
   
    
    return label;
}

//修改相应点位弹出视图
- (void)lineGraph:(YASimpleGraphView *)graph modifyPopupView:(UIView *)popupView forIndex:(NSUInteger)index {
    UILabel *label = (UILabel*)popupView;
    NSString *date = [NSString stringWithFormat:@"%@",_allDates[index]];
    
    
    
    NSString *str = [NSString stringWithFormat:@" %@ \n %@%@",date,@"$",self.tewAlldata[index]];
    
//    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 86) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    [label setFrame:CGRectMake(0, 0, 86, 45)];
    label.alpha=1.0;
    label.textColor =ziColor;
    label.text = str;
   
    [graph bringSubviewToFront:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
