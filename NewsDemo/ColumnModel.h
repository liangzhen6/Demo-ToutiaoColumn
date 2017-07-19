//
//  ColumnModel.h
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/14.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, itemState) {
    itemStateNormol = 0,
    itemStateEdit,
    itemStateRemove,
};

@interface ColumnModel : NSObject

@property(nonatomic,copy)NSString * title;
@property(nonatomic,assign)itemState state;

+ (instancetype)columnModelTitle:(NSString *)title state:(itemState)state;

@end
