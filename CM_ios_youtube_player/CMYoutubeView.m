//
//  YoutubeView.m
//  conficane_test
//
//  Created by comonitos on 10/16/12.
//
//

#import "CMYoutubeView.h"

@interface CMYoutubeView()
{
    NSURL *_url;
    UIWebView *_webView;
    UIActivityIndicatorView *_indicator;
    BOOL isLoaded;
}
@end

@implementation CMYoutubeView

- (id)initWithFrame:(CGRect)frame url:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        _url = [url retain];
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor blackColor];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.frame = CGRectMake((frame.size.width-_indicator.frame.size.width)/2, (frame.size.height-_indicator.frame.size.height)/2, _indicator.frame.size.width, _indicator.frame.size.height);
        _indicator.hidesWhenStopped = YES;
        [_indicator startAnimating];
        [self addSubview:_indicator];
        [_indicator release];
        
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;

        //magic parameter 1  _webView.allowsInlineMediaPlayback = YES;

        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
        for (id subview in _webView.subviews){
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).bounces = NO;
        }
        [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    }
    return self;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    BOOL match = ([html rangeOfString:@"<video" options:NSCaseInsensitiveSearch].location != NSNotFound);
    if (match) {
        if (isLoaded)
        {
            _webView.delegate = nil;
            
            [self insertSubview:_webView belowSubview:_indicator];
            [_webView release];

            [_indicator stopAnimating];
            [[NSNotificationCenter defaultCenter] postNotificationName:CM_YOUTUBE_PLAYER_DID_FINISH_LOADING_NOTIFICATION object:self];
            
        } else {
            isLoaded = YES;
            //magic parameter 2  webkit-playsinline 
            //<meta name='viewport' content='width=320; initial-scale=1.0; maximum-scale=1.0'/>
            html = [NSString stringWithFormat:@"<html><head><script>function seek(time){ var myVideo=document.getElementsByClassName('bc')[0]; pause(); myVideo.currentTime = parseInt(time); play(); } function play(){ var myVideo=document.getElementsByClassName('bc')[0]; myVideo.play();}function pause(){ var myVideo=document.getElementsByClassName('bc')[0]; myVideo.pause();}</script><style>body{background:#000;}*{padding:0;margin:0;} video{width:100%%;height:100%%;}</style></head><body><video webkit-playsinline %@/video></body></html>",[self stringBetweenString:@"<video" andString:@"/video>" innerString:html]];
            
            [webView loadHTMLString:html baseURL:[NSURL URLWithString:@""]];
        }
    }
}

- (void) play {
    [_webView stringByEvaluatingJavaScriptFromString:@"play()"];
    [[NSNotificationCenter defaultCenter] postNotificationName:CM_YOUTUBE_PLAYER_DID_START_PLAYING_NOTIFICATION object:self];
}
- (void) pause {
    [_webView stringByEvaluatingJavaScriptFromString:@"pause()"];
    [[NSNotificationCenter defaultCenter] postNotificationName:CM_YOUTUBE_PLAYER_DID_STOP_PLAYING_NOTIFICATION object:self];
}
- (void) seekToTime:(NSTimeInterval)seconds
{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"seek('%f')",seconds]];
    [[NSNotificationCenter defaultCenter] postNotificationName:CM_YOUTUBE_PLAYER_DID_FINISH_LOADING_NOTIFICATION object:self];
}


- (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

@end
