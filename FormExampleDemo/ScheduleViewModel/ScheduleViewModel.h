//
//  ScheduleViewModel.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/28.
//  Copyright © 2020 lx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

//日程vm

typedef void(^complete)(NSArray <ItemModel*> * dataSource);
typedef void(^fail)(void);

@interface ScheduleViewModel : NSObject


/**
 获取日程数据源

 @param complete 完成
 @param fail 失败
 */
- (void)getScheduleDataSourceWithComplete:(complete)complete fail:(fail)fail;

@end

NS_ASSUME_NONNULL_END
