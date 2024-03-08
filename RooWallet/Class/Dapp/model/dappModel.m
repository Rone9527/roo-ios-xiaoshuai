//
//  dappModel.m
//  RooWallet
//
//  Created by mac on 2021/7/20.
//

#import "dappModel.h"

@implementation dappxqModel
+(NSDictionary*)mj_objectClassInArray{
    return @{

                @"list" : [dapptyModel class],
            
                
                };
    
}
@end
@implementation dappModel
+(NSDictionary*)mj_objectClassInArray{
    return @{

                @"list" : [dappxqModel class],
            
                
                };
    
}
@end
