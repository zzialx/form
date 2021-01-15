//
//  ScheduleView.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/24.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleView : UIView

@property(nonatomic,strong)ItemModel * viewModel;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
