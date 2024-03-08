//
//  addrestViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "addrestViewController.h"
#import "addrestTableViewCell.h"
#import "actShootView.h"
#import "newAddrestViewVC.h"
#import "noDataView.h"
#import "addreManreDB.h"
#import "addreModel.h"

@interface addrestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*setTableView;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,strong)NSMutableArray*dataArr;
@end

@implementation addrestViewController

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=getLocalStr(@"addreb");
    
    [self loadNui];
    [self loadUI];
    
//    [self getaddreData];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getaddreData];
    
}
-(void)getaddreData{
    
    
    [self.dataArr removeAllObjects];
    
    
    NSArray*usArr=[addreModel bg_findAll:bg_addresname];
    if(![Utility isBlankString:_iconname]){//转账进入
        
        for(addreModel*addmodl in usArr){
            if([addmodl.ChinaCode isEqualToString:_Chinaname]){
                [self.dataArr addObject:addmodl];
                
            }
        }
    }
    else{
        [self.dataArr addObjectsFromArray:usArr];
    }
    
   
    
    if(self.dataArr.count>0){
        self.noView.hidden=YES;
    }
    else{
        self.noView.hidden=NO;
    }
    
    [self.setTableView reloadData];
    
}
-(void)loadNui{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(36), WDNavHeight, gdValue(25), gdValue(25));
    [rBtn setImage:imageName(@"adrej") forState:UIControlStateNormal];
    [rBtn addTarget:self action:@selector(tjiaK) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navHeadView addSubview:rBtn];
}
-(void)tjiaK{
    newAddrestViewVC*ndVC=[[newAddrestViewVC alloc]init];
    [self.navigationController pushViewController:ndVC animated:YES];
    
    
}
-(void)loadUI{
    
    [self.view addSubview:self.setTableView];
    
    [self.view addSubview:self.noView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    addrestTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"adsetID" forIndexPath:indexPath];
    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
//    //添加长按手势
//        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
//
//        longPressGesture.minimumPressDuration=0.6f;//设置长按 时间
//    [cell addGestureRecognizer:longPressGesture];
        
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return gdValue(123);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return gdValue(10);
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
    vv.backgroundColor=cyColor;
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    if(![Utility isBlankString:_iconname]){
        addreModel*model=self.dataArr[indexPath.row];
        
    if([_delgate respondsToSelector:@selector(getAddrst:)]){
        [_delgate getAddrst:model.addreStr];
    }
    
    [self leftBarBtnClicked];
        
    }
    else{
        [self cellLongPress:indexPath.row];
        
    }
   
}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) imgstr:@"addno" tis:getLocalStr(@"zwdz")];
        _noView.backgroundColor=[UIColor whiteColor];
        _noView.hidden=YES;
    }
    
    return _noView;
}
-(UITableView*)setTableView{
    if(!_setTableView){
        _setTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStyleGrouped];
        _setTableView.dataSource=self;
        _setTableView.delegate=self;
        _setTableView.backgroundColor= cyColor;

        
       
        _setTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_setTableView registerClass:[addrestTableViewCell class] forCellReuseIdentifier:@"adsetID"];
        _setTableView.bounces=NO;
        _setTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _setTableView;
}
#pragma mark  长按点击
-(void)cellLongPress:(NSInteger)index{
//    CGPoint location = [longRecognizer locationInView:self.setTableView];
// NSIndexPath * indexPath = [self.setTableView indexPathForRowAtPoint:location];
 

 actShootView*view=[[actShootView alloc]initWithFrame:SCREEN_FRAME arr:@[@"addreb1",@"addreb2",@"watschu",@"waqux"] tis:@""];

 addreModel*model=self.dataArr[index];

 WeakSelf;
 view.getIndx = ^(NSInteger indx) {
     NSLog(@"a---%ld",indx);
     if(indx==0){
         [weakSelf fzckl:model.addreStr];
         
     }
     else if (indx==1){
         newAddrestViewVC*nvc=[[newAddrestViewVC alloc]init];
         nvc.addModel=model;
         nvc.type=1;
         [weakSelf.navigationController pushViewController:nvc animated:YES];
         
     }
     else if (indx==2){
         
//         
//         passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
//         
//         __block passdOCRView*passV=passView;
//         passView.getpass = ^(NSString * _Nonnull str) {
//             NSLog(@"sf--%@  %@",str,UserPassword);
//          
//             if([str isEqualToString:UserPassword]){
//   
//                 [passV hide];
                 [weakSelf.dataArr removeObject:model];
                 NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"creatimer"),bg_sqlValue(model.creatimer)];
                 [addreModel bg_delete:bg_addresname where:where];
        //
                 [weakSelf getaddreData];
                 [MBProgressHUD showText:getLocalStr(@"sccg")];
                 
//             }
//             else{
//                 [MBProgressHUD showText:getLocalStr(@"cwts1")];
//             }
//         };
         
         
         
         
     }
 } ;
 
 [view show];
 
}
//-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
//
//
//   if (longRecognizer.state==UIGestureRecognizerStateBegan) {
//     //成为第一响应者，需重写该方法
//       [self becomeFirstResponder];
//
//
////可以得到此时你点击的哪一行
//
//  //在此添加你想要完成的功能
//
//}
//
//}
-(void)fzckl:(NSString*)addre{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = addre;
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
