//
//  CircleLayout.m
//  Layout
//
//  Created by LI on 16/7/14.
//  Copyright © 2016年 LI. All rights reserved.
//  在自定义布局的时候建议把两个方法都是实现

#define Random0_1 (arc4random_uniform(100)/100.0)
#import "CircleLayout.h"

@implementation CircleLayout

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
    //自己手动创建一个UICollectionViewLayoutAttributes
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //设置 Item 大小
    attrs.size = CGSizeMake(100, 100);
    //显示圆形展示时的半径大小
    CGFloat circleRadius = 100;
    //显示圆形展示时的圆点坐标
    CGPoint circleCenter = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5);
    //每个 Item 之间的角度
    CGFloat angelDail = M_PI * 2 /[self.collectionView numberOfItemsInSection:indexPath.section];
    //计算当前Item 的角度
    CGFloat angel = angelDail * indexPath.item;
    //每个 Item 的中心位置
    attrs.center = CGPointMake(circleCenter.x + circleRadius * cosf(angel), circleCenter.y - circleRadius * sinf(angel));
//    attrs.transform = CGAffineTransformMakeRotation(Random0_1);
    return attrs;
}
@end
