//
//  LeftTaskView.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TaskViewType)
{
    TaskViewTypeLeft,
    TaskViewTypeRight
};


@interface TaskView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTaskList:(NSArray*)taskList viewType:(TaskViewType)type;

@end

NS_ASSUME_NONNULL_END
