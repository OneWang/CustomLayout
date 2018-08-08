//
//  AlignLayout.m
//  Layout
//
//  Created by Jack on 2018/4/21.
//  Copyright © 2018年 LI. All rights reserved.
//  设置cell的对齐方式，左对齐，居中对齐和右对齐

#import "AlignLayout.h"

static const float space = 10;

@interface AlignLayout (){
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    CGFloat _sumWidth ;
}
@end

@implementation AlignLayout

/** 一些初始化的工作最好在这里实现 */
- (void)prepareLayout{
    [super prepareLayout];
    
    //初始化每个 cell 的尺寸
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
    self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    //每一个 Item 都有自己的UICollectionViewLayoutAttributes
    //每一个 indexpath 都有自己的UICollectionViewLayoutAttributes
}

/** 只要显示的边界发生改变就重新布局,内部重新调用layoutAttributesForElementsInRect方法获得 cell 布局的属性 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个cell在本行，这开始调整Frame位置
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

- (void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    switch (_alignType) {
        case AlignTypeLeft:
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + space;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        case AlignTypeCenter:
            nowWidth = (self.collectionView.frame.size.width - _sumWidth - (layoutAttributes.count * space)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + space;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        case AlignTypeRight:
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - space;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        default:
            break;
    }
}

@end
