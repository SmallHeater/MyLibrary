//
//  ELCVFlowLayout.m
//  SHBigPictureBrowser
//
//  Created by xianjunwang on 2018/8/2.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "ELCVFlowLayout.h"

@interface ELCVFlowLayout ()

@end


@implementation ELCVFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

// 作用:
// Invalidate:刷新
// 在拖动内容是否允许属性布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 什么时候调用:在拖动的时候,手指抬起调用
// 作用:返回最终偏移量,最终collectionView停到哪个位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 定位:判断下谁离中心点近,就显示在中心位置
    // 判断下最终显示那块区域
    // 获取最终显示区域
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, SCREENWIDTH, SCREENHEIGHT);
    
    // 获取最终显示区域下所有cell,去判断下哪个离中心点近
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    // 判断下哪个离中心点
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        // 获取中心点距离
        CGFloat delta =attr.center.x - (self.collectionView.contentOffset.x + SCREENWIDTH * 0.5);
        if (fabs(delta) <fabs(minDelta)) {
            minDelta = delta;
        }
    }
    
    proposedContentOffset.x += minDelta;
    
    if (proposedContentOffset.x < 0) {
        
        proposedContentOffset.x = 0;
    }
    
    NSLog(@"%f",proposedContentOffset.x);
    
    return proposedContentOffset;
}


@end
