//
//  ImageCell.m
//  Layout
//
//  Created by LI on 16/7/14.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()
/** 显示图片的 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
