//
//  ColumnBackView.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ColumnBackView.h"
#import "ColumnCell.h"
#import "SectionHeaderView.h"
#import "ColumnModel.h"


@interface ColumnBackView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property(nonatomic,strong)UIPanGestureRecognizer * panGesture;
@property(nonatomic,getter=isEdit)BOOL edit;

@property(nonatomic,strong)NSMutableArray * dataSourceCopy;

@end

static NSString *const cellId = @"ColumnCell";
static NSString *const headerId = @"SectionHeaderView";


@implementation ColumnBackView

+ (instancetype)columnBackView {
    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self.collectionView addGestureRecognizer:panGesture];
    panGesture.enabled = NO;//滑动手势关闭
    panGesture.delegate = self;
    self.panGesture = panGesture;
    
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat minSpace = 0;
    CGFloat itemWidth = 0;
    if (WIDTH > 413) {//大屏幕
        itemWidth = 80;
    }else if (WIDTH > 374){//中等屏幕
        itemWidth = 70;
    }else{//小屏幕
        itemWidth = 60;
    }
    minSpace = (WIDTH - itemWidth * 4 -30)/3;

    self.collectionViewLayout.minimumLineSpacing = minSpace - 10;
    self.collectionViewLayout.minimumInteritemSpacing = minSpace;
    self.collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 20);
    self.collectionViewLayout.headerReferenceSize = CGSizeMake(WIDTH, 30);
    self.collectionView.bounces = NO;//没有回弹效果，可以避免cell消失的bug
    
    UINib * cellNib = [UINib nibWithNibName:NSStringFromClass([ColumnCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellId];
    
    UINib * headerNib = [UINib nibWithNibName:NSStringFromClass([SectionHeaderView class]) bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];

}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;

    self.dataSourceCopy = dataSource;
    
}

- (void)setDataSourceCopy:(NSMutableArray *)dataSourceCopy {
    _dataSourceCopy = [[NSMutableArray alloc] init];
    for (NSMutableArray * arr in dataSourceCopy) {
        [_dataSourceCopy addObject:[arr mutableCopy]];
    }
}

/**
 手势触发的事件
 */
- (void)gestureAction:(UIGestureRecognizer *)sender {
    static NSIndexPath * selectIndexPath = nil;//长按拖动的那个item
    static CGPoint offsetPoint;
    
    //    // 如果不是编辑状态，转变成编辑状态，并且通知上一个页面
    if (!self.edit) {
        self.edit = YES;
        [self changeEditState:YES];
        if (self.block) {
            self.block(self.edit);
        }
    }
    
    CGPoint point = [sender locationInView:sender.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
 
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {

            if (indexPath.section == 0 && indexPath.item != 0) {
                selectIndexPath = indexPath;
                ColumnCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:selectIndexPath];
                offsetPoint = CGPointMake(cell.center.x - point.x, cell.center.y - point.y);
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                [self.collectionView updateInteractiveMovementTargetPosition:cell.center];

            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (selectIndexPath) {//更新itme的位置
                [self.collectionView updateInteractiveMovementTargetPosition:CGPointMake(point.x + offsetPoint.x, point.y + offsetPoint.y)];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (selectIndexPath) {
                [self.collectionView endInteractiveMovement];//停止移动
                selectIndexPath = nil;
            }
            break;
        }
        default: {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
    
  
}



- (void)changeEditState:(BOOL)isEdit {
    self.edit = isEdit;
    for (ColumnModel * model in self.dataSource[0]) {
        if (isEdit) {
            model.state = itemStateEdit;//所有model变成编辑状态
            self.panGesture.enabled = YES;//滑动手势开启
        }else{
            model.state = itemStateNormol;
            self.panGesture.enabled = NO;//滑动手势关闭
        }
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
}

- (void)updateColumn:(updateColumnBlock)updateBlock {
    if ([self checkColumnChange]) {//检查是否有更改
        self.dataSourceCopy = _dataSource;
        updateBlock(_dataSource);
    }
}
- (BOOL)checkColumnChange {
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        if (![_dataSource[i] isEqualToArray:_dataSourceCopy[i]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -------------UIGestureRecognizerDelegate-----------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {//阻止一些非选中indexPathcell事件响应
    CGPoint point = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (indexPath.section == 0 && indexPath.item != 0) {
        return YES;
    }
    return NO;
}


#pragma mark -----UIcollectionDelegate----------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColumnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section][indexPath.item];
    if (indexPath.section == 0 && indexPath.item == 0) {
        cell.deleteBtn.hidden = YES;
        cell.addBtn.hidden = YES;
    }
    __weak typeof (self)ws = self;
    [cell setBlock:^(ColumnModel *model){
        [ws handleCellAction:model];
    }];
    return cell;
}


- (void)handleCellAction:(ColumnModel *)model {
    if (model.state == itemStateEdit) {
        //是编辑状态，需要处理删除操作
        [self handleDeleteItemSelectIndex:model];
    }else if(model.state == itemStateRemove) {
        //是删除状态，需要处理为增加一个
        [self handelAddItemSelectIndex:model];
    }

}

- (void)handelAddItemSelectIndex:(ColumnModel *)selectModel {
    ColumnModel * model = selectModel;
    NSInteger index = [self.dataSource[1] indexOfObject:model];
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:index inSection:1];
    if (self.isEdit) {
        model.state = itemStateEdit;
    }else{
        model.state = itemStateNormol;
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[selectIndexPath]];
    
    [self.dataSource[1] removeObjectAtIndex:selectIndexPath.item];
    [self.dataSource[0] addObject:model];
    [self.collectionView moveItemAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForItem:[self.dataSource[0] count]-1 inSection:0]];
}

- (void)handleDeleteItemSelectIndex:(ColumnModel *)selectModel {
    ColumnModel * model = selectModel;
    NSInteger index = [self.dataSource[0] indexOfObject:model];
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    model.state = itemStateRemove;
    
    [self.collectionView reloadItemsAtIndexPaths:@[selectIndexPath]];//先刷新状态再移动。
    
    
    [self.dataSource[0] removeObjectAtIndex:selectIndexPath.item];
    [self.dataSource[1] insertObject:model atIndex:0];
    [self.collectionView moveItemAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

#pragma mark ----------UICollectionViewDelegate的移动的一些代理-----------------

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.item != 0) {
        return YES;
    }else{
        return NO;
    }
}


- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {

    if (proposedIndexPath.section == 0 && proposedIndexPath.item == 0) {
        return originalIndexPath;
    }else{
        return proposedIndexPath;
    }
    
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //是段头
        SectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if (indexPath.section == 0) {
            //第0行
            [headerView setTitle:@"我的频道" subtitle:@"长按拖动排序"];
        }else{
            //第1行
            [headerView setTitle:@"频道推介" subtitle:@"点击添加频道"];
        }
            return  headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ColumnModel * change = self.dataSource[sourceIndexPath.section][sourceIndexPath.item];
    [self.dataSource[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
    [self.dataSource[destinationIndexPath.section] insertObject:change atIndex:destinationIndexPath.item];
    
    if (destinationIndexPath.section == 1) {
        change.state = itemStateRemove;
        [self.collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
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
