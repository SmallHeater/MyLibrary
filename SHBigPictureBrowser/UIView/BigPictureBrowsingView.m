//
//  BigPictureBrowsingView.m
//  SHBigPictureBrowser
//
//  Created by xianjunwang on 2018/7/10.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "BigPictureBrowsingView.h"
#import "BigImageViewCollectionViewCell.h"

@interface BigPictureBrowsingView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;

@end

@implementation BigPictureBrowsingView

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark  ----  代理函数
#pragma mark  ----  UICollectionViewDelegate

#pragma mark  ----  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BigImageViewCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BigImageViewCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark  ----  自定义函数

#pragma mark  ----  懒加载

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewLayout * layout = [[UICollectionViewLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[BigImageViewCollectionViewCell class] forCellWithReuseIdentifier:@"BigImageViewCollectionViewCell"];
    }
    return _collectionView;
}

@end
