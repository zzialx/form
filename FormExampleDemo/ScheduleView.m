//
//  ScheduleView.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/24.
//  Copyright © 2020 lx. All rights reserved.
//

#import "ScheduleView.h"
#import <Masonry.h>

#define ITEM_HEIGHT  550/11

@interface ScheduleView ()

@property(nonatomic,strong)UIView * contentView;

@property(nonatomic,strong)UIButton * bottomLine;

@property(nonatomic,assign)CGFloat lastHeight;///<记录手指离开时self的高度
@end


@implementation ScheduleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastHeight = ITEM_HEIGHT;
        [self setSubUI];
    }
    return self;
}
- (void)setSubUI{
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.contentView];
    
    self.bottomLine = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomLine setTitle:@"_____" forState:UIControlStateNormal];
    [self.bottomLine setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    [self addSubview:self.bottomLine];
    [self updateSubViewsFrame];

    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
    [self.bottomLine addGestureRecognizer:panGR];

}
- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self];
    NSLog(@"%f,%f",point.x,point.y);
    CGFloat scrollY = point.y;
    switch (rec.state) {
            case UIGestureRecognizerStateChanged:
            NSLog(@"拖动时");
            if (scrollY>0) {
                //向下拉
                NSLog(@"=====%f",scrollY/50);
                //向下取整
                CGFloat scrollH = floor (scrollY/50)*ITEM_HEIGHT;
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,scrollH + self.lastHeight);
            }else{
                //向上拉
                NSLog(@"向上拉=======%f",fabs(scrollY)/50);
                NSLog(@"向上取值=======%f",ceilf(fabs(scrollY)/50));
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.lastHeight- (floor(fabs(scrollY)/50))*50);
                }
            break;
            case UIGestureRecognizerStateEnded:
            self.lastHeight = self.frame.size.height;
            NSLog(@"拖动结束");
            break;
            case UIGestureRecognizerStateCancelled:
            NSLog(@"拖动取消");
            break;
            default:
            break;
    }
    
    
    
}
- (void)updateSubViewsFrame{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(30.0);
    }];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextSetRGBStrokeColor(ctx, 226.0/255, 75.0/255, 25.0/255, 1);
    CGContextAddRect(ctx, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CGContextDrawPath(ctx, kCGPathFillStroke);
}


@end
