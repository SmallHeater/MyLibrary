//
//  ViewController.m
//  Watermark
//
//  Created by xianjunwang on 2017/12/11.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "WaterMarkViewController.h"
#import "SHWaterMarkLibrary.h"

@interface WaterMarkViewController ()
@property (nonatomic,strong) UIImageView * imageView;
//图片添加图片水印按钮
@property (nonatomic,strong) UIButton * imageAddWatermarkBtn;
//图片添加文字水印按钮
@property (nonatomic,strong) UIButton * imageAddWatermarkTwoBtn;
//添加水印层按钮
@property (nonatomic,strong) UIButton * addWatermarkLayerBtn;
@property (nonatomic,strong) NSURL * videoUrl;
//水印层
@property (nonatomic,strong) CATextLayer *textLayer;
@end

@implementation WaterMarkViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navTitle = @"水印组件演示";
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageAddWatermarkBtn];
    [self.view addSubview:self.imageAddWatermarkTwoBtn];
    [self.view addSubview:self.addWatermarkLayerBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
//图片添加水印
-(void)imageAddWatermarkBtnClicked{
    
    UIImage *waterIma = [UIImage imageNamed:@"MyLibrarySource.bundle/A_1.tiff"];
    UIImage * newImage = [SHWaterMarkLibrary setImage:self.imageView.image withWaterMarkImage:waterIma andFrame:CGRectMake(self.imageView.image.size.width - 20 - 5, self.imageView.image.size.height - 20 - 5, 20, 20)];
    self.imageView.image = newImage;
}

//图片添加文字水印
-(void)imageAddWatermarkTwoBtnClicked{
    
    UIImage * newImage = [SHWaterMarkLibrary setImage:self.imageView.image withWaterMarkPoint:CGPointMake(0, 40) andText:@"文字水印测试" andTextAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}];
    self.imageView.image = newImage;
}

//添加水印层按钮的响应
-(void)addWatermarkLayerBtnClicked{
    
    [self.view.layer addSublayer:self.textLayer];
}

#pragma mark  ----  懒加载
-(UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84, SCREENWIDTH, 200)];
        _imageView.image = [UIImage imageNamed:@"MyLibrarySource.bundle/videoplaceholdersmall.tiff"];
    }
    return _imageView;
}

-(UIButton *)imageAddWatermarkBtn{
    
    if (!_imageAddWatermarkBtn) {
    
        _imageAddWatermarkBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _imageAddWatermarkBtn.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 20, 140, 40);
        [_imageAddWatermarkBtn setTitle:@"图片添加图片水印" forState:UIControlStateNormal];
        [_imageAddWatermarkBtn addTarget:self action:@selector(imageAddWatermarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageAddWatermarkBtn;
}

-(UIButton *)imageAddWatermarkTwoBtn{
    
    if (!_imageAddWatermarkTwoBtn) {
        
        _imageAddWatermarkTwoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _imageAddWatermarkTwoBtn.frame = CGRectMake(CGRectGetMaxX(self.imageAddWatermarkBtn.frame) + 20, CGRectGetMaxY(self.imageView.frame) + 20, 140, 40);
        [_imageAddWatermarkTwoBtn setTitle:@"图片添加文字水印" forState:UIControlStateNormal];
        [_imageAddWatermarkTwoBtn addTarget:self action:@selector(imageAddWatermarkTwoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageAddWatermarkTwoBtn;
}

-(UIButton *)addWatermarkLayerBtn{
    
    if (!_addWatermarkLayerBtn) {
        
        _addWatermarkLayerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addWatermarkLayerBtn.frame = CGRectMake(20, CGRectGetMaxY(self.imageAddWatermarkBtn.frame) + 20, 140, 40);
        [_addWatermarkLayerBtn setTitle:@"添加水印层按钮" forState:UIControlStateNormal];
        [_addWatermarkLayerBtn addTarget:self action:@selector(addWatermarkLayerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addWatermarkLayerBtn;
}

-(CATextLayer *)textLayer{
    
    if (!_textLayer) {
        
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.frame = CGRectMake(0, 200, SCREENWIDTH, 36);
        _textLayer.string = [[NSAttributedString alloc] initWithString:@"1234567890" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:36.0],NSForegroundColorAttributeName:[UIColor greenColor]}];
        _textLayer.alignmentMode = @"center";
        _textLayer.opacity = 0.2;
        _textLayer.wrapped = YES;
        _textLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [_textLayer setAffineTransform:CGAffineTransformMakeRotation(-M_PI / 4)];
        //水印层，如果添加到keyWindow上，则整个app都有水印。适合用于视频播放的水印添加
    }
    return _textLayer;
}

@end
