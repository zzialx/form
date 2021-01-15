//
//  ScheduleViewModel.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/28.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ScheduleViewModel.h"
@interface ScheduleViewModel ()

@end


@implementation ScheduleViewModel


- (void)getScheduleDataSourceWithComplete:(complete)complete fail:(fail)fail{
    NSMutableArray * scheduleList = [NSMutableArray arrayWithCapacity:0];
    for (int i = 8; i < 24; i ++) {
        for (int j = 0; j < 8; j++) {
            ItemModel * model = [[ItemModel alloc]init];
            model.horizontalAxis = j;
            model.verticalAxis = i;
            if (j==0) {
                model.name = [NSString stringWithFormat:@"%d:00",i];
            }else{
                //                model.name = [NSString stringWithFormat:@"%d-%d",i,j];
                model.name = [NSString stringWithFormat:@""];
                
            }
            [scheduleList addObject:model];
        }
    }
    if (scheduleList.count>0) {
        if (complete) complete(scheduleList);
    }else{
        if (fail)fail();
    }
}


@end
