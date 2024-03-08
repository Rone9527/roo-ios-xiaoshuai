//
//  LCESwitch.h
//  LCESwitch
//
//  Created by juziwl on 15/6/25.
//  Copyright (c) 2015年 juziwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lceswitchDelage <NSObject>

-(void)getIndex:(NSInteger)index;

@end

@interface LCESwitch : UIView


/*! 创建LCESwitch*/
+ (instancetype)lceSwitchCGRect:(CGRect)frame  masks:(BOOL)masks;;
/*! title的数据源*/
@property(nonatomic,assign) NSArray *titleArray;
/*! 滑条的view*/
@property(nonatomic,assign) UIView  *sliderView;
/*! 当前选中的开关索引*/
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,weak) id<lceswitchDelage>delegate;



@end
