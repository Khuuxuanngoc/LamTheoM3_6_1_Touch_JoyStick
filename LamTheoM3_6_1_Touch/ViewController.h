//
//  ViewController.h
//  LamTheoM3_6_1_Touch
//
//  Created by MakerLab VN on 6/4/19.
//  Copyright © 2019 MakerLab VN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoyStick_UIView.h"
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController<JoyStick_UIViewDeLegate,WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
{
    StateOfJoyStick DirState;
}

@property (nonatomic,weak) IBOutlet UIWebView *myWebView;
@property (nonatomic,weak) IBOutlet UIWebView *kxnSendCommandWebView;
@property (nonatomic, weak) IBOutlet WKWebView * myWkWebview;

@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *loader;

@property (nonatomic, weak) IBOutlet UIView *myView;
@property (nonatomic,strong) JoyStick_UIView * leftJoyStick;
@property (nonatomic,strong) JoyStick_UIView * rightJoyStick;
@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *rightView;

@property (nonatomic,strong) JoyStick_UIView * centerJoyStick;

@property (nonatomic, strong) IBOutlet UIButton *BtnTest;
@property (nonatomic, strong) IBOutlet UISlider *sliderSpeed;

@end

