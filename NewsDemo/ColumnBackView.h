//
//  ColumnBackView.h
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColumnModel;
typedef void(^editBlock)(BOOL isEdit);
typedef void(^updateColumnBlock)(NSMutableArray * columnArray);

@interface ColumnBackView : UIView
@property(nonatomic,strong)NSMutableArray * dataSource;

@property(nonatomic,copy)editBlock block;

+ (instancetype)columnBackView;

- (void)changeEditState:(BOOL)isEdit;

- (void)updateColumn:(updateColumnBlock)updateBlock;

@end
