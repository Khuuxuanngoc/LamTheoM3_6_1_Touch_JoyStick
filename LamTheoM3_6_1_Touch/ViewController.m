//
//  ViewController.m
//  LamTheoM3_6_1_Touch
//
//  Created by MakerLab VN on 6/4/19.
//  Copyright © 2019 MakerLab VN. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define EN_DEBUG_VIEWCONTROLLER_VIEW_KXN

#ifdef EN_DEBUG_VIEWCONTROLLER_VIEW_KXN
#define DB_VIEWCONTROLLER_PRINT(fmt, ...)      NSLog(@"<ViewController Class>: " fmt,  ##__VA_ARGS__)
#else
#define DB_VIEWCONTROLLER_PRINT(fmt, ...)      do {} while (0)
#endif

#define SCREEN_WIDTH            [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen]bounds].size.height
#define STATUS_HEIGHT           [[UIApplication sharedApplication]statusBarFrame].size.height

#define WEB_URL                 @"https://vnexpress.net"


#define CAR_API                 @"http://192.168.4.1/?HshopWiFiCar=Pin=100,Speed=100,Servo1=50,Servo2=160,Light=1,Buzzer=0,Controller="
#define CAR_FORWARD_API         CAR_API@"1"

#define CAR_CAMERA_API          @"http://192.168.4.2"
//#define CAR_CAMERA_API          @"https://media.giphy.com/media/27c2ZeRWbda3NofroH/giphy.gif"
//#define CAR_FORWARD_API         @"http://192.168.4.1:9001"

@interface ViewController ()

@end

@implementation ViewController
@synthesize myWebView;
@synthesize kxnSendCommandWebView;
@synthesize myWkWebview;
@synthesize loader;

@synthesize myView;
@synthesize leftJoyStick;
@synthesize rightJoyStick;
@synthesize leftView;
@synthesize rightView;

@synthesize BtnTest;
@synthesize sliderSpeed;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self setUpTap];
//    [self setupSwipGesture];
//    [self setupLongPressGesture];
//    [self setupPanGesture];
//    [self setupPinchGesture];
//    [self setupRotationGesture];
//    [self setUpWebView];
    
//    [self setUpWkWebView];
//    [self setUpJoyStick];
//
//    [self setUpTimerSendControl_API];
//    [self setUpWebViewCommand];
    
    [self setUpVideo];
//    NSLog(@" powf (4,2): %f", powf(4,2));
    DB_VIEWCONTROLLER_PRINT(@"");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - JoyStick setUp
-(void)setUpJoyStick
{
    [leftView setFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT)];
    [rightView setFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    
//    [rightView setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    
    [leftView setAlpha:0];
    [rightView setAlpha:0];
    
//    leftJoyStick = [[JoyStick_UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    rightJoyStick = [[JoyStick_UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    leftJoyStick = [[JoyStick_UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    
    rightJoyStick.tag = 1;
    leftJoyStick.tag = 0;
    
    leftJoyStick.delegate = self;
    
    [rightJoyStick joyStickSetPosistion: _JOYSTICK_BOT_RIGHT_];
    [leftJoyStick joyStickSetPosistion: _JOYSTICK_BOT_LEFT_];
    
    [self.view addSubview:leftJoyStick];
    [self.view addSubview:rightJoyStick];
    [self.view bringSubviewToFront:BtnTest];
    [self.view bringSubviewToFront:sliderSpeed];
    
    DirState = _JOYSTICK_CODE_STOP;
    
//    [self setupSwipGesture];
//    NSString* numString = [[NSString alloc] initWithFormat: @"%d", 2];
//    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
}

//#pragma mark - tap function
//-(void)setUpTap
//{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector (tapAction:)];
//    tap.numberOfTapsRequired = 3;
//    [self.view addGestureRecognizer:tap];
//}
//
//-(void)tapAction:(UITapGestureRecognizer*)gesture
//{
//    NSLog(@"Tap Action");
//    CGPoint point = [gesture locationInView:[self view]];
//    NSLog(@"X: %f, Y: %f", point.x, point.y);
//}

