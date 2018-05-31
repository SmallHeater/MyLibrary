//
//  FirstViewController.m
//  SHCamera
//
//  Created by xianjunwang on 2018/4/17.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SHCameraTopView.h"

@interface SHCameraVC ()<AVCaptureMetadataOutputObjectsDelegate>



// 用来展示拍照获取的照片
@property (nonatomic,strong)UIImageView *imageShowView;
@property (nonatomic,strong) SHCameraTopView * cameraView;

@end

@implementation SHCameraVC

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.imageShowView];
}

#pragma mark  ----  懒加载


-(SHCameraTopView *)cameraView{
    
    if (!_cameraView) {
        
        _cameraView = [[SHCameraTopView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        
        __weak typeof(self) wkself = self;
        _cameraView.returnBlock = ^(UIImage *image) {
            
            wkself.imageShowView.image = image;
        };
    }
    return _cameraView;
}

-(UIImageView *)imageShowView{
    
    if (!_imageShowView) {
        
        //宽高比
        float radio = SCREENWIDTH / SCREENHEIGHT;
        float imageViewHeight = 200;
        float imageViewWidth = radio * imageViewHeight;
        _imageShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - imageViewHeight, imageViewWidth, imageViewHeight)];
        _imageShowView.backgroundColor = [UIColor whiteColor];
    }
    return _imageShowView;
}

@end
