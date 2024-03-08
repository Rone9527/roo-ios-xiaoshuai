//
//  collecZJViewController.m
//  RooWallet
//
//  Created by mac on 2021/7/19.
//

#import "collecZJViewController.h"
#import "dappTableViewCell.h"
#import "dapptyModel.h"
#import "walletNodesModel.h"
#import "dappDetViewController.h"
#import "rooTishiView.h"

@interface collecZJViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,assign)BOOL isedit;
@property(nonatomic,strong)NSMutableArray*dataArr;

@end

@implementation collecZJViewController

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.dataArr addObjectsFromArray:self.scourArr];
    
    _isedit=NO;
    self.baseLab.text=getLocalStr(@"adm2");
    [self loadNui];
   

    [self.view addSubview:self.mainTableview];
    
    
    // Do any additional setup after loading the view.
}
-(void)loadNui{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(85), WDNavHeight, gdValue(70), gdValue(25));
    [rBtn setTitle:getLocalStr(@"addreb2") forState:UIControlStateNormal];
    [rBtn setTitle:getLocalStr(@"wabcui") forState:UIControlStateSelected];
    [rBtn setTitleColor:zyincolor forState:UIControlStateNormal];
    [rBtn setTitleColor:mainColor forState:UIControlStateSelected];
    rBtn.titleLabel.font=fontNum(16);
    rBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
   
    [rBtn addTarget:self action:@selector(tjia:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navHeadView addSubview:rBtn];
}
-(void)tjia:(UIButton*)sender{
    
    
    sender.selected=!sender.selected;
    _isedit=sender.selected;
//    self.mainTableview.editing=sender.selected;
    [self.mainTableview setEditing:_isedit animated:YES]; //使tableView进入编辑模式
    [self.mainTableview reloadData];
    
    if(!sender.selected){
       
     
        [self bcff];
     

    }
    
}
-(void)bcff{
    NSLog(@"s---保存");
    NSArray*sarr=[self.dataArr copy];
    sarr=[[sarr reverseObjectEnumerator] allObjects];

    [dapptyModel bg_clear:bg_cooletname];
    
    for(dapptyModel*mm in sarr){
        mm.bg_tableName=bg_cooletname;
        [mm bg_save];
    }
}

-(void)leftBarBtnClicked{
    if(_isedit){
        
        rooTishiView*view=[[rooTishiView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"是否放弃修改")];
        [view show];
        WeakSelf;
        view.block = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}
#pragma mark --TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    dappTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"dapID" forIndexPath:indexPath];
    
    cell.isEdit=_isedit;
    if(self.dataArr.count){
        cell.model=self.dataArr[indexPath.row];
       
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
    return view;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(70);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dapptyModel*model=self.dataArr[indexPath.row];
    model.addres=@"";
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
//    depVc.dappmodel=model;
//
//
//    [self.navigationController pushViewController:depVc animated:YES];
    
  
 
}
#pragma mark 点击删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"删除");
    
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if(!_isedit){
    [self bcff];
    }
    
}



// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return getLocalStr(@"watschu");
}


// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
//    NSLog(@"移动--%ld   f--%ld",sourceIndexPath.row,destinationIndexPath.row);
    dapptyModel*model=self.dataArr[sourceIndexPath.row];
    [self.dataArr removeObjectAtIndex:sourceIndexPath.row];
    [self.dataArr insertObject:model atIndex:destinationIndexPath.row];
//    [self.dataArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}

#pragma mark 选择编辑模式，添加模式很少用,默认是删除-
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;//UITableViewCellEditingStyleNone;
}
//#pragma mark 排序 当移动了某一行时候会调用//编辑状态下，只要实现这个方法，就能实现拖动排序
//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{    // 取出要拖动的模型数据
////    Goods *goods = _goodsAry[sourceIndexPath.row];    //删除之前行的数据
////    [_goodsAry removeObject:goods];    // 插入数据到新的位置
////    [_goodsAry insertObject:goods atIndex:destinationIndexPath.row];
//}






-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=cyColor;
       
        [_mainTableview registerClass:[dappTableViewCell  class] forCellReuseIdentifier:@"dapID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
//        _mainTableview.tableHeaderView=self.headView;
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
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
