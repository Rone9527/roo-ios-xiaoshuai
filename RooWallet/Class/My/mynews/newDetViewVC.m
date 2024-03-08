//
//  newDetViewVC.m
//  RooWallet
//
//  Created by mac on 2021/8/18.
//

#import "newDetViewVC.h"
#import "neswModel.h"
@interface newDetViewVC ()
@property(nonatomic,strong)UIScrollView*scroView;
@property(nonatomic,strong)neswModel*model;
@property(nonatomic,strong)noDataView*noView;
@end

@implementation newDetViewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.baseLab.text=getLocalStr(@"详情");
    
    
    [MBProgressHUD showHUD];
    [self resq];
   
    
    
    // Do any additional setup after loading the view.
}
-(void)resq{
    
    
    NSString*url=[NSString stringWithFormat:@"%@/%@",messacgAPI,_nid];
//    NSLog(@"sd---%@",url);
    [Request GET:url  parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        NSLog(@"dic--%@",[Utility strData:responseObject]);
        
        NSDictionary*dat=responseObject[@"data"];
        [MBProgressHUD hideHUD];
        
        if(dat.count){
            
            self.model= [neswModel mj_objectWithKeyValues:dat];
                               
            [self setUI];
            
            NSArray*arr=[neswModel bg_findAll:bg_Newtpushname];
            
            for(neswModel *newm in arr){
                if([newm.id containsString:self.model.id]){
                    newm.isYdu=1;
                    [newm bg_saveOrUpdate];
                    return;
                }
            }
            
            
            
        }
        else{
            [self.view addSubview:self.noView];
            
        }
        
    
         
            
        
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"rr---%@",[error localizedDescription]);
        
        [MBProgressHUD hideHUD];
        
    }];
    
}
-(void)setUI{
    
    [self.view addSubview:self.scroView];
    
    UILabel*nalab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), SCREEN_WIDTH-gdValue(30), gdValue(60))];
    nalab.text=self.model.msgTitle;
    nalab.font=fontMidNum(18);
    nalab.textColor=ziColor;
    nalab.numberOfLines=2;
    [nalab sizeToFit];
    
    [self.scroView addSubview:nalab];
    
    
    UILabel*timlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(14)+nalab.bottom, SCREEN_WIDTH-gdValue(30), gdValue(20))];
    timlab.text=[Utility upTimeHHmm:self.model.publishTime geshi:@"yyyy年MM月dd日 HH:mm"];
    timlab.font=fontNum(14);
    timlab.textColor=zyincolor;
    
    [self.scroView addSubview:timlab];
    
    
    NSString*str=self.model.msgContent;
    
    CGFloat hig=[Utility heightForString:str fontSize:14 andWidth:SCREEN_WIDTH-gdValue(30)];
    
    UILabel*crtlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(17)+timlab.bottom, SCREEN_WIDTH-gdValue(30), hig)];
    crtlab.text=str;
    crtlab.font=fontNum(14);
    crtlab.textColor=ziColor;
    crtlab.numberOfLines=0;
    [crtlab sizeToFit];
    [self.scroView addSubview:crtlab];
    _scroView.contentSize=CGSizeMake(SCREEN_WIDTH, crtlab.bottom+gdValue(60));
    
    
}
-(UIScrollView*)scroView{
    if(!_scroView){
        _scroView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight)];
//        _scroView.contentSize=CGSizeMake(SCREEN_WIDTH*5, 0);
        _scroView.pagingEnabled=YES;
//        [_scroView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
//        _scroView.scrollEnabled=NO;
        _scroView.showsHorizontalScrollIndicator=NO;
//        _scroView.delegate=self;
        _scroView.bounces=NO;
        _scroView.backgroundColor=[UIColor whiteColor];
     
    }
    return _scroView;
}

-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight)imgstr:@"nesno" tis:getLocalStr(@"哦哦，页面飞走了...")];
        
    }
    
    return _noView;
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
