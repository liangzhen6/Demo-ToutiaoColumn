//
//  ColumnCell.h
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColumnModel;

typedef void(^actionBlock)(ColumnModel *model);

@interface ColumnCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property(nonatomic,strong)ColumnModel * model;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(nonatomic,copy)actionBlock block;

@end
