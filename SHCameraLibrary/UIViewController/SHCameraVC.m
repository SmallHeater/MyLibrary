//
//  FirstViewController.m
//  SHCamera
//
//  Created by xianjunwang on 2018/4/17.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHCameraVC.h"
#import <AVFoundation/AVFoundation.h>


@interface SHCameraVC ()<AVCaptureMetadataOutputObjectsDelegate,AVCapturePhotoCaptureDelegate>{
    
    BOOL isGetFace;//是否已检测到人脸
}

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong)AVCaptureSession *session;
// AVCaptureDeviceInput对象是输入流
@property (nonatomic,strong)AVCaptureDeviceInput *videoInput;
// 照片输出流对象
@property (nonatomic,strong) AVCapturePhotoOutput * stillImageOutput;
//@property (nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;
// 预览图层,来显示照相机拍摄到的画面
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) AVCaptureMetadataOutput * outPut;

// 切换前后镜头的按钮
@property (nonatomic,strong)UIButton *toggleButton;
// 拍照按钮
@property (nonatomic,strong)UIButton *shutterButton;
// 放置预览图层的View
@property (nonatomic,strong)UIView *cameraShowView;
// 用来展示拍照获取的照片
@property (nonatomic,strong)UIImageView *imageShowView;

//使用的抓拍图片
@property (nonatomic,strong) UIImage * image;

@end

@implementation SHCameraVC

#pragma mark  ----  生命周期函数

- (id)init{
    
    self = [super init];
    if (self) {
        
        isGetFace = NO;
        [self initCameraShowView];
        [self initialSession];
        [self initImageShowView];
        [self initButton];
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setUpCameraLayer];
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (self.session) {
        
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    if (self.session) {
        
        [self.session stopRunning];
    }
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
                
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否使用本照片" preferredStyle:UIAlertControllerStyleAlert];
                __weak SHCameraVC * wekSelf = self;
                UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    wekSelf.imageShowView.image = nil;
                    isGetFace = NO;
                }];
                
                UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (wekSelf.image && wekSelf.returnBlock) {
                        
                        wekSelf.returnBlock(wekSelf.image);
                    }
                    [wekSelf.session stopRunning];
                    [wekSelf dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alertController addAction:cancleAction];
                [alertController addAction:sureAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    self.image = image;
    self.imageShowView.image = image;
}

#pragma mark  ----  系统函数
// 这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    NSArray *devices = [[AVCaptureDeviceDiscoverySession alloc]];
    for (AVCaptureDevice * device in devices) {
        
        if (device.position == position) {
            
            return device;
        }
    }
    return nil;
}

#pragma mark  ----  自定义函数
- (void)initialSession{
    
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];
    self.stillImageOutput = [[AVCapturePhotoOutput alloc] init];
    // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    
    AVCapturePhotoSettings * photoSetting =[AVCapturePhotoSettings photoSettingsWithFormat:outputSettings];
    [self.stillImageOutput capturePhotoWithSettings:photoSetting delegate:self];
    
//    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddInput:self.videoInput]) {
        
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.outPut = [[AVCaptureMetadataOutput alloc] init];
    [self.outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddOutput:self.outPut]) {
        
        [self.session addOutput:self.outPut];
    }
    self.outPut.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    //设置扫描区域
    self.outPut.rectOfInterest = self.cameraShowView.frame;
    
    
}

- (void)initCameraShowView{
    
    //self.view.frame
    self.cameraShowView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.cameraShowView];
}

- (void)initImageShowView{
    
    //屏幕宽高比
    float radio = [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height;
    
    self.imageShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height -200, 200 * radio, 200)];
    self.imageShowView.contentMode = UIViewContentModeScaleToFill;
    self.imageShowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageShowView];
}

- (void)initButton{
    
    /*
    self.shutterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shutterButton.frame =CGRectMake(10,30, 60, 30);
    self.shutterButton.backgroundColor = [UIColor cyanColor];
    [self.shutterButton setTitle:@"拍照"forState:UIControlStateNormal];
    [self.shutterButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shutterButton];
    self.toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.toggleButton.frame =CGRectMake(80,30, 100, 30);
    self.toggleButton.backgroundColor = [UIColor cyanColor];
    [self.toggleButton setTitle:@"切换摄像头"forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleButton];*/
}


- (AVCaptureDevice *)frontCamera{
    
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}



- (AVCaptureDevice *)backCamera{
    
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)setUpCameraLayer{
    
    if (self.previewLayer ==nil) {
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候,剪裁超出父视图范围的子视图部分,当取值为NO时,不剪裁子视图。
        [viewLayer setMasksToBounds:YES];
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [viewLayer addSublayer:self.previewLayer];
    }
}

// 这是拍照按钮的方法
- (void)shutterCamera{
    
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        
        return;
    }
    
//    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer,NSError *error) {
//
//        if (imageDataSampleBuffer == NULL) {
//
//            return;
//        }
//
//        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        UIImage *image = [UIImage imageWithData:imageData];
//        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
//        self.image = image;
//        self.imageShowView.image = image;
//    }];
}

// 这是切换镜头的按钮方法
- (void)toggleCamera{
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]count];
    if (cameraCount > 1) {
        
        NSError * error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
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
@end
