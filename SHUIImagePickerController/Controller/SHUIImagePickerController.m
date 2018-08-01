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

#import <AssetsLibrary/AssetsLibrary.h>
//视频存储路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]


@interface SHUIImagePickerController ()

//当前相册中的所有图片
@property (nonatomic,strong) NSMutableArray<SHAssetBaseModel *> * shAssetModelArray;
//相机模型
@property (nonatomic,strong) SHAssetImageModel * cameraModel;

@property (nonatomic,strong) NSMutableArray * groupArrays;

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
    if (self.sourceType == SourceImage) {
        
        //选择图片
        PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //按照时间倒叙排列
        //添加去相机模型
        [self.shAssetModelArray addObject:self.cameraModel];
        
        PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
        
        if (allPhotosResult.count > 0) {
            
            [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
                
                // 获取一个资源（PHAsset）
                SHAssetImageModel * mAsset = [[SHAssetImageModel alloc] initWithAsset:asset];
                [weakSelf.shAssetModelArray addObject:mAsset];
                if (idx ==  allPhotosResult.count - 1) {
                    
                    result(weakSelf.shAssetModelArray);
                    [weakSelf.shAssetModelArray removeAllObjects];
                }
                else{
                    
                    result(weakSelf.shAssetModelArray);
                    [weakSelf.shAssetModelArray removeAllObjects];
                }
            }];
        }
    }
    else if (self.sourceType == SourceVideo){
        
        //选择视频
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    
                    [weakSelf.groupArrays addObject:group];
                } else {
                    
                    [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                            if ([result thumbnail] != nil) {
                                
                                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                                    
                                    UIImage * thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                                    
                                    ALAssetRepresentation * representation = result.defaultRepresentation;
                                    
                                    SHAssetVideoModel * videoModel = [[SHAssetVideoModel alloc] init];
                                    videoModel.thumbnails = thumbnail;
                                    videoModel.videoUrl = representation.url;
                                    videoModel.filename = representation.filename;
                                    videoModel.size = representation.size;
                                    [weakSelf.shAssetModelArray addObject:videoModel];
                                    
                                }
                            }
                        }];
                    }];
                    
                    //栅栏
                    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        result(weakSelf.shAssetModelArray);
                        [weakSelf.shAssetModelArray removeAllObjects];
                    });
                }
            };
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                         usingBlock:listGroupBlock failureBlock:nil];
        });
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

// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    // 创建存放原始图的文件夹--->VideoURL
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
        [fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:fileName];
                const char *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 11024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                }
            } failureBlock:nil];
        }
    });
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

-(NSMutableArray *)groupArrays{
    
    if (!_groupArrays) {
        
        _groupArrays = [[NSMutableArray alloc] init];
    }
    return _groupArrays;
}

@end
