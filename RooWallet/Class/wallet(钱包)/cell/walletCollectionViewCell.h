//
//  walletCollectionViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^getwaBtnBlock1)(int indx);

@interface walletCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel*zcPriceLab;
@property(nonatomic,copy)getwaBtnBlock1 getwaBlock1;
@property(nonatomic,strong)walletModel*model;
@property(nonatomic,copy)NSString*allprc;

@property(nonatomic,assign)BOOL isHid;
@end

NS_ASSUME_NONNULL_END
