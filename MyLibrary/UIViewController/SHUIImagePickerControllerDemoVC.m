//
//  ViewController.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerControllerDemoVC.h"
#import "SHUIImagePickerControllerLibrary.h"
#import "SHNavigationBar.h"
#import "SHBigPictureBrowser.h"


#define IMAGEBASETAG 1100

@interface SHUIImagePickerControllerDemoVC ()
//图片展示
@property (nonatomic,strong) UILabel * label;
//展示照片的ScrollView
@property (nonatomic,strong) UIScrollView * imageViewBGScrollView;
@property (nonatomic,strong) UIButton * gotoImagePickerBnt;
//存储图片模型的数组
@property (nonatomic,strong) NSMutableArray<SHAssetBaseModel *> * imageModelArray;
@end

@implementation SHUIImagePickerControllerDemoVC


#pragma mark  ----  生命周期函数


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationBar.navTitle = @"选照片演示";
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.imageViewBGScrollView];
    [self.view addSubview:self.gotoImagePickerBnt];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
-(void)gotoImagePickerBntClicked:(UIButton *)btn{

    for (UIImageView * imageView in self.imageViewBGScrollView.subviews) {

        [imageView removeFromSuperview];
    }
    [self.imageModelArray removeAllObjects];
    
    [SHUIImagePickerControllerLibrary goToSHUIImagePickerViewControllerWithMaxImageSelectCount:500 anResultBlock:^(NSMutableArray<SHAssetBaseModel *> *arr) {
        
        NSMutableArray * resultArray = [[NSMutableArray alloc] initWithArray:arr];
        [self.imageModelArray addObjectsFromArray:arr];
        arr = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            for (NSUInteger i = 0; i < resultArray.count; i++) {
                
                SHAssetBaseModel * model = resultArray[i];
                
                if ([model isMemberOfClass:[SHAssetImageModel class]]) {
                 
                    UIImageView * imageView = [[UIImageView alloc] initWithImage:model.thumbnails];
                    imageView.tag = IMAGEBASETAG + i;
                    imageView.frame = CGRectMake(i * 95, 5, 90, 90);
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
                    [imageView addGestureRecognizer:tap];
                    
                    if (i == resultArray.count - 1) {
                        
                        self.imageViewBGScrollView.contentSize = CGSizeMake(resultArray.count * 95, 90);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.imageViewBGScrollView addSubview:imageView];
                    });
                }
                else if([model isMemberOfClass:[SHAssetVideoModel class]]){
                    
                    SHAssetVideoModel * videoModel = (SHAssetVideoModel *)model;
                    NSLog(@"选中视频路径：%@",videoModel.videoUrl.absoluteString);
                }
            }
        });
    }];
}

//图片被点击
-(void)imageViewTaped:(UIGestureRecognizer *)ges{
    
    UIView * tapView = ges.view;
    NSUInteger index = tapView.tag - IMAGEBASETAG;
    
    NSMutableArray * imageArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.imageModelArray.count; i++) {
        
        SHAssetImageModel * model = (SHAssetImageModel *)self.imageModelArray[i];
        [imageArray addObject:model.originalImage];
    }
    
    if (imageArray.count > 0) {
        
        UIView * view = [SHBigPictureBrowser getViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) andImageArray:imageArray andSelectedIndex:index];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }
    else{
        
        
    }
}

#pragma mark  ----  懒加载

-(UIButton *)gotoImagePickerBnt{

    if (!_gotoImagePickerBnt) {
        
        _gotoImagePickerBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoImagePickerBnt.frame = CGRectMake(20, CGRectGetMaxY(self.imageViewBGScrollView.frame), 60, 40);
        [_gotoImagePickerBnt setTitle:@"去相册" forState:UIControlStateNormal];
        [_gotoImagePickerBnt setBackgroundColor:[UIColor grayColor]];
        [_gotoImagePickerBnt addTarget:self action:@selector(gotoImagePickerBntClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoImagePickerBnt;
}

-(UILabel *)label{

    if (!_label) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, 200, 16)];
        _label.text = @"图片展示";
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:14.0];
    }
    return _label;
}

-(UIScrollView *)imageViewBGScrollView{

    if (!_imageViewBGScrollView) {
        
        _imageViewBGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label.frame), [UIScreen mainScreen].bounds.size.width, 100)];
        _imageViewBGScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
        _imageViewBGScrollView.backgroundColor = [UIColor purpleColor];
    }
    return _imageViewBGScrollView;
}

-(NSMutableArray<SHAssetBaseModel *> *)imageModelArray{
    
    if (!_imageModelArray) {
        
        _imageModelArray = [[NSMutableArray alloc] init];
    }
    return _imageModelArray;
}
@end
