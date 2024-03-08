//
//  authFreeView.m
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import "authFreeView.h"
#import "tranCollectionViewCell.h"
#import "BaseTextField.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "TraGasmodel.h"

@interface authFreeView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UILabel*kfreeLab;
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,copy)NSArray*tsArr;
@property(nonatomic,copy)NSArray*timeArr;
@property(nonatomic,assign)NSInteger sedeIndx;
@property(nonatomic,assign)NSInteger sedeIndxx;
@property(nonatomic,strong)UIButton*zdyBtn;

@property(nonatomic,strong)UIButton*qdBtn;
@property(nonatomic,strong)UIView*fotView;
@property(nonatomic,strong)BaseTextField*gasprTextf;
@property(nonatomic,strong)BaseTextField*gasnumTextf;
@property(nonatomic,copy)NSString * outNumber;//手续费
@property(nonatomic,copy)NSString * codefBer;//可用主币

@property(nonatomic,copy)NSString*codeDecimals;//主币位数
@property(nonatomic,copy)NSString*codeprice;//主币价格

@property(nonatomic,strong)UIScrollView*scroView;

@property(nonatomic,copy)NSString*gasLimt;
@property(nonatomic,strong)NSMutableArray*gasArr;//gas数据

@property(nonatomic,copy)NSString*codr;
@property(nonatomic,copy)NSString*chaid;

@end

@implementation authFreeView
-(UIScrollView*)scroView{
    if(!_scroView){
        _scroView=[[UIScrollView alloc]initWithFrame:_sheetView.bounds];
        _scroView.backgroundColor=UIColorFromRGB(0xffffff);
        _scroView.showsHorizontalScrollIndicator=NO;
        _scroView.showsVerticalScrollIndicator=NO;
        
    }
    return _scroView;
}
-(NSMutableArray*)gasArr{
    if(!_gasArr){
        _gasArr=[NSMutableArray array];
    }
    return _gasArr;
}
- (instancetype)initWithFrame:(CGRect)frame code:(NSString*)codestr  gslit:(nonnull NSString *)gaslimt chaid:(nonnull NSString *)chaid{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _codr=codestr;
        _chaid=chaid;
        self.gasLimt=gaslimt;
        _sedeIndx=1;
        _sedeIndxx=1;
        _higt=gdValue(485);
        
        _timeArr=@[@"0.5",@"5",@"10"];
        _tsArr=@[getLocalStr(@"trawrt6"),getLocalStr(@"trawrt7"),getLocalStr(@"trawrt8")];
        [self setUI];
        
        [self getGasData];
        
    }
 
    return self;
}

#pragma mark 获取gas费用
-(void)getGasData{
    
    NSDictionary*dic=@{@"chain":_codr};
    
        NSLog(@"dic--%@",dic);
    [MBProgressHUD showHUD];
    
    [Request GET:getGasAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//                NSLog(@"ffooo----%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            TraGasmodel*gasmodel=[TraGasmodel mj_objectWithKeyValues:responseObject[@"data"]];
//            self.gasLimt=gasmodel.gasLimit;
            [self.gasArr addObject:gasmodel.fastGasPrice];
            [self.gasArr addObject:gasmodel.proposeGasPrice];
            [self.gasArr addObject:gasmodel.safeGasPrice];
            self.gasprTextf.text=self.gasArr[1];
            self.gasnumTextf.text=self.gasLimt;
            [self.mainCollectionView reloadData];
            
            [self getGasLimt:self.gasLimt gas:gasmodel.proposeGasPrice];
            
        }
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        [self getGasData];
        NSLog(@"error --%@",[error localizedDescription]);
        [MBProgressHUD hideHUD];
        
    }];
    
}


