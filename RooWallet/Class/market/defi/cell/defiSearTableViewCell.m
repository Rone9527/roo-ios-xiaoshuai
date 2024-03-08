//
//  defiSearTableViewCell.m
//  RooWallet
//
//  Created by mac on 2021/8/4.
//

#import "defiSearTableViewCell.h"
#import "defiModel.h"
@interface defiSearTableViewCell()
@property(nonatomic,strong)UIImageView*logo;
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,strong)UILabel*bqLab;
@property(nonatomic,strong)UILabel*tvlLab;
@property(nonatomic,strong)UILabel*blLab;
@property(nonatomic,strong)UIButton*addBtn;
@property(nonatomic,strong)UIButton*fzbtn;
@property(nonatomic,strong)UIView*col;

@end

@implementation defiSearTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
       [self loadUI];
        
        
    }
    return self;
}

-(void)loadUI{
    
//    [self.contentView addSubview:self.logo];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.bqLab];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.col];
    [self.contentView addSubview:self.fzbtn];
    [self.contentView addSubview:self.tvlLab];
    
    [self.contentView addSubview:self.blLab];
   
    
}

-(void)setModel:(defiModel *)model{
    
    _model=model;
    
//    [self.logo sd_setFadeImageWithURL:Url_Str(model.logo) placeholderImage:imageName(@"mrtu")];
    
    self.nameLab.text=model.pairName;
    
    
    CGFloat wid=[Utility withForString:model.ascription fontSize:12 andhig:gdValue(20)]+gdValue(10);
    
    self.bqLab.frame=CGRectMake(gdValue(15), gdValue(3)+_nameLab.bottom, wid, gdValue(20));
    self.bqLab.text=model.ascription;
    self.tvlLab.frame=CGRectMake(_bqLab.right+gdValue(5), _bqLab.y, SCREEN_WIDTH-_bqLab.right-gdValue(115), gdValue(20));
    
    
    
    self.blLab.text=[NSString stringWithFormat:@"1:%@",model.price];
    NSString*sr=[[model.pairName componentsSeparatedByString:@"-"]lastObject];
    
    
    self.tvlLab.text=[NSString stringWithFormat:@"%@:%@",sr,model.contractId];
    
    if([model.isAdd isEqualToString:@"1"]){
        self.addBtn.selected=YES;
        self.addBtn.backgroundColor=UIColorFromRGB(0xC4C9D8);
    }
    else{
        self.addBtn.selected=NO;
        self.addBtn.backgroundColor=mainColor;
    }
    
    
}



-(UIImageView*)logo{
    if(!_logo){
        _logo=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(11), gdValue(15), gdValue(15))];
        ViewBorderRadius(_logo, gdValue(15)/2, 0.5, UIColorFromRGB(0xffffff));
        
    }
    return _logo;
}
-(UILabel*)nameLab{
    
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(7), gdValue(120), gdValue(23))];
        _nameLab.textColor=ziColor;
        _nameLab.font=fontMidNum(16);
        _nameLab.text=@"";
    }
    return _nameLab;
}

-(UILabel*)bqLab{
    
    if(!_bqLab){
        _bqLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(3)+_nameLab.bottom, gdValue(50), gdValue(20))];
        _bqLab.textColor=zyincolor;
        _bqLab.font=fontNum(12);
        _bqLab.textAlignment=NSTextAlignmentCenter;
        _bqLab.text=@"";
        ViewBorderRadius(_bqLab, gdValue(3), 0.5, UIColorFromRGB(0xffffff));
        _bqLab.backgroundColor=cyColor;
        
    }
    return _bqLab;
}
-(UILabel*)tvlLab{
    
    if(!_tvlLab){
        _tvlLab=[[UILabel alloc]initWithFrame:CGRectMake(_fzbtn.x-gdValue(5), _bqLab.y, gdValue(195), gdValue(20))];
        _tvlLab.textColor=zyincolor;
        _tvlLab.font=fontNum(12);
        _tvlLab.text=@"";
        _tvlLab.lineBreakMode=NSLineBreakByTruncatingMiddle;
//        _tvlLab.textAlignment=NSTextAlignmentRight;
        
    }
    return _tvlLab;
}
-(UIButton*)fzbtn{
    if(!_fzbtn){
        _fzbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _fzbtn.frame=CGRectMake(_addBtn.x-gdValue(35), _bqLab.y, gdValue(20), gdValue(20));
        
     
        [_fzbtn setImage:imageName(@"defifz") forState:UIControlStateNormal];
        
//        [_fzbtn addSubview:self.tvlLab];
        
        [_fzbtn addTarget:self action:@selector(fzckl) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _fzbtn;
}
-(UILabel*)blLab{
    
    if(!_blLab){
        _blLab=[[UILabel alloc]initWithFrame:CGRectMake(_addBtn.x-gdValue(125), gdValue(7), gdValue(110), gdValue(23))];
        _blLab.textColor=ziColor;
        _blLab.font=fontBoldNum(16);
//        _blLab.text=@"111";
        _blLab.textAlignment=NSTextAlignmentRight;
    }
    
    return _blLab;
}


-(UIView*)col{
    if(!_col){
        _col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(60)-1, SCREEN_WIDTH, 1)];
        _col.backgroundColor=cyColor;
    }
    return _col;
}
-(UIButton*)addBtn{
    if(!_addBtn){
        _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(75), gdValue(25)/2, gdValue(60), gdValue(35));
        
        ViewRadius(_addBtn, gdValue(8));
        _addBtn.backgroundColor=mainColor;
        [_addBtn setTitle:getLocalStr(@"waddz") forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font=fontBoldNum(15);
        
        [_addBtn setTitle:getLocalStr(@"已添加") forState:UIControlStateSelected];
        
        [_addBtn addTarget:self action:@selector(adddefiCK:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _addBtn;
}

#pragma mark --复制
-(void)fzckl{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = _model.contractId;
       if (pab == nil) {
         
       } else {
           [MBProgressHUD showText:getLocalStr(@"复制成功")];
       }
    
}

-(void)adddefiCK:(UIButton*)sender{
    
    sender.selected=!sender.selected;
    if(sender.selected){
        sender.backgroundColor=UIColorFromRGB(0xC4C9D8);
        
        _model.bg_tableName=bg_DeFizxname;
        [_model bg_save];
        [MBProgressHUD showText:getLocalStr(@"添加成功")];
       
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
              
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"zxmarkdefi" object:nil];
//        });
        
       
        
    }
    else{//取消
        sender.backgroundColor=mainColor;
     
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"identity"),bg_sqlValue(_model.identity)];
        [defiModel bg_delete:bg_DeFizxname where:where];

        [MBProgressHUD showText:getLocalStr(@"sccg")];
        
       
        
//        /dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
              
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"zxmarkdefi" object:nil];
//        });
        
    }
    
    if(self.block){
        self.block(sender.selected);
        
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
