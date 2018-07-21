//
//  SHUIImagePickerController.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerController.h"
#import "SHAssetImageModel.h"
#import "SHAssetVideoModel.h"

@interface SHUIImagePickerController ()

//当前相册中的所有图片
@property (nonatomic,strong) NSMutableArray<SHAssetBaseModel *> * shAssetModelArray;
//相机模型
@property (nonatomic,strong) SHAssetImageModel * cameraModel;

@end


@implementation SHUIImagePickerController

#pragma mark  ----  生命周期函数
+(SHUIImagePickerController *)sharedManager{

    static SHUIImagePickerController * controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[SHUIImagePickerController alloc] init];
    });
    return controller;
}


#pragma mark  ----  自定义函数

- (void)loadAllPhoto:(void(^)(NSMutableArray *arr))result
{
    [self.shAssetModelArray removeAllObjects];
    
    __weak __typeof(self)weakSelf = self;
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //按照时间倒叙排列
    
    //添加去相机模型
    [self.shAssetModelArray addObject:self.cameraModel];
    
    PHAssetMediaType type;
    if (self.sourceType == SourceImage) {
        
        type = PHAssetMediaTypeImage;
    }
    else if (self.sourceType == SourceVideo){
        
        type = PHAssetMediaTypeVideo;
    }
    else if (self.sourceType == SourceAudio){
        
        type = PHAssetMediaTypeAudio;
    }
    else{
        
        type = PHAssetMediaTypeImage;
    }

    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:type options:allPhotosOptions];
    
    if (allPhotosResult.count > 0) {
     
        [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {

            // 获取一个资源（PHAsset）
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    
                    if ([asset isKindOfClass:[AVURLAsset class]]) {
                     
                        NSURL *url = urlAsset.URL;
                        SHAssetVideoModel * videoModel = [[SHAssetVideoModel alloc] init];
                        videoModel.videoUrl = url;
                        [weakSelf.shAssetModelArray addObject:videoModel];
                    }
                    
                    if (idx ==  allPhotosResult.count - 1) {
                        
                        result(weakSelf.shAssetModelArray);
                        [weakSelf.shAssetModelArray removeAllObjects];
                    }
                }];
            }
            else{
                
                SHAssetImageModel * mAsset = [[SHAssetImageModel alloc] initWithAsset:asset];
                [weakSelf.shAssetModelArray addObject:mAsset];
                if (idx ==  allPhotosResult.count - 1) {
                    
                    result(weakSelf.shAssetModelArray);
                    [weakSelf.shAssetModelArray removeAllObjects];
                }
            }
        }];
    }
    else{
        
        result(weakSelf.shAssetModelArray);
        [weakSelf.shAssetModelArray removeAllObjects];
    }
}

//判断有无使用相册权限
-(AlbumState)getAlbumAuthority{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        //有访问相册权限
        return AlbumStatusAuthorized;
    }
    else if (status == PHAuthorizationStatusNotDetermined){
        
        [self requestAuthorizationStatus_AfteriOS8];
        return AlbumStatusNotDetermined;
    }
    else if (status == PHAuthorizationStatusRestricted){
        
        return AlbumStatusRestricted;
    }
    else{
        
        return AlbumStatusDenied;
    }
}

//判断有无照相机使用权限
-(CameraState)getCameraAuthority{

    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusAuthorized){
        
        return CameraStatusAuthorized;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            
        }];
        return CameraStatusNotDetermined;
    }
    else if (authStatus == AVAuthorizationStatusRestricted){
        
        return CameraStatusRestricted;
    }
    else{
    
        return CameraStatusDenied;
    }
}

//请求相册权限
- (void)requestAuthorizationStatus_AfteriOS8
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    
                    break;
                }
                default:
                {
                    break;
                }
            }
        });
    }];
}

//清理内存(本模块生命周期结束时调用)
-(void)clearMemary{

    [self.shAssetModelArray removeAllObjects];
}

#pragma mark  ----  懒加载
-(NSMutableArray<SHAssetBaseModel *> *)shAssetModelArray{

    if (!_shAssetModelArray) {
        
        _shAssetModelArray = [[NSMutableArray alloc] init];
    }
    return _shAssetModelArray;
}

-(SHAssetImageModel *)cameraModel{

    if (!_cameraModel) {
        
        _cameraModel = [[SHAssetImageModel alloc] init];
        _cameraModel.thumbnails = [UIImage imageNamed:@"SHUIImagePickerControllerLibrarySource.bundle/camera.tiff"];
    }
    return _cameraModel;
}


@end
