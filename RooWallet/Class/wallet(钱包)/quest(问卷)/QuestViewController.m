//
//  QuestViewController.m
//  RooWallet
//
//  Created by mac on 2021/9/22.
//

#import "QuestViewController.h"
#import "MyQuestViewController.h"

@interface QuestViewController ()


@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseLab.text=getLocalStr(@"安全问卷");
    //
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(225))/2, WD_StatusHight+gdValue(60), gdValue(225), gdValue(176))];
    img.image=imageName(@"quest_t");
    [self.view addSubview:img];
    
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(42), img.bottom+gdValue(46), SCREEN_WIDTH-gdValue(84), gdValue(60))];
    lab.text=getLocalStr(@"为了避免新用户不了解去中心化钱包的运作机制，导致不必要的丢币与盗币事件。用户需要完成安全测试以便更好的使用roo。");
    lab.textColor=ziColor;
    lab.font=fontNum(15);
    lab.numberOfLines=0;
    [self.view addSubview:lab];
    [lab sizeToFit];
    
    UIButton*qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
     qdBtn.frame=CGRectMake(gdValue(35),SCREEN_HEIGHT-kTabbarSafeBottomMargin-gdValue(90), SCREEN_WIDTH-gdValue(70), gdValue(50));
     ViewRadius(qdBtn, gdValue(8));

     qdBtn.backgroundColor=mainColor;
     [qdBtn setTitle:getLocalStr(@"开始测试") forState:UIControlStateNormal];
     qdBtn.titleLabel.font=fontNum(16);
     [qdBtn addTarget:self action:@selector(qustCk) forControlEvents:UIControlEventTouchUpInside];
     [qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:qdBtn];
    
    // Do any additional setup after loading the view.
}
-(void)qustCk{
    
    MyQuestViewController*quVc=[[MyQuestViewController alloc]init];
    [quVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:quVc animated:YES];
    
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
