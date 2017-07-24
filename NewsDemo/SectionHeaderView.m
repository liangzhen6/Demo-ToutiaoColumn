//
//  SectionHeaderView.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView ()

@end

@implementation SectionHeaderView


- (void)setTitle:(NSString *)title subtitle:(NSString *)subTitle {
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}

@end
