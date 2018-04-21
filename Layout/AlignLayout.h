//
//  AlignLayout.h
//  Layout
//
//  Created by Jack on 2018/4/21.
//  Copyright © 2018年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlignType){
    AlignTypeLeft,
    AlignTypeCenter,
    AlignTypeRight
};

@interface AlignLayout : UICollectionViewFlowLayout
/** 对齐类型 */
@property (assign, nonatomic) AlignType alignType;
@end
