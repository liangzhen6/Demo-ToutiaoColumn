//
//  SectionHeaderView.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SectionHeaderView

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    self.label.text = @"点击添加更多栏目";
    
    if (self.headerBlock) {
        self.headerBlock(CGRectGetMaxY(self.frame));
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
