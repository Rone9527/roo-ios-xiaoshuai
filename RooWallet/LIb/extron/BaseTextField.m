//
//  BaseTextField.m
//  PRDAE
//
//  Created by GOLD on 2018/9/26.
//  Copyright © 2018年 GOLD. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