//#pragma mark - touch function
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"Touch began");
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:[self leftView]];
//
//    NSLog(@"X: %f, Y: %f", point.x, point.y);
//    if ((point.x <= 200) &&
//        (point.x >= leftJoyStick.bounds.size.width/2) &&
//        (point.y <= SCREEN_HEIGHT - (leftJoyStick.bounds.size.height/2))) {
//        [UIView animateWithDuration:0.1 animations:^{
//            leftJoyStick.center = point;
//        }];
//    }
//}

//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"Touch Move");
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:[self leftJoyStick]];
//
//    NSLog(@"X: %f, Y: %f", point.x, point.y);
//    myView.center = point;
//}
//
//#pragma mark - SwipeGestureRecognizer
-(void)setupSwipGesture
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeActionLeft:)];

    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.rightView addGestureRecognizer:swipe];

    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeActionRight:)];

    swipe2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rightView addGestureRecognizer:swipe2];
}

-(void)swipeActionLeft:(UISwipeGestureRecognizer*)gesture
{
    NSLog(@"swipeAction left");
    CGPoint point = [gesture locationInView:[self view]];
    NSLog(@"X: %f, Y: %f", point.x, point.y);
}

-(void)swipeActionRight:(UISwipeGestureRecognizer*)gesture
{
    NSLog(@"swipeAction Right");
    CGPoint point = [gesture locationInView:[self view]];
    NSLog(@"X: %f, Y: %f", point.x, point.y);
}

//#pragma mark - LongPressGestureRecognizer
//-(void)setupLongPressGesture
//{
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
//
//    [self.view addGestureRecognizer:longPress];
//
//}
//
//-(void)longPressAction:(UILongPressGestureRecognizer*)gesture
//{
//    NSLog(@"longPressAction");
//    CGPoint point = [gesture locationInView:[self view]];
//    NSLog(@"X: %f, Y: %f", point.x, point.y);
//}
//
//#pragma mark - PanGestureRecognizer
//-(void)setupPanGesture
//{
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
//
//    [self.view addGestureRecognizer:pan];
//
//}
//
//-(void)panAction:(UIPanGestureRecognizer*)gesture
//{
//    NSLog(@"Pan Action");
//    CGPoint point = [gesture locationInView:[self view]];
//    NSLog(@"X: %f, Y: %f", point.x, point.y);
//}
//
//#pragma mark - PinchGestureRecognizer
//-(void)setupPinchGesture
//{
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
//
//    [self.view addGestureRecognizer:pinch];
//
//}
//
//-(void)pinchAction:(UIPinchGestureRecognizer*)gesture
//{
//    NSLog(@"Pinch Action");
//    NSLog(@"Scale %f", [gesture scale]);
////    CGPoint point = [gesture locationInView:[self view]];
////    NSLog(@"X: %f, Y: %f", point.x, point.y);
//}
//
//#pragma mark - RotationGestureRecognizer
//-(void)setupRotationGesture
//{
//    UIRotationGestureRecognizer *rotation1 = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction:)];
//
//    [self.view addGestureRecognizer:rotation1];
//
//}
//
//-(void)rotationAction:(UIRotationGestureRecognizer*)gesture
//{
//    NSLog(@"Rotation Action");
//    NSLog(@"Radian %f", [gesture rotation]);
//    //    CGPoint point = [gesture locationInView:[self view]];
//    //    NSLog(@"X: %f, Y: %f", point.x, point.y);
//}

#pragma mark - WebViewCommand setup
-(void)setUpWebViewCommand
{
    [kxnSendCommandWebView setFrame:CGRectMake(0, 0, 1, 1)];
    
    kxnSendCommandWebView.scrollView.bounces = NO;
    kxnSendCommandWebView.delegate = self;
    //    [myWebView setBackgroundColor:[UIColor redColor]];
    //    myWebView.opaque = NO;
    
    NSURL *url = [NSURL URLWithString:CAR_FORWARD_API];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [kxnSendCommandWebView loadRequest:request];
    
}

