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

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    /*
     这里是突破的关键：一种思路，可以试试
     1.发现是选中状态将layer放大
     2.否则恢复原来的大小。
     */
    NSLog(@"heheh");

}

- (void)setModel:(ColumnModel *)model {
    _model = model;
    self.label.text = model.title;
    switch (model.state) {
        case 0:
        {//正常状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = YES;
            self.contentView.backgroundColor = [UIColor orangeColor];
        }
            break;
        case 1:
        {//编辑状态
            self.deleteBtn.hidden = NO;
            self.addBtn.hidden = YES;
            self.contentView.backgroundColor = [UIColor orangeColor];
        }
            break;
        case 2:
        {//移除状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = NO;
            self.contentView.backgroundColor = [UIColor grayColor];
        }
            break;
//        case 3:
//        {//选中状态
//            self.deleteBtn.hidden = NO;
//            self.addBtn.hidden = YES;
//            self.contentView.backgroundColor = [UIColor orangeColor];
//
//        }
//            break;
            
        default:
            break;
    }
    

}


- (IBAction)btnAction:(UIButton *)sender {
    
    if (self.block) {
        self.block(self.model);
    }
    
    switch (sender.tag-90) {
        case 0:
        {//增加
        
        
        }
            break;
        case 1:
        {//删除
            
            
        }
            break;

        default:
            break;
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
