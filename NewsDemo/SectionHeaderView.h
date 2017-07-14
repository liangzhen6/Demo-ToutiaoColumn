//
//  SectionHeaderView.h
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^headerMaxYBlock)(CGFloat headerMaxY);
@interface SectionHeaderView : UICollectionReusableView

@property(nonatomic,copy)headerMaxYBlock headerBlock;

@end
