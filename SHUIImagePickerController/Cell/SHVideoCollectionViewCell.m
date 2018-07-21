//
//  SHVideoCollectionViewCell.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2018/7/21.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHVideoCollectionViewCell.h"

@interface SHVideoCollectionViewCell ()

@property (nonatomic,strong) UIImageView * playImageView;

@end

@implementation SHVideoCollectionViewCell

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.playImageView];
    }
    return self;
}



#pragma mark  ----  懒加载
-(UIImageView *)playImageView{
    
    if (!_playImageView) {
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 20) / 2, (self.frame.size.height - 20) / 2, 20, 20)];
        _playImageView.image = [UIImage imageNamed:@"SHUIImagePickerControllerLibrarySource.bundle/paly.tiff"];
        _playImageView.contentMode = UIViewContentModeScaleAspectFill;
        _playImageView.clipsToBounds = YES;
        _playImageView.backgroundColor = [UIColor grayColor];
    }
    return _playImageView;
}

@end
