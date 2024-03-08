//
//  blockModel.m
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import "blockModel.h"
@implementation btokensModel
@end



@implementation blockModel
+(NSDictionary*)mj_objectClassInArray{
    return @{

                @"nodes" : [walletNodesModel class],
                @"tokens" : [btokensModel  class],
               
            
                
                };
    
}
@end
