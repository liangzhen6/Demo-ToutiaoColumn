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


@interface ColumnBackView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray * dataScore;

@property(nonatomic,assign)CGPoint locationPoint;
@property(nonatomic,assign)CGFloat maxY;
@property(nonatomic,getter=isEdit)BOOL edit;

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
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, 60, frame.size.width, frame.size.height-60);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressed:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    
    UINib * cellNib = [UINib nibWithNibName:NSStringFromClass([ColumnCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellId];
    
    UINib * headerNib = [UINib nibWithNibName:NSStringFromClass([SectionHeaderView class]) bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];

}

- (NSMutableArray *)dataScore {
    if (_dataScore == nil) {
        _dataScore = [[NSMutableArray alloc] init];
        NSMutableArray * arr1 = [[NSMutableArray alloc] init];
        [_dataScore addObject:arr1];
        NSMutableArray * arr2 = [[NSMutableArray alloc] init];
        [_dataScore addObject:arr2];
        for (NSInteger i = 0; i < 40; i++) {
            ColumnModel * model = [ColumnModel columnModelTitle:[NSString stringWithFormat:@"%ld",(long)i] state:itemStateNormol];
            [arr1 addObject:model];
        }
        for (NSInteger i = 0; i < 40; i++) {
            ColumnModel * model = [ColumnModel columnModelTitle:[NSString stringWithFormat:@"%ld",(long)i] state:itemStateRemove];
            [arr2 addObject:model];
        }
    }
    return _dataScore;
}


/**
 长按触发的事件
 */
- (void)onLongPressed:(UILongPressGestureRecognizer *)sender {
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
 

    self.locationPoint = point;

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
    for (ColumnModel * model in self.dataScore[0]) {
        if (isEdit) {
            model.state = itemStateEdit;//所有model变成编辑状态
        }else{
            model.state = itemStateNormol;
        }
    }
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
}


#pragma mark -----UIcollectionDelegate----------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataScore.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataScore[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColumnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    cell.model = self.dataScore[indexPath.section][indexPath.item];
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
    NSInteger index = [self.dataScore[1] indexOfObject:model];
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:index inSection:1];
    if (self.isEdit) {
        model.state = itemStateEdit;
    }else{
        model.state = itemStateNormol;
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[selectIndexPath]];
    
    [self.dataScore[1] removeObjectAtIndex:selectIndexPath.item];
    [self.dataScore[0] addObject:model];
    [self.collectionView moveItemAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForItem:[self.dataScore[0] count]-1 inSection:0]];
}

- (void)handleDeleteItemSelectIndex:(ColumnModel *)selectModel {
    ColumnModel * model = selectModel;
    NSInteger index = [self.dataScore[0] indexOfObject:model];
    NSIndexPath * selectIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    model.state = itemStateRemove;
    
    [self.collectionView reloadItemsAtIndexPaths:@[selectIndexPath]];//先刷新状态再移动。
    
    
    [self.dataScore[0] removeObjectAtIndex:selectIndexPath.item];
    [self.dataScore[1] insertObject:model atIndex:0];
    
    
    [self.collectionView moveItemAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];

}

#pragma mark ----------UICollectionViewDelegateFlowLayout-------------------

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
    
}

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
            return  headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ColumnModel * change = self.dataScore[sourceIndexPath.section][sourceIndexPath.item];
    [self.dataScore[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
    [self.dataScore[destinationIndexPath.section] insertObject:change atIndex:destinationIndexPath.item];
    
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
