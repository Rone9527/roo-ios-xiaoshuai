//
//  TradDetViewController.m
//  RooWallet
//
//  Created by mac on 2021/7/29.
//

#import "TradDetViewController.h"
#import "tradetModel.h"
#import "h5ViewController.h"
@interface TradDetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)UIView*fotView;
@property(nonatomic,strong)UILabel*detLab;
@property(nonatomic,strong)UILabel*markLab;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,assign)CGFloat detHig;
@property(nonatomic,assign)CGFloat markHig;
@property(nonatomic,copy)NSString*detail;
@property(nonatomic,copy)NSString*totalSupply;

@end
//getResourAPI
@implementation TradDetViewController

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=[NSString stringWithFormat:@"%@%@",_symodel.symbol,getLocalStr(@"资产介绍")];
    
    [self setUI];
    
    [MBProgressHUD showHUD];
    [self getReqData];
    
    
    // Do any additional setup after loading the view.
}
-(void)setUI{
    
    [self.view addSubview:self.noView];
    
//    [self.view addSubview:self.setTableView];
    
}
-(void)getReqData{
    
    NSDictionary*dic;
    
    if([Utility isBlankString:_symodel.contractId]){
        dic=@{@"chainCode":_symodel.chainCode,@"contractId":@"0x0000000000000000000000000000000000000000"};
        
    }
    else{
        dic=@{@"chainCode":_symodel.chainCode,@"contractId":_symodel.contractId};
    }
    
    [Request GET:getResourAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"dsta--%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
          NSDictionary*dadic=responseObject[@"data"];
            
            
            if(dadic.count){
                
                tradetModel*model=[tradetModel mj_objectWithKeyValues:dadic];
                
                [self.dataArr addObjectsFromArray:model.resources];
                self.detail=model.detail;
                self.totalSupply=model.totalSupply;
                
                
             
                self.detHig=[Utility heightForString:self.detail fontSize:15 andWidth:SCREEN_WIDTH-gdValue(30)]+gdValue(20);
                
                
              self.markHig=[Utility heightForString:self.totalSupply fontSize:16 andWidth:gdValue(230)];
                
                if(self.markHig<gdValue(23)){
                    
                    self.markHig=gdValue(23);
                }
                
                
                self.noView.hidden=YES;
                [self.view addSubview:self.setTableView];
                
              
            }
            
        }
        
        
            [MBProgressHUD hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"tardDetID" forIndexPath:indexPath];

    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if(self.dataArr.count){
        tradetGFModel*model =self.dataArr[indexPath.row];
        
        UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(18), gdValue(24), gdValue(24))];
        img.image=imageName(model.icon);
        [cell.contentView addSubview:img];
        
        UILabel*namelab=[[UILabel alloc]initWithFrame:CGRectMake(img.right+gdValue(10), gdValue(18), gdValue(200), gdValue(24))];
        namelab.text=model.name;
        namelab.textColor=ziColor;
        namelab.font=fontNum(16);
        [cell.contentView addSubview:namelab];
        
        UIImageView*rimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(21), gdValue(24), gdValue(6), gdValue(12))];
        rimg.image=imageName(@"dlad");
        [cell.contentView addSubview:rimg];
        
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(60)-0.7, SCREEN_WIDTH-gdValue(30), 0.7)];
        col.backgroundColor=cyColor;
        [cell.contentView  addSubview:col];
        
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(60);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    if(self.dataArr.count){
    return gdValue(55);
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    
 
    
    return vv;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    
    for(UIView*vc in vv.subviews){
        [vc removeFromSuperview];
    }
    
    if(self.dataArr.count){
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, gdValue(10))];
    col.backgroundColor=cyColor;
    [vv addSubview:col];
    
    UILabel*heyLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), col.bottom+gdValue(14), gdValue(100), gdValue(20))];
    heyLab.text=getLocalStr(@"资源");
    heyLab.font=fontNum(14);
    heyLab.textColor=zyincolor;
    [vv addSubview:heyLab];
    }
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    tradetGFModel*model=self.dataArr[indexPath.row];
    h5ViewController*vc=[[h5ViewController alloc]init];
    vc.url= model.url;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= [UIColor whiteColor];

        _setTableView.tableHeaderView=self.headView;
        _setTableView.tableFooterView=self.fotView;
        
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tardDetID"];
//        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) imgstr:@"nodata" tis:getLocalStr(@"暂无数据")];
        _noView.backgroundColor=[UIColor whiteColor];
