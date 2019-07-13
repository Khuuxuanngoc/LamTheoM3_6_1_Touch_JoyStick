//
//  JoyStick_UIView.h
//  LamTheoM3_6_1_Touch_JoyStick
//
//  Created by MakerLab VN on 6/23/19.
//  Copyright © 2019 MakerLab VN. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define EN_DEBUG_JOYSTICK_VIEW_KXN

#ifdef EN_DEBUG_JOYSTICK_VIEW_KXN
#define DB_JOYSTICKPRINT(fmt, ...)      NSLog(@"<JoyStickView Class>: " fmt,  ##__VA_ARGS__)
#else
    #define DB_JOYSTICKPRINT(fmt, ...)      do {} while (0)
#endif


NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    _JOYSTICK_TOP_LEFT_ = 0,
    _JOYSTICK_TOP_RIGHT_,
    _JOYSTICK_TOP_CENTER_,
    _JOYSTICK_BOT_LEFT_,
    _JOYSTICK_BOT_RIGHT_,
    _JOYSTICK_BOT_CENTER_,
    _JOYSTICK_CENTER_CENTER_
} PosistionOfJoyStick;

typedef enum
{
    _JOYSTICK_CODE_TIEN_ = 1,
    _JOYSTICK_CODE_LUI_ = 2,
    _JOYSTICK_CODE_PHAI,
    _JOYSTICK_CODE_TRAI,
    _JOYSTICK_CODE_TIEN_TRAI,
    _JOYSTICK_CODE_TIEN_PHAI,
    _JOYSTICK_CODE_LUI_TRAI,
    _JOYSTICK_CODE_LUI_PHAI,
    _JOYSTICK_CODE_STOP
} StateOfJoyStick;


@protocol JoyStick_UIViewDeLegate <NSObject>

@optional

-(void)JoyStick_UIViewGetDirection:(StateOfJoyStick)joyStickState withTag:(NSInteger)tag;
-(void)JoyStick_UIViewGetDistance:(float)joyStickState AndAngel :(float)angel_ withTag:(NSInteger)tag;

@end

@interface JoyStick_UIView : UIView
{
    CGPoint cgp_offsetOrigin;
}




@property (nonatomic, strong) IBOutlet UIView *viewBackground;
@property (nonatomic, strong) IBOutlet UIView *view_in;
@property (nonatomic, strong) IBOutlet UIView *touchZoneUIView;
@property (nonatomic, strong) IBOutlet UIView *circleOut_View;

@property (nonatomic,weak) id<JoyStick_UIViewDeLegate> delegate;

-(void)joyStickSetPosistion:(PosistionOfJoyStick)posistion;

//-(float)cal_angle_kxn1:(float)x andY:(float)y;

//+(void)initWithFrame(CGRect);

@end

NS_ASSUME_NONNULL_END
