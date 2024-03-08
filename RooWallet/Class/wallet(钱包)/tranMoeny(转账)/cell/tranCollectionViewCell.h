//
//  tranCollectionViewCell.h
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface tranCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel*tsLab;
@property(nonatomic,assign)BOOL isSeled;
@property(nonatomic,strong)UILabel*numLab;
@property(nonatomic,strong)UILabel*timeLab;
@end

NS_ASSUME_NONNULL_END
