//
//  LineLayout.m
//  Layout
//
//  Created by LI on 16/7/14.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LineLayout.h"

static const CGFloat ItemHW = 150;

@implementation LineLayout

/** 一些初始化的工作最好在这里实现 */
- (void)prepareLayout{
    [super prepareLayout];
    
    //初始化每个 cell 的尺寸
    self.itemSize = CGSizeMake(ItemHW, ItemHW);
    CGFloat inset = (self.collectionView.frame.size.width - ItemHW) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = ItemHW * 0.1;
    //每一个 Item 都有自己的UICollectionViewLayoutAttributes
    //每一个 indexpath 都有自己的UICollectionViewLayoutAttributes
}

/** 只要显示的边界发生改变就重新布局,内部重新调用layoutAttributesForElementsInRect方法获得 cell 布局的属性 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

/** 有效距离:当item的中间x距离屏幕的中间x在ActiveDistance以内,才会开始放大, 其它情况都是缩小 */
static CGFloat const ActiveDistance = 150;
/** 缩放因素: 值越大, item就会越大 */
static CGFloat const ScaleFactor = 0.5;
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 0.计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    //1.取出默认的cell 的UICollectionViewLayoutAttributes
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // 计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //2.遍历布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 如果不在屏幕上,直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        // 每一个item的中点x
        CGFloat itemCenterX = attrs.center.x;
        
        // 差距越小, 缩放比例越大
        // 根据跟屏幕最中间的距离计算缩放比例
        CGFloat scale = 1 + ScaleFactor * (1 - (ABS(itemCenterX - centerX) / ActiveDistance));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
//        attrs.transform3D = CATransform3DMakeScale(scale, scale, -1);
    }
    return array;
}

/** 
 *  用来设置scrollview 停止滚动哪一刻的位置
 *  proposedContentOffset:原本scrollview 停止滚动哪一刻的位置
 *  velocity:滚动速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 1.计算出scrollView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    //计算屏幕最中间的 x 值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //3.遍历所有属性
    //设置最后需要调节的 X 值为无限大
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        //当(attrs.center.x - centerX)的绝对值小于需要调节的adjustOffsetX的值,就将其赋给adjustOffsetX
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

@end
