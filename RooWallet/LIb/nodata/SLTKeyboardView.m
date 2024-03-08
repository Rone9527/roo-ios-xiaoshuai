//
//  SLTKeyboardView.m
//  RooWallet
//
//  Created by mac on 2021/7/7.
//

#import "SLTKeyboardView.h"

@implementation SLTKeyboardView
- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, gdValue(243));
        self.backgroundColor = [UIColor whiteColor];
        CGFloat itemWidth = self.frame.size.width/3.0;
        CGFloat itemHeight = self.frame.size.height/4;
        for (NSInteger i=0; i<4; i++) {
            for (NSInteger j=0; j<3; j++) {
                UIButton *item = [[UIButton alloc]initWithFrame:CGRectMake(itemWidth*j, itemHeight*i, itemWidth, itemHeight)];
                NSInteger tag = i*3+j;
                item.tag = tag;
                [item setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                item.titleLabel.font = fontNum(24);
                [item setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xE4E4E4)] forState:UIControlStateSelected];
                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
                if (tag == 9) {
                    item.titleLabel.font = fontNum(18);
                    [item setTitle:@"取消" forState:UIControlStateNormal];
                }else if (tag == 10){
                    [item setTitle:@"0" forState:UIControlStateNormal];
                }else if (tag == 11){
                    [item setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                }else{
                    [item setTitle:@(tag+1).stringValue forState:UIControlStateNormal];
                }
                [self addSubview:item];
                //
                if (i == 3 && j<2) {
                    UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake((j+1)*itemWidth, 0, 0.5, self.frame.size.height)];
                    verLine.backgroundColor = [UIColor whiteColor];
                    [self addSubview:verLine];
                }
            }
            UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake(0, i*itemHeight, self.frame.size.width, 0.5)];
            verLine.backgroundColor = [UIColor whiteColor];
            [self addSubview:verLine];
        }
        //分割线
        for (NSInteger i=0; i<4; i++) {
            //
            if (i<2) {
                UIView *verLine = [[UIView alloc]initWithFrame:CGRectMake((i+1)*itemWidth, 0, 0.5, self.frame.size.height)];
                verLine.backgroundColor = [UIColor whiteColor];
                [self addSubview:verLine];
            }
            UIView *horLine = [[UIView alloc]initWithFrame:CGRectMake(0, i*itemHeight, self.frame.size.width, 0.5)];
            horLine.backgroundColor = [UIColor whiteColor];
            [self addSubview:horLine];
        }
    }
    return self;
}
    
- (UIImage *)imageWithColor:(UIColor *)color {

    //描述一个矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    //获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //使用color演示填充上下文
    CGContextSetFillColorWithColor(ctx, [color CGColor]);

    //渲染上下文
    CGContextFillRect(ctx, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}
-(void)itemAction:(UIButton *)sender{
    if (self.itemActionBlock) {
        self.itemActionBlock(sender);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
