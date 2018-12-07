//
//  BigPictureBrowsingView.m
//  SHBigPictureBrowser
//
//  Created by xianjunwang on 2018/7/10.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "BigPictureBrowsingView.h"
#import "BigImageViewCollectionViewCell.h"
#import "ELCVFlowLayout.h"

@interface BigPictureBrowsingView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;
//要显示的数据源数组
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UIPageControl * pageControl;
//显示图片索引
@property (nonatomic,assign) NSUInteger selectedIndex;

@end

@implementation BigPictureBrowsingView

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //数据源处理思路，截取当前选中位置前后各五个数据组成显示的数据源
        NSUInteger location = 0;
        NSUInteger length = 0;
        if (index < 5) {
            
            location = 0;
        }
        else{
            
            location = index - 5;
        }
        
        if (array.count < 11) {
            
            length = array.count;
        }
        else{
            
            length  = 11;
        }
        
        NSArray * tempArray = [array subarrayWithRange:NSMakeRange(location, length)];
        [self.dataArray addObjectsFromArray:tempArray];
        [self addSubview:self.collectionView];
        self.pageControl.currentPage = 5;
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark  ----  代理函数
#pragma mark  ----  UICollectionViewDelegate

#pragma mark  ----  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BigImageViewCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BigImageViewCollectionViewCell" forIndexPath:indexPath];
    cell.showImage = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataArray.count;
}

#pragma mark  ----  UICollectionViewDelegateFlowLayout

//返回每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
}

//返回上左下右四边的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回cell之间的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

//cell之间的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}


#pragma mark  ----  自定义函数

#pragma mark  ----  懒加载

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        ELCVFlowLayout * layout = [[ELCVFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[BigImageViewCollectionViewCell class] forCellWithReuseIdentifier:@"BigImageViewCollectionViewCell"];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(UIPageControl *)pageControl{
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT  - 16 - 20, SCREENWIDTH, 20)];
        _pageControl.numberOfPages = self.dataArray.count;
    }
    return _pageControl;
}

@end
