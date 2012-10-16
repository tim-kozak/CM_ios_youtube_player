//
//  ViewController.m
//  CM_ios_youtube_player
//
//  Created by comonitos on 10/16/12.
//  Copyright (c) 2012 comonitos. All rights reserved.
//

#import "ViewController.h"
#import "CMYoutubeView.h"

@interface ViewController ()
{
    CMYoutubeView *player;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self load];
}
- (void) load {
    NSString *videoCode = @"etR713xJiMk";
    NSString *videoStringUrl = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@&autoplay=0&ios=1",videoCode];
    NSURL *url = [NSURL URLWithString:videoStringUrl];
    
    player = [[CMYoutubeView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) url:url];
    [self.view addSubview:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loaded) name:CM_YOUTUBE_PLAYER_DID_FINISH_LOADING_NOTIFICATION object:nil];
    
}
- (void) loaded {
    [player performSelector:@selector(play) withObject:nil afterDelay:3];
    //    [view performSelector:@selector(seekToTime:) withObject:nil afterDelay:10];
    [player performSelector:@selector(pause) withObject:nil afterDelay:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
