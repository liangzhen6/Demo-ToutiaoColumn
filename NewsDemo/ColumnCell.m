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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageBackView.layer.cornerRadius = 5.0f;
    self.imageBackView.layer.borderWidth = 1.0f;
    self.imageBackView.layer.borderColor = [UIColor blackColor].CGColor;

}

- (void)setModel:(ColumnModel *)model {
    _model = model;
    self.label.text = model.title;
    self.iconImage.image = [UIImage imageNamed:model.imageName];
    switch (model.state) {
        case 0:
        {//正常状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = YES;
//            self.backView.backgroundColor = [UIColor orangeColor];

        }
            break;
        case 1:
        {//编辑状态
            self.deleteBtn.hidden = NO;
            self.addBtn.hidden = NO;
//            self.backView.backgroundColor = [UIColor orangeColor];


        }
            break;
        case 2:
        {//移除状态下
            self.deleteBtn.hidden = YES;
            self.addBtn.hidden = NO;
//            self.backView.backgroundColor = [UIColor grayColor];

        }
            break;
            
        default:
            break;
    }
    
    
}

- (IBAction)btnAction:(UIButton *)sender {
    if (!sender.hidden) {
        if (self.block) {
            self.block(self.model);
        }
    }
}



@end
