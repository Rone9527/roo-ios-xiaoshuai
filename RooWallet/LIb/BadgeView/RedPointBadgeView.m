//
//  RedPointBadgeView.m
//  HaHaMall
//
//  Created by GX on 2019/5/20.
//  Copyright © 2019 GX. All rights reserved.
//

#import "RedPointBadgeView.h"

static const int RED_POINT_TAG = 0x123;

@implementation RedPointBadgeView
-(void) showTargetView:(UIView*)targetView forCount:(NSInteger) count location:(Direction)direction color:(UIColor *)colr{
   
    if(count<=0){
        if(targetView){
         UIView *labelCount = [targetView viewWithTag:RED_POINT_TAG];
        [labelCount removeFromSuperview];
    }
         return;
    }
    self.backgroundColor=colr;
    [self adjustSize:targetView forCount:count location:direction];
    [self buildAttr:targetView];
}


-(void) showTargetView:(UIView*)targetView forCount:(NSInteger) count position:(CGPoint) pos{
    if(_isRedview){
        self.redPointRadius = 8;
        self.redPointWidth = self.redPointRadius ;
        self.layer.cornerRadius = self.redPointRadius / 2;
        self.text = nil;
    }
    else{
    if(count == 1 ){
        self.redPointRadius = 10;
        self.redPointWidth = self.redPointRadius;
        self.layer.cornerRadius = self.redPointRadius / 2;
    }
    else if(count > 1 && count <= 99){
        self.redPointRadius = 10;
        self.redPointWidth = self.redPointRadius;
        self.layer.cornerRadius = self.redPointRadius / 2;
        self.text = [NSString stringWithFormat:@"%ld",(long)count];
    }else{
        self.redPointRadius = 10;
        self.redPointWidth = self.redPointRadius * 1.5;
        self.layer.cornerRadius = self.redPointRadius / 2;
        self.text = @"99+";
    }
    }
    CGPoint point = [targetView convertPoint:CGPointMake(pos.x,pos.y) toView:[targetView superview]];
    self.frame = CGRectMake(point.x,point.y,self.redPointWidth, self.redPointRadius);
    [self buildAttr:targetView];
}

-(void) buildAttr:(UIView*)targetView{
    [self removeFromSuperview];
   
    if (CGColorEqualToColor(self.backgroundColor.CGColor, [UIColor whiteColor].CGColor)){
//        self.textColor =ReColor;
    }
    else{
       
    self.textColor = [UIColor whiteColor];
    }
   
    self.font = fontNum(10);
    self.textAlignment = NSTextAlignmentCenter;
    
    self.tag = RED_POINT_TAG;
//    self.layer.masksToBounds = YES;
    self.clipsToBounds=YES;
    [targetView addSubview:self];
}

-(void)adjustSize:(UIView*)targetView forCount:(NSInteger)count location:(Direction)direction {
    self.curDirection = direction;
   
    if(_isRedview){
        self.redPointRadius = 8;
        self.redPointWidth = self.redPointRadius ;
        self.layer.cornerRadius = self.redPointRadius / 2;
        self.text = nil;
    }
    else{
    if(count >= 1 && count <= 99){
        self.redPointRadius = gdValue(15);
        self.redPointWidth = self.redPointRadius;
        self.layer.cornerRadius = self.redPointRadius / 2;
        self.text = [NSString stringWithFormat:@"%ld",(long)count];
    }
  
    else{
        self.redPointRadius = gdValue(15);
        self.redPointWidth = self.redPointRadius * 1.5;
        self.layer.cornerRadius = self.redPointRadius / 2;
        self.text = @"99+";
    }
    }
    
    switch(direction){
        case LEFT_TOP:
            self.frame = CGRectMake(-self.redPointRadius / 2,-self.redPointRadius / 2,
                                    self.redPointWidth, self.redPointRadius);
            break;
            
        case LEFT_BOTTOM:
            self.frame = CGRectMake(-self.redPointRadius / 2,targetView.frame.size.height - self.redPointRadius * 0.8,
                                    self.redPointWidth, self.redPointRadius);
            break;
            
        case RIGHT_TOP:
           
            self.frame = CGRectMake(targetView.frame.size.width - self.redPointWidth, -self.redPointRadius / 4,
                                    self.redPointWidth, self.redPointRadius);
            break;
            
        case RIGHT_BOTTOM:
            self.frame = CGRectMake(targetView.frame.size.width - 0.8 * self.redPointRadius,
                                    targetView.frame.size.height - self.redPointRadius * 0.8,                                                     self.redPointWidth, self.redPointRadius);
            break;
    }
}

-(void) updateBadgeView:(UIView*)targetView forCount:(NSInteger)count{
    UIView *labelCount = [targetView viewWithTag:RED_POINT_TAG];
  
    if(labelCount){
        if(count < 1){
            [labelCount removeFromSuperview];
            return;
        }
        if(count == 1){
            self.text = @"1";
        }
    
        [self adjustSize:targetView forCount:count location:self.curDirection];
    }
    
}

-(void) dissmiss:(UIView*)targetView{
    if(targetView && [targetView viewWithTag:RED_POINT_TAG]){
        [[targetView viewWithTag:RED_POINT_TAG] removeFromSuperview];
    }
}


@end

