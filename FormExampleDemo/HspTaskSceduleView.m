//
//  HspTaskSceduleView.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/30.
//  Copyright © 2020 lx. All rights reserved.
//

#import "HspTaskSceduleView.h"
#import "ItemModel.h"
#import "TaskView.h"

@interface HspTaskSceduleView ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)TaskView * leftView;

@property(nonatomic,strong)TaskView * rightView;

@property(nonatomic,strong)UIView * line;

@end


@implementation HspTaskSceduleView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self getTaskList];
        [self leftView];
        [self line];
        [self rightView];
        
    }
    return self;
}
- (UIView*)line{
    if (_line == nil) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(195.5, 0, 1, self.frame.size.height)];
        _line.backgroundColor = UIColor.blackColor;
        [self addSubview:_line];
    }
    return _line;
}
- (TaskView*)leftView{
    if (_leftView==nil) {
        _leftView = [[TaskView alloc]initWithFrame:CGRectMake(10, 0, 170, self.frame.size.height) withTaskList:self.dataArray.firstObject viewType:TaskViewTypeLeft];
        _leftView.backgroundColor = UIColor.redColor;
        [self addSubview:_leftView];
    }
    return _leftView;
}

- (TaskView*)rightView{
    if (_rightView==nil) {
        _rightView = [[TaskView alloc]initWithFrame:CGRectMake(210, 0, self.frame.size.width-210-60, self.frame.size.height) withTaskList:self.dataArray.lastObject viewType:TaskViewTypeRight];
        [self addSubview:_rightView];
    }
    return _rightView;
}

- (void)getTaskList{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray * section_one_arrary =[NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i<5; i++) {
        ItemModel * model = [[ItemModel alloc]init];
        model.name = @"培训";
        [section_one_arrary addObject:model];
    }
    NSMutableArray * section_two_array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<15; i++) {
        ItemModel * model = [[ItemModel alloc]init];
        model.name = @"北京市口腔医院北京市口腔医院北京市";
        [section_two_array addObject:model];
    }
    [self.dataArray addObject:section_one_arrary];
    [self.dataArray addObject:section_two_array];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