-(void)setUI{
    
    self.frame=SCREEN_FRAME;
//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
    [self addGestureRecognizer:tap];
////
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-_higt, SCREEN_WIDTH, _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sheetView.bounds;
           maskLayer.path = maskPath.CGPath;
    sheetView.layer.mask = maskLayer;
    
    [sheetView addSubview:self.scroView];
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
    naLab.text=getLocalStr(@"dapts18");
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [self.scroView addSubview:naLab];
    
    UIButton*gbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gbBtn.frame=CGRectMake(gdValue(18),gdValue(13), gdValue(30), gdValue(30));
    [gbBtn setImage:imageName(@"autleft") forState:UIControlStateNormal];
//        gbBtn.backgroundColor=[UIColor redColor];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
    [gbBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.scroView  addSubview:gbBtn];
    

    
  
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), naLab.bottom+gdValue(25),gdValue(60), gdValue(24))];
    tlab.text=getLocalStr(@"dapts13");
    tlab.font=fontNum(16);
    tlab.textColor=ziColor;
  
    [self.scroView addSubview:tlab];
    [self.scroView addSubview:self.kfreeLab];
    
    
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), tlab.bottom+gdValue(8), SCREEN_WIDTH-gdValue(30), 1)];
    col.backgroundColor=cyColor;
    [self.scroView addSubview:col];
    
    
    [self.scroView addSubview:self.mainCollectionView];
    [self.scroView addSubview:self.zdyBtn];
    [self.scroView addSubview:self.qdBtn];
    [self.scroView addSubview:self.fotView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShoww:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidee:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShoww:(NSNotification *)notification {
     
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
  
//            NSLog(@"3秒后执行这个方法");
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.sheetView.frame = CGRectMake(0.0f, SCREEN_HEIGHT-offset-self->_higt, self.sheetView.frame.size.width, self.sheetView.frame.size.height);
            }];
        }
//        });
    
   
   
}
#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHidee:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.sheetView.frame = CGRectMake(0,SCREEN_HEIGHT-self.higt, self.sheetView.frame.size.width, self.sheetView.frame.size.height);
    }];
}

-(UILabel*)kfreeLab{
    if(!_kfreeLab){
        _kfreeLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(215), gdValue(63), gdValue(200), gdValue(24))];
        _kfreeLab.text=@"----";
        _kfreeLab.font=fontBoldNum(20);
        _kfreeLab.textColor=ziColor;
        _kfreeLab.textAlignment=NSTextAlignmentRight;
        
    }
    return _kfreeLab;
}
-(UIButton*)zdyBtn{
    if(!_zdyBtn){
        _zdyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _zdyBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(85), _mainCollectionView.bottom+gdValue(15), gdValue(70), gdValue(30));
        
        [_zdyBtn setTitle:getLocalStr(@"trawrt9") forState:UIControlStateNormal];
        [_zdyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        _zdyBtn.titleLabel.font=fontNum(14);
        [_zdyBtn setImage:imageName(@"zdyN") forState:UIControlStateNormal];
        [_zdyBtn addTarget:self action:@selector(szdyCk:) forControlEvents:UIControlEventTouchUpInside];
        
        [_zdyBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(5)];
        
    }
    return _zdyBtn;
}
-(UIView*)fotView{
    if(!_fotView){
        _fotView=[[UIView alloc]initWithFrame:CGRectMake(0, _zdyBtn.bottom+gdValue(18), SCREEN_WIDTH, gdValue(130))];
        _fotView.backgroundColor=[UIColor whiteColor];
        _fotView.hidden=YES;
        [_fotView addSubview:self.gasprTextf];
        [_fotView addSubview:self.gasnumTextf];
    }
    return _fotView;
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35), _higt-gdValue(74), SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=mainColor;//UIColorFromRGB(0xD1DAF5);
//        _qdBtn.enabled=NO;
        [  _qdBtn setTitle:getLocalStr(@"dapts6") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [  _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [  _qdBtn addTarget:self action:@selector(tjiaoClk) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return   _qdBtn;
}
-(BaseTextField*)gasprTextf{
    if(!_gasprTextf){
        _gasprTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15),0, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_gasprTextf, gdValue(6));
        _gasprTextf.backgroundColor=cyColor;
        
        _gasprTextf.placeholder=@"Gas Price";
        _gasprTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Gas Price" attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _gasprTextf.font
                                          }];
        _gasprTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _gasprTextf.leftView=lefv;
        _gasprTextf.leftViewMode=UITextFieldViewModeAlways;
        
        
        UIView*rihtv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        rihtv.backgroundColor=cyColor;
        _gasprTextf.rightView=rihtv;
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(55))];
        lab.text=@"Gwei";
