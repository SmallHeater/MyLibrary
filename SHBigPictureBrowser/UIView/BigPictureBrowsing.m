//
//  BigPictureBrowsing.m
//  JHLivePlayDemo
//
//  Created by xianjunwang on 2017/9/6.
//  Copyright © 2017年 pk. All rights reserved.
//

#import "BigPictureBrowsing.h"
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSUInteger,IMAGETYPE){
    
    LocalPicture,//本地图片
    WebPicture   //网络图片
};

@interface BigPictureBrowsing ()<UIScrollViewDelegate>

//图片类型
@property (nonatomic,assign) IMAGETYPE imageType;

@property (nonatomic,strong) UIScrollView * scrollView;
//图片地址数组
@property (nonatomic,strong) NSArray * imageURLArray;
//图片数组
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) UIPageControl * pageControl;
//显示图片索引
@property (nonatomic,assign) NSUInteger selectedIndex;
@end


@implementation BigPictureBrowsing

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    
    self = [self initWithFrame:frame];
    if (self) {
        
        self.imageType = LocalPicture;
        self.selectedIndex = index;
        self.imageArray = [[NSArray alloc] initWithArray:array];
        [self setUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andImageURLArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    
    self = [self initWithFrame:frame];
    if (self) {
        
        self.imageType = WebPicture;
        self.selectedIndex = index;
        self.imageURLArray = [[NSArray alloc] initWithArray:array];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    float viewWidth = frame.size.width;
    float viewHeight = frame.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.scrollView.contentOffset = CGPointMake(SCREENWIDTH * self.selectedIndex, 0);
    self.pageControl.currentPage = self.selectedIndex;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

#pragma mark  ----  代理
#pragma mark  ----  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}

#pragma mark  ----  自定义函数
//设置UI
-(void)setUI{
    
    NSMutableArray * selectedArray = [[NSMutableArray alloc] init];
    if (self.imageType == LocalPicture) {
        
        [selectedArray addObjectsFromArray:self.imageArray];
    }
    else if(self.imageType == WebPicture){
        
        [selectedArray addObjectsFromArray:self.imageURLArray];
    }
    
    float viewWidth = self.frame.size.width;
    float viewHeight = self.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(viewWidth * selectedArray.count, viewHeight);
    
    for (NSUInteger i = 0; i < selectedArray.count; i++) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
        [imageView addGestureRecognizer:tap];
        
        
        if (self.imageType == LocalPicture) {
            
            UIImage * image = selectedArray[i];
            //根据image的比例来设置高度
            float radio = 1.00;
            if (image && image.size.width) {
                
                radio = image.size.height / image.size.width;
            }
            else
            {
                radio = 92.00/152.00;
            }
            
            if (image) {
                
                imageView.image = image;
            }
            else{
                
                //默认图
                imageView.image = [UIImage imageNamed:@"JHLivePlayBundle.bundle/haveNoEvidence.tiff"];
            }
            
            float imageViewWidth = SCREENWIDTH;
            float imageViewHeight = SCREENWIDTH * radio;
            imageView.frame = CGRectMake(i * imageViewWidth, (SCREENHEIGHT - imageViewHeight) / 2, imageViewWidth, imageViewHeight);
        }
        else if (self.imageType == WebPicture){
            
            NSURL * url = [NSURL URLWithString:self.imageURLArray[i]];
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"JHLivePlayBundle.bundle/haveNoEvidence.tiff"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                if (image) {
                    
                    //根据image的比例来设置高度
                    float radio = 1.00;
                    if (image && image.size.width) {
                        radio = image.size.height / image.size.width;
                    }
                    else
                    {
                        radio = 92.00/152.00;
                    }
                    
                    float imageViewWidth = SCREENWIDTH;
                    float imageViewHeight = SCREENWIDTH * radio;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        imageView.image = image;
                        imageView.frame = CGRectMake(i * imageViewWidth, (SCREENHEIGHT - imageViewHeight) / 2, imageViewWidth, imageViewHeight);
                    });
                }
            }];
        }
        
        [self.scrollView addSubview:imageView];
        self.scrollView.contentOffset = CGPointMake(SCREENWIDTH * self.selectedIndex, 0);
    }
}

-(void)imageTaped{
    
    [self removeFromSuperview];
}




#pragma mark  ----  懒加载

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT  - 16 - 20, SCREENWIDTH, 20)];
        if (self.imageURLArray.count > 0) {
            
            _pageControl.numberOfPages = self.imageURLArray.count;
        }
        else if (self.imageArray.count > 0){
        
            _pageControl.numberOfPages = self.imageArray.count;
        }
    }
    return _pageControl;
}

@end
