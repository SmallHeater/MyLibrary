//
//  SHCameraLibraryVC.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/4/18.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCameraLibraryVC.h"
#import "SHCameraLibrary.h"


@interface SHCameraLibraryVC ()
@property (nonatomic,strong) UILabel * textLabel;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation SHCameraLibraryVC

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.navTitle = @"自定义相机组件演示";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.imageView];
    
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SHCameraLibrary snapshot:^(UIImage *image) {
            
            if (image) {
                
                self.imageView.image = image;
            }
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  懒加载

-(UILabel *)textLabel{
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH,44)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"即将自动抓拍";
    }
    return _textLabel;
}

-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        //屏幕宽高比
        float radio = [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height;
        float height = 500;
        float width = height * radio;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - width) / 2, CGRectGetMaxY(self.textLabel.frame), width, height)];
    }
    return _imageView;
}
@end
