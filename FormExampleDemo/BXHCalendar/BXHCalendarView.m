//
//  BXHCalendarView.m
//  BXHCalendar
//
//  Created by 步晓虎 on 2017/10/18.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "BXHCalendarView.h"
#import "BXHCalendarManager.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width

#define ITEM_WIDTH   ScreenW/9

#define CALENDARVIEW_H  30

@interface UIView (BXHCalendar)

@end

@implementation UIView (BXHCalendar)

- (void)bxh_safeAddSubView:(UIView *)subView
{
    if ([self.subviews containsObject:subView])return;
    [self addSubview:subView];
}

@end

@interface BXHCalendarView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) BXHCalendarMonthView *preMonthView;
@property (nonatomic, strong) BXHCalendarMonthView *midMonthView;
@property (nonatomic, strong) BXHCalendarMonthView *nextMonthView;
@property (nonatomic, strong) BXHWeekendView *weekendView;
@property (nonatomic, strong) UIButton * lastWeekBtn;
@property (nonatomic, strong) UIButton * nextWeekBtn;
@property (nonatomic, assign) CGPoint panBeaginPoint;

@end


@implementation BXHCalendarView

- (void)dealloc
{
    [BXHCalendarManager releaseManage];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [BXHCalendarManager defaultManager].calendarView = self;
        [self setDisplayType:BXHCalendarDisplayWeekType];
        [self updateMonthViewBegainDate];
        
        [self addSubview:self.contentView];
        [self addSubview:self.weekendView];
        [self addSubview:self.lastWeekBtn];
        [self addSubview:self.nextWeekBtn];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//        [self.contentView addGestureRecognizer:pan];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self.contentView bxh_safeAddSubView:self.preMonthView];
    [self.contentView bxh_safeAddSubView:self.midMonthView];
    [self.contentView bxh_safeAddSubView:self.nextMonthView];
    [super willMoveToSuperview:newSuperview];
}
#pragma mark----上周
- (void)lastWeekActin{
    [self scrollToRight:YES];
}
#pragma mark----下周
- (void)nestWeekActin{
    [self scrollToRight:NO];
}
#pragma mark - public
- (void)changeDisplayType:(BXHCalendarDisplayType)type animated:(BOOL)animated
{
    [self setDisplayType:type];
//    [self updateMonthViewBegainDate];
    [self.midMonthView changeDisplayTypeWithAnimate:animated];
    [self.preMonthView changeDisplayTypeWithAnimate:NO];
    [self.nextMonthView changeDisplayTypeWithAnimate:NO];
    [self scrollEnd];
}

- (void)goToToday
{
    if ([BXHCalendarManager defaultManager].displayType == BXHCalendarDisplayMonthType)
    {
        NSDate *begainDate = [[NSDate date] dateWithMonthBegainDate];;
        self.midMonthView.beaginDate = begainDate;
        self.preMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByMinusMonths:1];
        self.nextMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByAddingMonths:1];
    }
    else
    {
        NSDate *begainDate = [[NSDate date] dateWithWeekBegainDate];
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:begainDate];//前一天
        self.midMonthView.beaginDate = lastDay;
        self.preMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByMinusWeeks:1];
        self.nextMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByAddingWeeks:1];
    }
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.midMonthView reload];
                         [self.preMonthView reload];
                         [self.nextMonthView reload];
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.layer.opacity = 1;
                                          }];
                     }];
    [self scrollEnd];
}

- (void)reloadEvent
{
    if ([[BXHCalendarManager defaultManager].dataSource respondsToSelector:@selector(calendarView:dayViewHaveEvent:)])
    {
        for (BXHCalendarDayView *dayView in [self.midMonthView allDayView])
        {
            [[BXHCalendarManager defaultManager].dataSource calendarView:self dayViewHaveEvent:dayView];
        }
    }
}

