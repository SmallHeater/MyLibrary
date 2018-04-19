//
//  SHCamera.m
//  SHCameraLibrary
//
//  Created by xianjunwang on 2018/4/18.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCamera.h"
#import <AVFoundation/AVFoundation.h>


@interface SHCamera ()

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong)AVCaptureSession *session;
// AVCaptureDeviceInput对象是输入流
@property (nonatomic,strong)AVCaptureDeviceInput *videoInput;
// 照片输出流对象
@property (nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;
// 预览图层,来显示照相机拍摄到的画面
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) AVCaptureMetadataOutput * outPut;

@end


@implementation SHCamera

#pragma mark  ----  生命周期函数
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.session;
        self.videoInput;
        self.stillImageOutput;
        self.previewLayer;
        self.outPut;
        
        if (self.session) {
            
            [self.session startRunning];
        }
        
    
    }
    return self;
}

-(void)dealloc{
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}

#pragma mark  ----  自定义函数
// 这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice * device in devices) {
        
        if (device.position == position) {
            
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera{
    
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

#pragma mark  ----  懒加载

-(AVCaptureSession *)session{
    
    if (!_session) {
        
         _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

-(AVCaptureDeviceInput *)videoInput{
    
    if (!_videoInput) {
        
         _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
        if ([self.session canAddInput:self.videoInput]) {
            
            [self.session addInput:self.videoInput];
        }
    }
    return _videoInput;
}

-(AVCaptureStillImageOutput *)stillImageOutput{
    
    if (!_stillImageOutput) {
        
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [_stillImageOutput setOutputSettings:outputSettings];
        if ([self.session canAddOutput:self.stillImageOutput]) {
            
            [self.session addOutput:self.stillImageOutput];
        }
    }
    return _stillImageOutput;
}

-(AVCaptureMetadataOutput *)outPut{
    
    if (!_outPut) {
        
        self.outPut = [[AVCaptureMetadataOutput alloc] init];
        [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        if ([self.session canAddOutput:self.outPut]) {
            
            [self.session addOutput:self.outPut];
        }
        self.outPut.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        //设置扫描区域
        self.outPut.rectOfInterest = self.frame;
    }
    return _outPut;
}

-(AVCaptureVideoPreviewLayer *)previewLayer{
    
    if (!_previewLayer) {
        
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        CALayer * viewLayer = [self layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候,剪裁超出父视图范围的子视图部分,当取值为NO时,不剪裁子视图。
        [viewLayer setMasksToBounds:YES];
        CGRect bounds = [self bounds];
        [_previewLayer setFrame:bounds];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [viewLayer addSublayer:_previewLayer];
    }
    return _previewLayer;
}

@end
