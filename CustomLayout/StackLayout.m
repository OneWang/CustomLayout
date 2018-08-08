//
//  StackLayout.m
//  Layout
//
//  Created by LI on 16/7/14.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "StackLayout.h"

@implementation StackLayout

/** 只要显示的边界发生改变就重新布局,内部重新调用layoutAttributesForElementsInRect方法获得 cell 布局的属性 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/** 返回 rect 矩形框范围内的所有元素的布局属性(cell(item)/header/footer) */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    //获取当前布局的元素个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        //自己手动创建一个UICollectionViewLayoutAttributes
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    return array;
}

/** 计算每一个 Item 的属性,返回每个indexPath对应的 Item 的属性; */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //设置每个图片的旋转角度
    NSArray *angles = @[@0, @(-0.2), @(-0.5), @(0.2), @(0.5)];
    //自己手动创建一个UICollectionViewLayoutAttributes
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置每个 Item 的大小
    attrs.size = CGSizeMake(100, 100);
    //设置每个 Item 的中心点的位置
    attrs.center = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5);
    //设置只显示前面5个 Item
    if (indexPath.item >= 5) {
        attrs.hidden = YES;
    } else {
        attrs.transform = CGAffineTransformMakeRotation([angles[indexPath.item] floatValue]);
        // zIndex越大,就越在上面
        attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;
    }
    return attrs;
}



@end
