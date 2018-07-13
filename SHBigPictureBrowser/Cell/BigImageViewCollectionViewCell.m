//
//  BigImageViewCollectionViewCell.m
//  SHBigPictureBrowser
//
//  Created by xianjunwang on 2018/7/10.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "BigImageViewCollectionViewCell.h"

@interface BigImageViewCollectionViewCell ()

@property(nonatomic,strong) UIImageView * imageView;

@end

@implementation BigImageViewCollectionViewCell

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

#pragma mark  ----  SET
-(void)setShowImage:(UIImage *)showImage{
    
    if (showImage) {
        
        self.imageView.image = showImage;
    }
}

#pragma mark  ----  懒加载
-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor grayColor];
    }
    return _imageView;
}

@end