#pragma mark - GestureRecognizer
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.panBeaginPoint = [pan locationInView:self.contentView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [pan locationInView:self];
            CGFloat move = currentPoint.x - self.panBeaginPoint.x;
            if (move == 0) return;
            CGRect preFrame = self.preMonthView.frame,midFrame = self.midMonthView.frame, nextFrame = self.nextMonthView.frame;
            preFrame.origin.x = -self.bounds.size.width + move;
            midFrame.origin.x = move;
            nextFrame.origin.x = self.bounds.size.width + move;
            self.preMonthView.frame = preFrame;
            self.midMonthView.frame = midFrame;
            self.nextMonthView.frame = nextFrame;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect preFrame = self.preMonthView.frame,midFrame = self.midMonthView.frame, nextFrame = self.nextMonthView.frame;
            preFrame.origin.x = -self.bounds.size.width;
            midFrame.origin.x = 0;
            nextFrame.origin.x = self.bounds.size.width;
            [UIView animateWithDuration:CalendarScrollTime animations:^{
                self.preMonthView.frame = preFrame;
                self.midMonthView.frame = midFrame;
                self.nextMonthView.frame = nextFrame;
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint v = [pan velocityInView:self];
            CGPoint c = [pan locationInView:self];
            CGFloat move = c.x - self.panBeaginPoint.x;
            if (move == 0) return;

            if (fabs(v.x) > 1000 || fabs(move) >= self.bounds.size.width / 2)
            {
                [self scrollToRight:v.x > 0];
            }
            else
            {
                CGRect preFrame = self.preMonthView.frame,midFrame = self.midMonthView.frame, nextFrame = self.nextMonthView.frame;
                preFrame.origin.x = -self.bounds.size.width;
                midFrame.origin.x = 0;
                nextFrame.origin.x = self.bounds.size.width;
                [UIView animateWithDuration:CalendarScrollTime animations:^{
                    self.preMonthView.frame = preFrame;
                    self.midMonthView.frame = midFrame;
                    self.nextMonthView.frame = nextFrame;
                }];
            }
            
        }
            break;
            
        default:
            break;
    }

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - private
- (void)exchangeMonthViewPointerWithScrollDirection:(BOOL)right
{
    if (right)
    {
        BXHCalendarMonthView *tempPoint = self.nextMonthView;
        self.nextMonthView = self.midMonthView;
        self.midMonthView = self.preMonthView;
        self.preMonthView = tempPoint;
    }
    else
    {
        BXHCalendarMonthView *tempPoint = self.preMonthView;
        self.preMonthView = self.midMonthView;
        self.midMonthView = self.nextMonthView;
        self.nextMonthView = tempPoint;
    }
}

- (void)scrollEnd
{
    if ([[BXHCalendarManager defaultManager].dataSource respondsToSelector:@selector(calendarView:willShowMonthView:)])
    {
        [[BXHCalendarManager defaultManager].dataSource calendarView:self willShowMonthView:self.midMonthView];
    }
}

- (void)updateMonthViewBegainDate
{
    if ([BXHCalendarManager defaultManager].displayType == BXHCalendarDisplayMonthType)
    {
        NSDate *begainDate = self.midMonthView.beaginDate;
        if (begainDate)
        {
            begainDate = [begainDate dateWithMonthBegainDate];
        }
        else
        {
            begainDate = [[NSDate date] dateWithMonthBegainDate];
        }
        self.midMonthView.beaginDate = begainDate;
        self.preMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByMinusMonths:1];
        self.nextMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByAddingMonths:1];
    }
    else
    {
        BXHCalendarDayView *dayView = [self.midMonthView dayViewWithIndexPath:[BXHCalenderIndexPath indextPathWithLine:self.midMonthView.weekLine andRow:0]];
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:dayView.date];
        self.midMonthView.beaginDate = lastDay;
        self.preMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByMinusWeeks:1];
        self.nextMonthView.beaginDate = [self.midMonthView.beaginDate bxh_dateByAddingWeeks:1];
    }
}

#pragma mark - scroll
- (void)scrollToRight:(BOOL)right
{
    CGRect preFrame = self.preMonthView.frame,midFrame = self.midMonthView.frame, nextFrame = self.nextMonthView.frame;
    if (right)
    {
        preFrame.origin.x = ITEM_WIDTH;
        midFrame.origin.x = self.bounds.size.width;
        nextFrame.origin.x = -self.bounds.size.width;
        [UIView animateWithDuration:CalendarScrollTime animations:^{
            self.midMonthView.frame = midFrame;
            self.preMonthView.frame = preFrame;
        } completion:^(BOOL finished) {
            if(finished)
            {
                self.nextMonthView.frame = nextFrame;
                [self.nextMonthView reloadWithBegainDate:self.displayType == BXHCalendarDisplayMonthType ? [self.preMonthView.beaginDate bxh_dateByMinusMonths:1] : [self.preMonthView.beaginDate bxh_dateByMinusWeeks:1]];
                [self exchangeMonthViewPointerWithScrollDirection:right];
                [self scrollEnd];
            }
        }];
    }
    else
    {
        preFrame.origin.x = self.bounds.size.width;
        midFrame.origin.x = -self.bounds.size.width;
        nextFrame.origin.x = ITEM_WIDTH;
        [UIView animateWithDuration:CalendarScrollTime animations:^{
            self.midMonthView.frame = midFrame;
            self.nextMonthView.frame = nextFrame;
        } completion:^(BOOL finished) {
            self.preMonthView.frame = preFrame;
            [self.preMonthView reloadWithBegainDate:self.displayType == BXHCalendarDisplayMonthType ?[self.nextMonthView.beaginDate bxh_dateByAddingMonths:1] : [self.nextMonthView.beaginDate bxh_dateByAddingWeeks:1]];
            [self exchangeMonthViewPointerWithScrollDirection:right];
            [self scrollEnd];
        }];
    }

}

