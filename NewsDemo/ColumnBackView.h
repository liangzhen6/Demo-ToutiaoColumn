//
//  ColumnBackView.h
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editBlack)(BOOL isEdit);

@interface ColumnBackView : UIView

@property(nonatomic,copy)editBlack block;

+ (instancetype)columnBackView;

- (void)changeEditState:(BOOL)isEdit;

@end
