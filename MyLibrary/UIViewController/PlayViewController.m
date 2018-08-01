//
//  PlayViewController.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/7/27.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "PlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface PlayViewController ()

//视频地址
@property (nonatomic,copy) NSString * sourceUrl;

@property (nonatomic,strong) MPMoviePlayerController * moviePlayer;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (nonatomic,assign) float total;

@property (nonatomic,strong) CADisplayLink * link;

@property (nonatomic,assign) NSTimeInterval lastTime;

@end

@implementation PlayViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.sourceUrl = @"https://testfileserver.iuoooo.com/Jinher.JAP.BaseApp.FileServer.UI/FileManage/GetFile?fileURL=29e54e46-3e17-4ca4-8f03-db71fb8f9556%2F2018072710%2F2af605c6-b7e4-436e-841a-ade4b63f86a0_IMG_0397.MOV";
    
    
    AVPlayerViewController * vc = [[AVPlayerViewController alloc] init];
    vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.sourceUrl]];
    vc.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    vc.showsPlaybackControls = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
    /*
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    
    
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.sourceUrl]];
//    //首先添加监听
//    [playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //初始化AVPlayer
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:playItem];
    //设置AVPlayer关联
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //设置视频模式
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    playerLayer.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    [self.view.layer addSublayer:playerLayer];
    //开始播放(请在真机上运行)
    [self.avPlayer play];
    */
    
    
    /*
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //播放
        [self.moviePlayer play];
    });
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark  ----  系统函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        //获取缓冲进度
        NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
        // 获取缓冲区域
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //开始的时间
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
        //表示已经缓冲的时间
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 计算缓冲总时间
        NSTimeInterval result = startSeconds + durationSeconds;
        NSLog(@"开始:%f,持续:%f,总时间:%f", startSeconds, durationSeconds, result);
        NSLog(@"视频的加载进度是:%%%f", durationSeconds / self.total * 100);
    }else if ([keyPath isEqualToString:@"status"]){
        //获取播放状态
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"准备播放");
            //获取视频的总播放时长
            [self.avPlayer play];
            self.total = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        } else{
            NSLog(@"播放失败");
        }
    }
}


#pragma mark  ----  自定义函数
/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}

- (void)upadte
{
    NSTimeInterval current = CMTimeGetSeconds(self.avPlayer.currentTime);
    
    if (current!=self.lastTime) {
        //没有卡顿
        NSLog(@"没有卡顿");
    }else{
        //卡顿了
        NSLog(@"卡顿了");
    }
    self.lastTime = current;
}



#pragma mark  ----  懒加载

-(MPMoviePlayerController *)moviePlayer{
    
    if (!_moviePlayer) {
        
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:self.sourceUrl]];
        _moviePlayer.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [self.view addSubview:_moviePlayer.view];
    }
    
    return _moviePlayer;
}


@end