//        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=fontMidNum(16);
        lab.textColor=zyincolor;
        [rihtv addSubview:lab];
        _gasprTextf.rightViewMode=UITextFieldViewModeAlways;
        
        
        _gasprTextf.keyboardType=UIKeyboardTypeDecimalPad;
        [_gasprTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    return _gasprTextf;
}
-(BaseTextField*)gasnumTextf{
    if(!_gasnumTextf){
        _gasnumTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(15)+_gasprTextf.bottom, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_gasnumTextf, gdValue(6));
        _gasnumTextf.backgroundColor=cyColor;
        
        _gasnumTextf.placeholder=@"Gas";
        _gasnumTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Gas" attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _gasnumTextf.font
                                          }];
        _gasnumTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _gasnumTextf.leftView=lefv;
        _gasnumTextf.leftViewMode=UITextFieldViewModeAlways;
        _gasnumTextf.keyboardType=UIKeyboardTypeDecimalPad;
        [_gasnumTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    return _gasnumTextf;
}
#pragma mark --编辑
-(void)limitStringt:(UITextField *)textField
{
    UITextField *myTextField = (UITextField *)textField;
    NSString *toBeString = myTextField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 200)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:200];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:200];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
        else{
            
           if (textField==self.gasprTextf||textField==self.gasnumTextf){
               
               if([self.gasprTextf.text floatValue]>12000000){
                   self.gasprTextf.text=@"12000000";
               }
               
               
               if(self.gasprTextf.text.length>0&&self.gasnumTextf.text.length>0){
                   _qdBtn.backgroundColor=mainColor;
                                   _qdBtn.enabled=YES;
               }
               else{
                   _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
                                  _qdBtn.enabled=NO;
               }
                if(self.gasprTextf.text.length>0&&self.gasnumTextf.text.length>0){
                    [self getGasLimt:self.gasnumTextf.text gas:self.gasprTextf.text];
                }
            }
            
//            if(self.addTextf.text.length>0&&self.numTextf.text.length>0&&(_sedeIndx<3||(self.gasprTextf.text.length>0&&self.gasnumTextf.text.length>0))){
//                _qdBtn.backgroundColor=mainColor;
//                _qdBtn.enabled=YES;
//
//            }
//            else{
//                _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
//                _qdBtn.enabled=NO;
//            }
        }
        
        
        
    }
}

-(NSString*)removeFloatAllZero:(NSString*)string

{
    
  
    
    NSString * testNumber = string;
    
    NSString * s = nil;
    
    NSInteger offset = testNumber.length - 1;
    
    while (offset)
        
    {
        
        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
        
        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
            
        {
            
            offset--;
            
        }
        
        else
            
        {
            
            break;
            
        }
        
    }
    
    NSString * outNumber = [testNumber substringToIndex:offset+1];
    

    
    return outNumber;
}

#pragma mark 获取矿工费
-(void)getGasLimt:(NSString*)gsalit gas:(NSString*)gas{
    
    double nump=[gsalit doubleValue]*[gas doubleValue];
    nump=nump/pow(10, 9);
    
    NSString*numStr=[NSString stringWithFormat:@"%f",nump];
    
    _outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
//    NSLog(@"sd1---%@",_outNumber);
    
    _outNumber = [self removeFloatAllZero:_outNumber];
//    NSLog(@"sd2---%@",_outNumber);
    
    _kfreeLab.text=[NSString stringWithFormat:@"%@ %@",_outNumber,_chaid];
    
}
-(NSString*)getALLPrice:(NSString*)num{
    
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
//    if([_symodel.symbol isEqualToString:@"USDT"]){
//        self.codeprice=@"1";
//        self.codeDecimals=@"4";
//
//    }
    
    
    //总价=价格*数量
    NSString*atrr=[NSString stringWithFormat:@"%f",[self.codeprice doubleValue]*[tare doubleValue]*[num doubleValue]];
    
    NSString*allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[self removeFloatAllZero:[Utility douVale:atrr num:[self.codeDecimals intValue]]]];//总价
    
    return allPrc;
}

