//
//  LLSearchView.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchView.h"

@interface LLSearchView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;



@end
@implementation LLSearchView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        self.backgroundColor=UIColorFromRGB(0xffffff);
        [self addSubview:self.searchHistoryView];
        
    }
    return self;
}

-(void)getHotArr:(NSMutableArray*)datAr{
    _hotArray=datAr;
    if(_hotArray.count>0){
    [self addSubview:self.hotSearchView];
    }
}

- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
        self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"猜你喜欢" textArr:self.hotArray];
    }
    return _hotSearchView;
}


- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
           
            self.searchHistoryView = [self setViewWithOriginY:0 title:@"历史搜索" textArr:self.historyArray];
        } else {
           
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    UIView *view = [[UIView alloc] init];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30 - 45, 30)];
    titleL.text = title;
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = UIColorFromRGB(0x666666);
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
//    NSLog(@"sd==%@",title);
    if ([title isEqualToString:@"历史搜索"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 28, 30);
      
       [btn setImage:[UIImage imageNamed:@"hc_s1"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = 10 + 40;
    CGFloat letfWidth = 15;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if (letfWidth + width + 15 > SCREEN_WIDTH) {
            if (y >= 130 && [title isEqualToString:@"历史搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 15;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 30)];
        label.userInteractionEnabled = YES;
        label.font = fontNum(14);
        label.textColor=UIColorFromRGB(0x333333);
        label.backgroundColor=UIColorFromRGB(0xf5f6f9);
        ViewRadius(label, 15);
        label.text = text;
//        label.layer.borderWidth = 0.5;
//        label.layer.cornerRadius = 5;
        label.textAlignment = NSTextAlignmentCenter;
//        if ([title isEqualToString:@"猜你喜欢"]) {
//            label.layer.borderColor =UIColorFromRGB(0x999999).CGColor;
//            label.textColor =  UIColorFromRGB(0x666666);//KColor(255, 148, 153);
//        }
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [view addSubview:label];
        letfWidth += width + 10;
    }
    view.frame = CGRectMake(0, riginY, SCREEN_WIDTH, y + 40);
    return view;
}


- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 30)];
    titleL.text = @"历史搜索";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = UIColorFromRGB(0x666666);
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    notextL.text =@"无搜索历史";
    notextL.font = [UIFont systemFontOfSize:12];
    notextL.textColor = UIColorFromRGB(0x666666);
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}


- (void)clearnSearchHistory:(UIButton *)sender
{
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setNoHistoryView];
    [_historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    [self addSubview:self.searchHistoryView];
    CGRect frame = _hotSearchView.frame;
    frame.origin.y = CGRectGetHeight(_searchHistoryView.frame);
    _hotSearchView.frame = frame;
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
}



@end
