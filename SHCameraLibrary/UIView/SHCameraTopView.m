//
//  SHCameraTopView.m
//  SHCameraLibrary
//
//  Created by xianjunwang on 2018/5/22.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCameraTopView.h"

@interface SHCameraTopView ()<AVCaptureMetadataOutputObjectsDelegate>{
    
    BOOL isGetFace;//是否已检测到人脸
}

// 照片输出流对象
@property (nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic,strong) AVCaptureMetadataOutput * outPut;
@end


@implementation SHCameraTopView

#pragma mark  ----  生命周期函数
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self outPut];;
    }
    return self;
}

#pragma mark  ----  代理

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        
        if (!isGetFace) {
            
            isGetFace = YES;
            
            
            AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex :0];
            if (metadataObject.type == AVMetadataObjectTypeFace) {
                
                AVMetadataObject *objec = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                NSLog(@"人脸检测：%@",objec);
                 //识别到人脸，拍照
                 [self shutterCamera];
            }
        }
    }
}


// 这是拍照按钮的方法
- (void)shutterCamera{
    
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer,NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            
            return;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        if (self.returnBlock) {
         
            self.returnBlock(image);
        }
    }];
}

// 这是切换镜头的按钮方法
- (void)toggleCamera{
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]count];
    if (cameraCount > 1) {
        
        NSError * error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[self.videoInput device] position];
        
        if (position ==AVCaptureDevicePositionBack) {
            
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        } else if (position ==AVCaptureDevicePositionFront) {
            
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
            
        } else {
            
            return;
        }
        
        if (newVideoInput != nil) {
            
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                
                [self.session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            } else {
                
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

#pragma mark  ----  懒加载



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

@end
