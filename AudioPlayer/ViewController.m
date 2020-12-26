//
//  ViewController.m
//  AudioPlayer
//
//  Created by Geeks_Chen on 2020/12/23.
//  Copyright © 2020 zezf. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic,assign)BOOL playing;
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Audio Player";
    
    AVAudioPlayer *audioPlayer = [self playerForFile:@"Wonderful Tonight"];
    self.audioPlayer = audioPlayer;

    UIButton *playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    playBtn.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 50);
    playBtn.backgroundColor = [UIColor redColor];
    [playBtn setTitle:@"play" forState:(UIControlStateNormal)];
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:playBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    stopBtn.frame = CGRectMake(10, 160, self.view.frame.size.width-20, 50);
    stopBtn.backgroundColor = [UIColor redColor];
    [stopBtn setTitle:@"stop" forState:(UIControlStateNormal)];
    [stopBtn addTarget:self action:@selector(stopAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:stopBtn];
    
    UIButton *pauseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    pauseBtn.frame = CGRectMake(10, 220, self.view.frame.size.width-20, 50);
    pauseBtn.backgroundColor = [UIColor redColor];
    [pauseBtn setTitle:@"pause" forState:(UIControlStateNormal)];
    [pauseBtn addTarget:self action:@selector(pauseAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pauseBtn];
    

    NSInteger duration = [self durationWithVideo:[[NSBundle mainBundle] URLForResource:@"Wonderful Tonight"
    withExtension:@"wav"]];
    NSLog(@"%ld",duration);
}

- (void)playAction {
    [self play];
}

- (void)stopAction {
    [self stop];
}

- (void)pauseAction {
    [self pause];
}

- (void)play {
    if (!self.playing) {
        NSTimeInterval delayTime = [self.audioPlayer deviceCurrentTime] + 0.01;
        [self.audioPlayer playAtTime:delayTime];
        self.playing = YES;
    }
}


- (void)stop {
    if (self.playing) {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0.0f;
        self.playing = NO;
    }
}

- (void)pause {
    if (self.playing) {
        [self.audioPlayer pause];
        self.playing = NO;
    }else{
        [self play];
    }
}

#pragma mark --获取音频文件的时长(秒)
-(NSInteger)durationWithVideo:(NSURL *)urlPath
{
    AVURLAsset *audioAsset=[AVURLAsset assetWithURL:urlPath];
    CMTime   durationTime = audioAsset.duration;
    NSInteger    reultTime=0;
    reultTime = CMTimeGetSeconds(durationTime);
    return  reultTime;
}
#pragma mark -- 创建一个音频播放器
- (AVAudioPlayer *)playerForFile:(NSString *)name {

    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name
                                             withExtension:@"wav"];

    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                                   error:&error];
    if (player) {
        player.numberOfLoops = -1; // loop indefinitely
        player.enableRate = YES;
        [player prepareToPlay];
    } else {
        NSLog(@"Error creating player: %@", [error localizedDescription]);
    }

    return player;
}

@end
