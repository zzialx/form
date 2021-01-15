//
//  ItemModel.h
//  FormExampleDemo
//
//  Created by mwj on 2020/12/24.
//  Copyright © 2020 lx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject

@property(nonatomic,assign)NSInteger horizontalAxis;///<横轴索引

@property(nonatomic,assign)NSInteger verticalAxis;///<纵向索引

@property(nonatomic,strong)NSString * name;

@property(nonatomic,assign)NSInteger timeLength;///<时长


@end

NS_ASSUME_NONNULL_END
