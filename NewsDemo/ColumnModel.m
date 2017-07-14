//
//  ColumnModel.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/14.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ColumnModel.h"

@implementation ColumnModel

+ (instancetype)columnModelTitle:(NSString *)title state:(itemState)state {
    ColumnModel * model = [[ColumnModel alloc] init];
    model.title = title;
    model.state = state;
    
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@----%lu--",self.title,(unsigned long)self.state];
}

@end
