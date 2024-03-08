//
//  defiDetModel.m
//  RooWallet
//
//  Created by mac on 2021/8/9.
//

#import "defiDetModel.h"

@implementation defiDetModel
/** 替换关键字的属性名 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"dinitPrice":@"initPrice"};
}
@end
