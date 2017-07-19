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

//- (void)layoutSubviews {
//    [self.label addSubview:self.addBtn];
//    [self.addBtn addSubview:self.deleteBtn];
//}

//- (void)layoutSubviews {
//    if (self.model.state == itemStateSelect) {
////        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
//        self.layer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0f);
//    }else{
////        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        self.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
//
//    }
//    NSLog(@"caonima");
//    [self setNeedsLayout];
//
//}

- (void)setModel:(ColumnModel *)model {
    _model = model;
    self.label.text = model.title;
    switch (model.state) {
        case 0:
        {//正常状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = YES;
            self.backView.backgroundColor = [UIColor orangeColor];
            self.backView.transform = CGAffineTransformIdentity;
//            self.contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);

        }
            break;
        case 1:
        {//编辑状态
            self.deleteBtn.hidden = NO;
            self.addBtn.hidden = YES;
            self.backView.backgroundColor = [UIColor orangeColor];
            self.backView.transform = CGAffineTransformIdentity;

//            self.contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);

        }
            break;
        case 2:
        {//移除状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = NO;
            self.backView.backgroundColor = [UIColor grayColor];
            self.backView.transform = CGAffineTransformIdentity;

        }
            break;
        case 3:
        {//选中状态
            self.deleteBtn.hidden = NO;
            self.addBtn.hidden = YES;
            self.backView.backgroundColor = [UIColor orangeColor];
            self.backView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        }
            break;
            
        default:
            break;
    }
    
    
}


//- (void)updateState:(BOOL)isSelect {
//    if (isSelect) {
//        self.backView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
//        self.backView.backgroundColor = [UIColor redColor];
//    }else{
//        self.backView.transform = CGAffineTransformIdentity;
//    }
//
//    [self.contentView setNeedsLayout];
//
//}

//- (void)updateLayer {
//    CALayer *layer = self.layer;
//    static CGFloat WIDTH = 66.7;
//    static CGFloat HEIGHT = 30;
//    CGFloat width = layer.bounds.size.width;
//    CGFloat height = layer.bounds.size.height;
//    if (width == WIDTH) {
//        width = WIDTH * 1.5;
//        height = HEIGHT * 1.5;
//    }else{
//        width = WIDTH;
//        height = HEIGHT;
//    }
//
//    layer.bounds = CGRectMake(0, 0, width, height);
//    layer.needsDisplayOnBoundsChange = YES;
////    layer.position = self.contentView.center;
//
//    [self setNeedsLayout];
//}


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
