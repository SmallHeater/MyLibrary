//
//  SHCamera.m
//  SHCameraLibrary
//
//  Created by xianjunwang on 2018/4/18.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCamera.h"

@implementation SHCamera

#pragma mark  ----  生命周期函数
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self videoInput];
        [self previewLayer];

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
    
    float verson = [UIDevice currentDevice].systemVersion.floatValue;
    BOOL result = verson >= 10.0;
    
#ifdef result
    
    //版本为10.0以上
    AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    
    NSArray *devicesIOS  = devicesIOS10.devices;
    for (AVCaptureDevice *device in devicesIOS) {
        if ([device position] == position) {
            return device;
        }
    }
#else
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice * device in devices) {
        
        if (device.position == position) {
            
            return device;
        }
    }
#endif
    
    return nil;
}

- (AVCaptureDevice *)frontCamera{
    
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}


- (AVCaptureDevice *)backCamera{
    
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
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
