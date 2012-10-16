//
//  YoutubeView.h
//  conficane_test
//
//  Created by comonitos on 10/16/12.
//
//
#define CM_YOUTUBE_PLAYER_DID_START_PLAYING_NOTIFICATION @"CM_YOUTUBE_PLAYER_DID_START_PLAYING_NOTIFICATION"
#define CM_YOUTUBE_PLAYER_DID_STOP_PLAYING_NOTIFICATION @"CM_YOUTUBE_PLAYER_DID_STOP_PLAYING_NOTIFICATION"
#define CM_YOUTUBE_PLAYER_DID_FINISH_LOADING_NOTIFICATION @"CM_YOUTUBE_PLAYER_DID_FINISH_LOADING_NOTIFICATION"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CMYoutubeView : UIView <UIWebViewDelegate>

- (id)initWithFrame:(CGRect)frame url:(NSURL *)url;

- (void) play;
- (void) pause;
- (void) seekToTime:(NSTimeInterval)seconds;

@end
