//
//  ScheduleListCollectionViewCell.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN



@protocol ScheduleListCollectionViewCellDelegate <NSObject>

@optional

- (void)longPressDragCellItemModel:(ItemModel*)model;


@end





@interface ScheduleListCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign)id <ScheduleListCollectionViewCellDelegate> delegate;


- (void)showTitle:(ItemModel*)model indexPath:(NSIndexPath*)indexPath;


@end

NS_ASSUME_NONNULL_END
