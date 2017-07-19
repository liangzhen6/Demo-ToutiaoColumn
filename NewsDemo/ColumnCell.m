//
//  ColumnCell.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ColumnCell.h"
#import "ColumnModel.h"

@implementation ColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(ColumnModel *)model {
    _model = model;
    self.label.text = model.title;
    switch (model.state) {
        case 0:
        {//正常状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = YES;
            self.backView.backgroundColor = [UIColor orangeColor];

        }
            break;
        case 1:
        {//编辑状态
            self.deleteBtn.hidden = NO;
            self.addBtn.hidden = YES;
            self.backView.backgroundColor = [UIColor orangeColor];


        }
            break;
        case 2:
        {//移除状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = NO;
            self.backView.backgroundColor = [UIColor grayColor];

        }
            break;
            
        default:
            break;
    }
    
    
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (self.block) {
        self.block(self.model);
    }
    
    
}


//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView *subView in self.subviews) {
//            CGPoint myPoint = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, myPoint)) {
//                return subView;
//            }
//        }
//    }
//    return view;
//}

@end
