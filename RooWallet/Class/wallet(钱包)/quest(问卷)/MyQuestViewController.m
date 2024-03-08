//
//  MyQuestViewController.m
//  RooWallet
//
//  Created by mac on 2021/9/22.
//

#import "MyQuestViewController.h"
#import "questTSView.h"
#import "questModel.h"
@interface MyQuestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,strong)NSMutableArray*dataArr;

@property(nonatomic,strong)NSMutableArray*seleArr;
@property(nonatomic,strong)NSMutableArray*anseArr;
@property(nonatomic,strong)UIButton* qdBtn;
@property(nonatomic,assign)BOOL isUp;


@end

@implementation MyQuestViewController
-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray*)anseArr{
    if(!_anseArr){
        _anseArr=[NSMutableArray array];
    }
    return _anseArr;
}
-(NSMutableArray*)seleArr{
    if(!_seleArr){
        _seleArr=[NSMutableArray array];
    }
    return _seleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
  
    
    _isUp=NO;
    
 
  
    
    self.baseLab.text=getLocalStr(@"安全问卷");
    
    [self.view addSubview:self.mainTableview];
    
    [self.view addSubview:self.qdBtn];
    
    [MBProgressHUD showHUD];
    [self getDatarest];
    
    
    // Do any additional setup after loading the view.
}
-(void)getDatarest{
    
    [Request GET:getquestionAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
//        NSLog(@"data--%@",[Utility strData:responseObject]);

        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            NSArray*arr=responseObject[@"data"];
            
            
            for(NSDictionary*dic in arr){
                questModel*model=[questModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                [self.seleArr addObject:@""];
                [self.anseArr addObject:model.answer[0]];
                
            }
            
        }
        
        [self.mainTableview reloadData];
        
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
    
}//getquestionAPI
#pragma mark --TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    questModel*model=self.dataArr[section];
    
    
    return  model.options.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"mysetID" forIndexPath:indexPath];
    
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor=[UIColor whiteColor];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if(self.dataArr.count){
        questModel*model=self.dataArr[indexPath.section];
        
    UIImageView*rimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(13), gdValue(14), gdValue(14))];
    rimg.image=imageName(@"qus_1");
    [cell.contentView addSubview:rimg];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(rimg.right+gdValue(10), gdValue(10), SCREEN_WIDTH-gdValue(55), cell.height-gdValue(20))];
        optionModel*mdl=model.options[indexPath.row];
    tlab.text=mdl.option;
    tlab.font=fontNum(14);
    tlab.textColor=ziColor;
    tlab.numberOfLines=0;
    [tlab sizeToFit];
    
    if([self.seleArr containsObject:indexPath]){
        
        if(self.isUp){//点击了提交
            if(indexPath.row==[model.answer[0] integerValue]){//回答对
                rimg.image=imageName(@"qus_2");
                tlab.textColor=mainColor;
            }
            else{//回答错
                
                rimg.image=imageName(@"qus_3");
                tlab.textColor=UIColorFromRGB(0xFA4400);
                
            }
           
        }
        else{//答题模式
            rimg.image=imageName(@"qus_2");
        }
        
        
        
    }
    else{
        
        if(self.isUp){//点击了提交，错误显示正确的答案
            
            if(indexPath.row==[model.answer[0] integerValue]){
                rimg.image=imageName(@"qus_4");
                tlab.textColor=mainColor;
                
                }
          
        }
    }
    [cell.contentView addSubview:tlab];
    
    
    }
   
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    CGFloat hig=0.0;
    
    if(self.dataArr.count>0){
        questModel*model=self.dataArr[section];
        
       hig=[Utility heightForString:model.question fontSize:16 andWidth:SCREEN_WIDTH-gdValue(30)];
        if(hig<gdValue(20)){
            hig=gdValue(20);
        }
    }

    return gdValue(20)+hig;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];
    
    return view;;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];
    
    for(UIView*vv in view.subviews){
        [vv removeFromSuperview];
        
    }
    if(self.dataArr.count){
        questModel*model=self.dataArr[section];
        CGFloat hig=0.0;
        
       
            
           hig=[Utility heightForString:model.question fontSize:16 andWidth:SCREEN_WIDTH-gdValue(30)];
            if(hig<gdValue(20)){
                hig=gdValue(20);
            }
        

    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10), SCREEN_WIDTH-gdValue(30), hig)];
        lab.text=[NSString stringWithFormat:@"%ld.%@",section+1,model.question];
        
    lab.font=fontNum(16);
    lab.numberOfLines=0;
        
    lab.textColor=ziColor;
    [view addSubview:lab];
        
    }
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CGFloat hig=0.0;

    if(self.dataArr.count>0){
        questModel*model=self.dataArr[indexPath.section];
        optionModel*mdl=model.options[indexPath.row];
        
       hig=[Utility heightForString:mdl.option fontSize:14 andWidth:SCREEN_WIDTH-gdValue(55)];
        if(hig<gdValue(20)){
            hig=gdValue(20);
        }
    }

    return gdValue(20)+hig;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
 
    [self.seleArr replaceObjectAtIndex:indexPath.section withObject:indexPath];
    
    
    [self.seleArr enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        NSLog(@"sdsd--%@",obj);
        if(![obj isKindOfClass:[NSIndexPath class]]){
            self.qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
            self.qdBtn.enabled=NO;
            
            *stop=YES;
            return;
        }
      
       
        
        if(idx==self.seleArr.count-1){
            self.qdBtn.backgroundColor=mainColor;
            self.qdBtn.enabled=YES;
        }
        
    }];
    
   
    
        [self.mainTableview reloadData];
    
    
    
 
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight-kTabbarSafeBottomMargin-gdValue(100)) style:UITableViewStyleGrouped];
        
        _mainTableview.backgroundColor=[UIColor whiteColor];
       
        [_mainTableview registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"mysetID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
        
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35),SCREEN_HEIGHT-kTabbarSafeBottomMargin-gdValue(90), SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _qdBtn.enabled=NO;
        [  _qdBtn setTitle:getLocalStr(@"提交答案") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [ _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [ _qdBtn addTarget:self action:@selector(quqdCk) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return   _qdBtn;
}
-(void)quqdCk{
    
    
    [self.seleArr enumerateObjectsUsingBlock:^(NSIndexPath* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        if(obj.row !=[self.anseArr[idx]integerValue]){
            
            self.isUp=YES;
            [self.mainTableview reloadData];
            
            [MBProgressHUD showText:getLocalStr(@"答案错误，请重新选择哦")];
            
            *stop=YES;
            return;
        }
        
        if(idx==self.seleArr.count-1){
            questTSView*view=[[questTSView alloc]initWithFrame:SCREEN_FRAME];
            [view show];
            
            WeakSelf;
            view.block = ^{
                
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isQuest"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            };
        }
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
