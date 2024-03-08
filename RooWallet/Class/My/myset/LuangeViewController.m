//
//  LuangeViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/19.
//

#import "LuangeViewController.h"

@interface LuangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,copy)NSArray*tiArr;

@end

@implementation LuangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseLab.text=getLocalStr(@"myd19");
                                  
    _tiArr=@[getLocalStr(@"myd20")];
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}
-(void)setUI{
    [self.view addSubview:self.mainTableview];
    
}
-(void)loadNui{
    
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(85), WDNavHeight, gdValue(70), gdValue(25));
    [rBtn setTitle:getLocalStr(@"wabcui") forState:UIControlStateNormal];
    [rBtn setTitleColor:zyincolor forState:UIControlStateNormal];
    rBtn.titleLabel.font=fontNum(16);
    rBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
 
    [rBtn addTarget:self action:@selector(tjiaKt) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navHeadView addSubview:rBtn];
}
-(void)tjiaKt{
    
}
#pragma mark --TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _tiArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"mysetID" forIndexPath:indexPath];
    
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
 
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(16), gdValue(200), gdValue(23))];
    tlab.text=_tiArr[indexPath.row];
    tlab.textColor=ziColor;
    tlab.font=fontNum(16);
    [cell.contentView addSubview:tlab];
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(55)-1, SCREEN_WIDTH-gdValue(30), 1)];
    col.backgroundColor=cyColor;
    [cell.contentView addSubview:col];
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(32), gdValue(19), gdValue(18),gdValue(18))];
    img.image=imageName(@"selemain");
    [cell.contentView addSubview:img];
    
    
    
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
  
    view.backgroundColor=[UIColor whiteColor];;
    
    
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(55);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
 
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=cyColor;
       
        [_mainTableview registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"mysetID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
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
