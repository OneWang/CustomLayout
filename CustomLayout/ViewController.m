//
//  ViewController.m
//  Layout
//
//  Created by LI on 16/7/14.
//  Copyright © 2016年 LI. All rights reserved.
//

#define k_Screen_width [UIScreen mainScreen].bounds.size.width
#define k_Screen_hight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "ImageCell.h"
#import "LineLayout.h"
#import "StackLayout.h"
#import "CircleLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 显示图片的数组 */
@property (strong, nonatomic) NSMutableArray *images;
/** collectionview */
@property (weak, nonatomic) UICollectionView *collectionView;
@end

@implementation ViewController
static NSString *const ID = @"image";
- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
        for (int i = 1; i < 20; i++) {
            [self.images addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 100, k_Screen_width,300);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[CircleLayout alloc] init]];
    collectionView.backgroundColor = [UIColor lightGrayColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[StackLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[CircleLayout alloc] init] animated:YES];
    }else{
        [self.collectionView setCollectionViewLayout:[[StackLayout alloc] init] animated:YES];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.imageName = self.images[indexPath.item];
    return cell;
}

#pragma mark UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //删除模型数据
//    [self.images removeObjectAtIndex:indexPath.item];
//    //删 UI(刷新 UI 界面)
//    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
//}

@end