#pragma mark --提交
-(void)tjiaoClk{
    NSString*gas;
    NSString*gaslimt;
    if(self.zdyBtn.selected){
        gas= self.gasprTextf.text ;
        gaslimt= self.gasnumTextf.text  ;
        
    }
    else{
        gas= self.gasArr[_sedeIndx];
        gaslimt= self.gasLimt;
    }
    
    if(self.block){
        self.block(gas, gaslimt,self.kfreeLab.text);
    }
    
    [self hide];
    
    
}
#pragma mark --自定义点击
-(void)szdyCk:(UIButton*)sender{
    
    WeakSelf;
    sender.selected=!sender.selected;
    
    
    if (sender.selected) {//显示
        
        weakSelf.gasprTextf.text=weakSelf.gasArr[weakSelf.sedeIndxx];
        weakSelf.gasnumTextf.text=weakSelf.gasLimt;
        
        weakSelf.sedeIndx=1000;
       
        _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
                _qdBtn.enabled=NO;
        [UIView animateWithDuration:0.5 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            weakSelf.fotView.hidden=NO;
            
            
        }];
        
        [self limitStringt:self.gasprTextf];
    }
    else
    {//不显示自定义
        
        _qdBtn.backgroundColor=mainColor;
        _qdBtn.enabled=YES;
        weakSelf.sedeIndx=weakSelf.sedeIndxx;
        [self getGasLimt:self.gasLimt gas:self.gasArr[weakSelf.sedeIndx]];
      
        [UIView animateWithDuration:0.5 animations:^{
            sender.imageView.transform = CGAffineTransformIdentity;
            weakSelf.gasprTextf.text=@"";
            weakSelf.gasnumTextf.text=@"";
            weakSelf.fotView.hidden=YES;
           
        }];
        
    }
    [self.mainCollectionView reloadData];
    
   
    
    
//    CGPoint bottomOffset = CGPointMake(0, _scroView.contentSize.height - _scroView.bounds.size.height);
//    [_scroView setContentOffset:bottomOffset animated:YES];
    
}
-(void)tzpk{
    NSLog(@"11111");
}

/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT;
    WeakSelf;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.sheetView.frame = rect;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.sheetView removeFromSuperview];
        
    }];
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT-_higt;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"tis__hui");
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    tranCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tcellId" forIndexPath:indexPath];
    
    if(self.gasArr.count){
        
        cell.numLab.text=[NSString stringWithFormat:@"%@Gwei", self.gasArr[indexPath.row]];
    }
    
    cell.timeLab.text=[NSString stringWithFormat:@"%@%@",_timeArr[indexPath.row],getLocalStr(@"rzt14")];
    
    cell.tsLab.text=_tsArr[indexPath.row];
    if(_sedeIndx==indexPath.row){
        cell.isSeled=YES;
    }
    else{
        cell.isSeled=NO;
    }
    
    
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!self.zdyBtn.selected){
        _sedeIndx=indexPath.row;
        _sedeIndxx=indexPath.row;
        [self.mainCollectionView reloadData];
        
        if(self.gasArr.count){
            [self getGasLimt:self.gasLimt gas:self.gasArr[indexPath.row]];

        }
    }
    else{
        _sedeIndx=indexPath.row;
        _sedeIndxx=indexPath.row;
        [self.mainCollectionView reloadData];
        [self szdyCk:self.zdyBtn];
    }
    
}
-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(gdValue(108), gdValue(94));//每一个cell的大小
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
        
        layout.sectionInset = UIEdgeInsetsMake(0,gdValue(15), 0, gdValue(15));//四周的边距
        //设置最小边距
        layout.minimumLineSpacing = gdValue(10);
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, _kfreeLab.bottom+gdValue(23), SCREEN_WIDTH, gdValue(94)) collectionViewLayout:layout];
        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[tranCollectionViewCell class] forCellWithReuseIdentifier:@"tcellId"];
        
        
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
