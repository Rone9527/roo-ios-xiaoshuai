//
//  RedPointBadgeView.h
//  HaHaMall
//
//  Created by GX on 2019/5/20.
//  Copyright © 2019 GX. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, Direction) {
    LEFT_TOP,
    LEFT_BOTTOM,
    RIGHT_TOP,
    RIGHT_BOTTOM
};

@interface RedPointBadgeView : UILabel

@property(nonatomic,assign) NSInteger redPointRadius;
@property(nonatomic,assign) CGFloat redPointWidth;
@property(nonatomic,assign) Direction curDirection;


/**
 显示小红点
 
 @param targetView : 目标视图
 @param count 小红点个数
 @param direction 在目标视图的方位
 */
-(void) showTargetView:(UIView*)targetView forCount:(NSInteger) count location:(Direction)direction color:(UIColor*)colr;


/**
 显示小红点
 
 @param targetView 目标视图
 @param count 未读条数
 @param pos 显示的位置
 */
-(void) showTargetView:(UIView*)targetView forCount:(NSInteger) count position:(CGPoint) pos;

/**
 更新小红点
 
 @param targetView 目标视图
 @param count 标识数
 */
-(void) updateBadgeView:(UIView*)targetView forCount:(NSInteger)count;

/**
 隐藏小红点
 
 @param targetView 目标视图
 */
-(void) dissmiss:(UIView*)targetView;

@property(nonatomic,assign)BOOL isRedview;
@end