-(void)sendCommand:(NSString *)Str_Command
{
    NSURL *url = [NSURL URLWithString:Str_Command];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [kxnSendCommandWebView loadRequest:request];
}

#pragma mark - WebView setup
-(void)setUpWebView
{
    [myWebView setFrame:CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_HEIGHT)];
    
    myWebView.scrollView.bounces = NO;
    myWebView.delegate = self;
    
    loader.center = myWebView.center;
    [loader setHidden:YES];
    
    
    //    [myWebView setBackgroundColor:[UIColor redColor]];
    //    myWebView.opaque = NO;
    
        NSURL *url = [NSURL URLWithString:CAR_CAMERA_API];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [myWebView loadRequest:request];
        [myWebView setAllowsLinkPreview:YES];
    
}

#pragma mark - WkWebView setup
-(void)setUpWkWebView
{
    [myWkWebview setFrame:CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_HEIGHT)];
    
    myWkWebview.scrollView.bounces = NO;
//    myWkWebview.delegate = self;
    
    loader.center = myWkWebview.center;
    [loader setHidden:YES];
    
    
    [myWkWebview setBackgroundColor:[UIColor redColor]];
    //    myWebView.opaque = NO;
    
    NSURL *url = [NSURL URLWithString:CAR_CAMERA_API];
//    NSURL *url = [NSURL URLWithString:WEB_URL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [myWkWebview loadRequest:request];
    
    [myWkWebview setAllowsLinkPreview:YES];
    
}

#pragma mark - UIWkWebView's delegate

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"WKWebView didStartProvisionalNavigation");
}
#pragma mark - UIWebView's delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Web Start load");
    [loader setHidden:NO];
    [loader startAnimating];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Web finish load====");
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    NSLog(@"%@",html);
    
    [loader stopAnimating];
    [loader setHidden:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Web error load");
    [loader stopAnimating];
    [loader setHidden:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"LINK: %@",[[request URL]absoluteString]);
    
    if([[[request URL]absoluteString]containsString:@"vnexpress.net/the-thao"])
    {
        if([[UIApplication sharedApplication]canOpenURL:[request URL]])
        {
            [[UIApplication sharedApplication]openURL:[request URL] options:nil completionHandler:nil];
        }
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - JoyStick 's Delegate
-(void)JoyStick_UIViewGetDirection:(StateOfJoyStick)joyStickState withTag:(NSInteger)tag
{
    DB_VIEWCONTROLLER_PRINT(@"Joystick tag: %ld, state: %d", tag, joyStickState);
    DirState = joyStickState;
}

#pragma mark - Timer test
- (void) setUpTimerSendControl_API
{
    //Start playing an audio file.
    
    //NSTimer calling Method B, as long the audio file is playing, every 5 seconds.
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self selector:@selector(sendControl_API:) userInfo:nil repeats:YES];
}

- (void) sendControl_API:(NSTimer *)timer
{
    //Do calculations.
    
    NSString *temAPI = [NSString stringWithFormat:CAR_API @"%d",DirState];
    
    NSURL *url = [NSURL URLWithString:temAPI];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [kxnSendCommandWebView loadRequest:request];
//    NSLog(@"Count: %f", count);
}

//- (void) methodA
//{
//    //Start playing an audio file.
//
//    //NSTimer calling Method B, as long the audio file is playing, every 5 seconds.
//    [NSTimer scheduledTimerWithTimeInterval:0.1f
//                                     target:self selector:@selector(methodB:) userInfo:nil repeats:YES];
//}
//
//- (void) methodB:(NSTimer *)timer
//{
//    //Do calculations.
//
//    static float count = 0.0;
//    count++;
//    NSLog(@"Count: %f", count);
//}

-(IBAction)btn_Forward
{
    [self sendCommand:CAR_FORWARD_API];
    
}



@end
