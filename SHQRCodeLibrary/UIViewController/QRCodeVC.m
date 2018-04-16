//
//  QRCodeVC.m
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import "QRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"

#define FRAMEWIDTH 233

@interface QRCodeVC()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
}

//半透明背景
@property (nonatomic,strong) QRCodeBacgrouView * backgroundView;
//扫描区域
@property (nonatomic,strong) QRCodeAreaView * areaView;

@end

@implementation QRCodeVC

#pragma mark  ---- 生命周期函数

-(void)viewDidLoad{
    
    [super viewDidLoad];

    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.areaView];
    [self setQRCode];
}

#pragma mark  ----  代理函数
#pragma mark  ----  AVCaptureMetadataOutputObjectsDelegate
//二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];//停止扫描
        [_areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        //输出扫描字符串
        self.resuatBlock(metadataObject.stringValue);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark  ----  自定义函数
-(void)setQRCode{

    /**
     *  初始化二维码扫描
     */
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(self.areaView.frame.origin.y/SCREENHEIGHT, self.areaView.frame.origin.x/SCREENWIDTH, self.areaView.frame.size.height/SCREENHEIGHT, self.areaView.frame.size.width/SCREENWIDTH);
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式，支持条形码和二维码
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
}

-(void)endBtnClicked:(UIButton *)btn{
    
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


#pragma mark  ----  懒加载

-(QRCodeBacgrouView *)backgroundView{

    if (!_backgroundView) {
        
        _backgroundView = [[QRCodeBacgrouView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _backgroundView;
}
-(QRCodeAreaView *)areaView{

    if (!_areaView) {
        
        _areaView = [[QRCodeAreaView alloc]initWithFrame:CGRectMake((SCREENWIDTH - FRAMEWIDTH)/2, (SCREENHEIGHT - FRAMEWIDTH)/2, FRAMEWIDTH, FRAMEWIDTH)];
        //提示文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_areaView.frame) + 20, SCREENWIDTH, 14)];
        label.text = @"将条形码放入框内，即可自动识别";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        UIButton * endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [endBtn setImage:[UIImage imageNamed:@"SHQRCodeLibrarySource.bundle/cross.tiff"] forState:UIControlStateNormal];
        endBtn.frame = CGRectMake((SCREENWIDTH - 42) / 2, CGRectGetMaxY(label.frame) + 83, 42, 42);
        [endBtn addTarget:self action:@selector(endBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:endBtn];
    }
    return _areaView;
}

@end
