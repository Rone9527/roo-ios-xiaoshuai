//
//  LCESwitch.m
//  LCESwitch
//
//  Created by juziwl on 15/6/25.
//  Copyright (c) 2015年 juziwl. All rights reserved.
//

#import "LCESwitch.h"
@interface LCESwitch ()


@end


@implementation LCESwitch


+ (instancetype)lceSwitchCGRect:(CGRect)frame masks:(BOOL)masks;
{
    
    LCESwitch *headerView = [[LCESwitch alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), gdValue(30))];
    if (masks) {
        headerView.layer.masksToBounds=YES;
        headerView.layer.cornerRadius=gdValue(4);
    }
    
    return headerView;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    UIView *sliderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/titleArray.count,gdValue(30))];
    sliderView.layer.cornerRadius=gdValue(4);
    sliderView.layer.masksToBounds=YES;
    sliderView.backgroundColor=mainColor;
    [self addSubview:sliderView];
    self.sliderView=sliderView;
    
    [titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=775566+idx;
        btn.frame=CGRectMake((self.frame.size.width/titleArray.count)*idx, 0, self.frame.size.width/titleArray.count, self.height);
        [btn setExclusiveTouch:YES];
        btn.titleLabel.font=fontNum(14);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(idx==0){
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
       
        
        btn.layer.cornerRadius=gdValue(4);
        [btn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
    
    
}

    
-(void)clickEvent:(UIButton *)sender
{
    UIButton *button=(UIButton *)[self viewWithTag:sender.tag];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    NSInteger index=sender.tag-775566;
    
    if(index==self.currentIndex)
    {
        return;
    }else
    {
        UIButton *button=(UIButton *)[self viewWithTag:(NSInteger)(self.currentIndex+775566)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    

    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.sliderView.frame= CGRectMake(sender.frame.origin.x, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
    }completion:^(BOOL finished) {
        
    }];
    
    self.currentIndex=index;
    
    if([_delegate respondsToSelector:@selector(getIndex:)]){
        [_delegate getIndex:index];
        
    }

}






@end
