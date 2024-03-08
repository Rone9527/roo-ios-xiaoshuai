//
//  LBJButton.m
//  ButtonTest
//
//  Created by LBJames on 2020/1/7.
//  Copyright © 2020 LBJames. All rights reserved.
//

#import "LBJButton.h"

@implementation LBJButton

- (void)drawRect:(CGRect)rect {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
   
           // 通知主线程刷新 神马的
        CGRect titleFrame = self.titleLabel.frame;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, self.underLineColor.CGColor);
        CGContextSetLineWidth(ctx, 2);//2表示线的高度
        CGContextMoveToPoint(ctx, CGRectGetMinX(titleFrame)-3, self.height-2);//距离文字底部有5个的距离
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(titleFrame)+3, self.height-2);
        CGContextStrokePath(ctx);
        CGContextFillPath(ctx);
//        CGContextRestoreGState(ctx);
        CGContextSaveGState(ctx);
//          });

  
}


- (void)setUnderLineColor:(UIColor *)underLineColor{
    _underLineColor = underLineColor;
    [self setNeedsDisplay];
}

@end