//        _noView.hidden= NO;
    }
    
    return _noView;
}
-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]init];//145
        _headView.backgroundColor=[UIColor whiteColor];
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        col.backgroundColor=cyColor;
        [_headView addSubview:col];
        
        CGFloat flg=gdValue(15);
        _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH,gdValue(55)+self.detHig);
        
        if(![Utility isBlankString:_symodel.contractId]){//110
            
            if(self.detHig>gdValue(20)){
                _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, gdValue(120)+gdValue(30)+self.detHig);
            }
            else{
                _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, gdValue(80));
            }
        UILabel*heyLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), col.bottom+gdValue(14), gdValue(100), gdValue(20))];
        heyLab.text=getLocalStr(@"合约地址");
        heyLab.font=fontNum(14);
        heyLab.textColor=zyincolor;
        [_headView addSubview:heyLab];
        
        UILabel*heAddLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), heyLab.bottom+gdValue(10), SCREEN_WIDTH-gdValue(67), gdValue(23))];
  
            heAddLab.text=_symodel.contractId;
        
        
        heAddLab.textColor=ziColor;
        heAddLab.font=fontNum(16);
        heAddLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        [_headView addSubview:heAddLab];
        
        UIButton*fzBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        fzBtn.frame=CGRectMake(heAddLab.right+gdValue(10), heyLab.bottom+gdValue(5), gdValue(33), gdValue(33));
        [fzBtn setImage:imageName(@"sybfz") forState:UIControlStateNormal];
            [fzBtn addTarget:self action:@selector(fzckl) forControlEvents:UIControlEventTouchUpInside];
            
        [_headView addSubview:fzBtn];
        
//        fzBtn.backgroundColor=[UIColor redColor];
        
        UIView*col1=[[UIView alloc]initWithFrame:CGRectMake(0, heyLab.bottom+gdValue(50), SCREEN_WIDTH, gdValue(10))];
        col1.backgroundColor=cyColor;
            [_headView addSubview:col1];
            flg=col1.bottom+gdValue(14);
        }
        
        
//        NSLog(@"sd---%f",self.detHig);
        
        if(self.detHig>gdValue(20)){
            
        UILabel*heyLab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), flg, gdValue(200), gdValue(20))];
        heyLab1.text=[NSString stringWithFormat:@"%@%@",getLocalStr(@"关于"),_symodel.symbol];
        heyLab1.font=fontNum(14);
        heyLab1.textColor=zyincolor;
        [_headView addSubview:heyLab1];
        
            
        _detLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), heyLab1.bottom+gdValue(5), SCREEN_WIDTH-gdValue(30), self.detHig)];
        _detLab.text=self.detail;
        _detLab.font=fontNum(16);
        _detLab.textColor=ziColor;
        _detLab.numberOfLines=0;
        [_headView addSubview:_detLab];
            
            
            
        }
        
       
        
    }
    return _headView;
}

-(UIView*)fotView{
    if(!_fotView){
        _fotView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(160))];
        
        _fotView.backgroundColor=[UIColor whiteColor];
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(10))];
        col.backgroundColor=cyColor;
        [_fotView addSubview:col];
        
        
        UILabel*heyLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), col.bottom+gdValue(14), gdValue(100), gdValue(20))];
        heyLab.text=getLocalStr(@"Markent");
        heyLab.font=fontNum(14);
        heyLab.textColor=zyincolor;
        [_fotView addSubview:heyLab];
        
        UILabel*heyLab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), heyLab.bottom+gdValue(10), gdValue(85), gdValue(23))];
        heyLab1.text=getLocalStr(@"总发行量");
        heyLab1.font=fontNum(16);
        heyLab1.textColor=ziColor;
        [_fotView addSubview:heyLab1];
        
        _markLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(245), heyLab1.y, gdValue(230), self.markHig)];
        _markLab.text=_totalSupply;
        _markLab.font=fontNum(16);
        _markLab.textColor=ziColor;
        _markLab.numberOfLines=2;
        _markLab.textAlignment=NSTextAlignmentRight;
        [_fotView addSubview:_markLab];
        
        
    }
    return _fotView;
}

-(void)fzckl{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = _symodel.contractId;
       if (pab == nil) {
         
       } else {
           [MBProgressHUD showText:getLocalStr(@"addreb3")];
       }

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
