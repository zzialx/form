//
//  ViewController.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/22.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ViewController.h"
#import "PageHorizontalCollectionViewCell.h"
#import "ItemModel.h"
#import "ScheduleView.h"
#import <Toast.h>
#import <Masonry.h>
#import "BXHCalendarView.h"
#import "NSDate+BXHCalendar.h"
#import "NSDate+BXHCategory.h"
#import "ScheduleViewModel.h"
#import "HspTaskSceduleView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define ITEM_HEIGHT  550/11

static NSString *const cellID = @"cellID_pageHorizon";



@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PageHorizontalCollectionViewCellDelegate,BXHCalendarViewDataSource,BXHCalendarViewDelegate>

@property(nonatomic,strong)BXHCalendarView * calenderView;///<日历

@property(nonatomic,strong)UICollectionView * collectionView;///<横向滑动的表格

@property(nonatomic,strong)NSMutableArray * dataArray;///<表格的数据

@property(nonatomic,strong)NSMutableArray * scheduleDataArray;///<日程安排的数据

@property(nonatomic,assign)NSInteger timeLength;///<时长

@property(nonatomic,assign)NSInteger verticalAxisLength;///<时长

@property(nonatomic,strong)ScheduleViewModel * viemModel;///<数据源处理


@property(nonatomic,strong)HspTaskSceduleView * scedyleView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.scheduleDataArray = [NSMutableArray arrayWithCapacity:0];
    self.timeLength = 1;
    self.verticalAxisLength = 23;
    [self getDataList];
    [self scedyleView];
    [self setCalenderviewUI];
    [self collectionView];
    
}
#pragma mark-------日历
- (void)setCalenderviewUI{
    self.calenderView = [[BXHCalendarView alloc] initWithFrame:CGRectMake(0, 220, self.view.bounds.size.width, 60)];
    self.calenderView.dataSource = self;
    self.calenderView.delegate = self;
    [self.view addSubview:self.calenderView];
    [self.calenderView goToToday];
}
- (void)calendarView:(BXHCalendarView *)calendarView willShowMonthView:(BXHCalendarMonthView *)monthView
{
    self.title = [NSString stringWithFormat:@"%@",[monthView.beaginDate bxh_stringWithFormate:@"yyyy-MM-dd"]];
}

- (void)calendarView:(BXHCalendarView *)calendarView dayViewHaveEvent:(BXHCalendarDayView *)dayView
{
    dayView.haveEvent = dayView.date.day % 3 == 0;
}

- (void)calendarView:(BXHCalendarView *)calendarView didSelectDayView:(BXHCalendarDayView *)dayView
{
    
    NSLog(@"select %@",[dayView.date bxh_stringWithFormate:@"yyyy-MM-dd"]);
}

#pragma mark-------底部日历表格
- (UICollectionView*)collectionView{
    if (_collectionView==nil) {
        // 使用系统自带的流布局（继承自UICollectionViewLayout）
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 每个cell的大小
        layout.itemSize   = CGSizeMake((ScreenW-7)/9, ITEM_HEIGHT);
        // 横向滚动
//        layout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
        // cell间的间距
        layout.minimumLineSpacing  = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        //第一个cell和最后一个cell居中显示（这里我的Demo里忘记改了我用的是160，最后微调数据cell的大小是180）
//        CGFloat margin = (ScreenW - 180) * 0.5;
        layout.sectionInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        // 使用UICollectionView必须设置UICollectionViewLayout属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame  = CGRectMake(0, self.calenderView.frame.size.height+self.calenderView.frame.origin.y, ScreenW-(ScreenW-7)/9, 550);
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.calenderView).with.offset(10);
//            make.height.mas_equalTo(550);
//            make.left.equalTo(self.view);
//            make.width.mas_equalTo(ScreenW-(ScreenW-7)/9);
//            make.bottom.equalTo(self.view).offset(0);
//        }];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [self.view addSubview:_collectionView];
        // 实现注册cell，其中PageHorizontalCollectionViewCell是我自定义的cell，继承自UICollectionViewCell
        [_collectionView registerClass:[PageHorizontalCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _collectionView.layer.borderWidth = 0.5;
        
    }
    return _collectionView;
}
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PageHorizontalCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell showTitle:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)longPressCellModel:(ItemModel*)model cellFrame:(CGRect)cellFrame{
    NSLog(@"纵轴索引====%ld",model.verticalAxis);
    //判断纵轴坐标+时长是否超过表格的长度
    if (model.verticalAxis + self.timeLength > self.verticalAxisLength) {
        NSLog(@"超过纵轴长度");
        return;
    }
    
    //判断是不是和上一行任务重叠
    ScheduleView * testView = [[ScheduleView alloc]initWithFrame:CGRectMake(cellFrame.origin.x,cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height*self.timeLength)];
    model.timeLength = self.timeLength;
    testView.viewModel = model;
    [self.collectionView addSubview:testView];
    [self.scheduleDataArray addObject:testView];
}


#pragma mark----模拟数据源
- (void)getDataList{
    [self.viemModel getScheduleDataSourceWithComplete:^(NSArray<ItemModel *> * _Nonnull dataSource) {
        [self.dataArray addObjectsFromArray:dataSource];
    } fail:^{
        
    }];
}

- (ScheduleViewModel*)viemModel{
    if (_viemModel==nil) {
        _viemModel = [[ScheduleViewModel alloc]init];
    }
    return _viemModel;
}

- (HspTaskSceduleView*)scedyleView{
    if (_scedyleView==nil) {
        _scedyleView = [[HspTaskSceduleView alloc]initWithFrame:CGRectMake(0, 60, ScreenW, 150)];
        [self.view addSubview:_scedyleView];
    }
    return _scedyleView;
}

@end