#pragma mark - lazyLoad
- (void)setDisplayType:(BXHCalendarDisplayType)displayType
{
    [BXHCalendarManager defaultManager].displayType = displayType;
}

- (BXHCalendarDisplayType)displayType
{
    return [BXHCalendarManager defaultManager].displayType;
}

- (void)setDelegate:(id<BXHCalendarViewDelegate>)delegate
{
    [BXHCalendarManager defaultManager].delegate = delegate;
}

- (id <BXHCalendarViewDelegate>)delegate
{
    return [BXHCalendarManager defaultManager].delegate;
}

- (void)setDataSource:(id<BXHCalendarViewDataSource>)dataSource
{
    [BXHCalendarManager defaultManager].dataSource = dataSource;
}

- (id <BXHCalendarViewDataSource>)dataSource
{
    return [BXHCalendarManager defaultManager].dataSource;
}

- (NSDate *)calendarSelectDate
{
    return [BXHCalendarManager defaultManager].selectDate;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

- (BXHCalendarMonthView *)preMonthView
{
    if (!_preMonthView)
    {
        _preMonthView = [[BXHCalendarMonthView alloc] initWithCalendarLayout:[[BXHCalendarLayout alloc] init]];
        _preMonthView.layout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_WIDTH * CalendarDayView_HW_Ration);
        _preMonthView.frame = CGRectMake(-self.bounds.size.width, CGRectGetMaxY(self.weekendView.frame), self.bounds.size.width-2*ITEM_WIDTH, CALENDARVIEW_H);
    }
    return _preMonthView;
}

- (BXHCalendarMonthView *)midMonthView
{
    if (!_midMonthView)
    {
        _midMonthView = [[BXHCalendarMonthView alloc] initWithCalendarLayout:[[BXHCalendarLayout alloc] init]];
        _midMonthView.layout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_WIDTH * CalendarDayView_HW_Ration);
        _midMonthView.frame = CGRectMake(ITEM_WIDTH, CGRectGetMaxY(self.weekendView.frame), self.bounds.size.width-2*ITEM_WIDTH, CALENDARVIEW_H);
    }
    return _midMonthView;
}

- (BXHCalendarMonthView *)nextMonthView
{
    if (!_nextMonthView)
    {
        _nextMonthView = [[BXHCalendarMonthView alloc] initWithCalendarLayout:[[BXHCalendarLayout alloc] init]];
        _nextMonthView.layout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_WIDTH * CalendarDayView_HW_Ration);
        _nextMonthView.frame = CGRectMake(-self.bounds.size.width, CGRectGetMaxY(self.weekendView.frame), self.bounds.size.width-2*ITEM_WIDTH, CALENDARVIEW_H);
    }
    return _nextMonthView;
}

- (BXHWeekendView *)weekendView
{
    if (!_weekendView)
    {
        _weekendView = [[BXHWeekendView alloc] initWithItemWidth:ITEM_WIDTH];
        _weekendView.frame = CGRectMake(ITEM_WIDTH, 0, self.bounds.size.width-2*ITEM_WIDTH, 30);
        _weekendView.backgroundColor = HQRGBAColor(242, 197, 121, 1.0);
    }
    return _weekendView;
}

- (UIButton*)lastWeekBtn{
    if (!_lastWeekBtn) {
        _lastWeekBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastWeekBtn setTitle:@"上一周" forState:UIControlStateNormal];
        [_lastWeekBtn addTarget:self action:@selector(lastWeekActin) forControlEvents:UIControlEventTouchUpInside];
        _lastWeekBtn.frame = CGRectMake(0, 0, ITEM_WIDTH, self.bounds.size.height);
        [_lastWeekBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _lastWeekBtn;
}
- (UIButton*)nextWeekBtn{
    if (!_nextWeekBtn) {
        _nextWeekBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextWeekBtn setTitle:@"下一周" forState:UIControlStateNormal];
        [_nextWeekBtn addTarget:self action:@selector(nestWeekActin) forControlEvents:UIControlEventTouchUpInside];
        _nextWeekBtn.frame = CGRectMake(self.bounds.size.width-ITEM_WIDTH, 0, ITEM_WIDTH, self.bounds.size.height);
        [_nextWeekBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];

    }
    return _nextWeekBtn;
}

@end
