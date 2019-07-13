//
//  JoyStick_UIView.m
//  LamTheoM3_6_1_Touch_JoyStick
//
//  Created by MakerLab VN on 6/23/19.
//  Copyright © 2019 MakerLab VN. All rights reserved.
//

#import "JoyStick_UIView.h"

#define X_VIEWBACKGROUND                        (self.circleOut_View.center.x)
#define Y_VIEWBACKGROUND                        (self.circleOut_View.center.y)

#define R_VIEWBACKGROUND                        (70)

#define R_VIEWIN                                (30)
#define JOYSTICK_MAGRIN                          (10)

#define Huyen_LENGTH_VIEWIN_INBACKGROUND        (R_VIEWBACKGROUND - R_VIEWIN/2)
//#define GET_ANGEL_TAN2(xnew, ynew)              (atan2(ynew, xnew) + M_PI/2)

#define GET_ANGEL_TAN2(xnew, ynew)              ([self cal_angle_kxn:xnew andY:ynew] + M_PI/2)
#define X_VIEWIN_MAX(angle)                     (sinf(angle) * Huyen_LENGTH_VIEWIN_INBACKGROUND) + X_VIEWBACKGROUND
#define Y_VIEWIN_MAX(angle)                      (cosf(angle) * Huyen_LENGTH_VIEWIN_INBACKGROUND) + Y_VIEWBACKGROUND


#define DEBUGLOG(fmt, ...) NSLog(fmt,  ##__VA_ARGS__)

@implementation JoyStick_UIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// Tham khao: https://www.youtube.com/watch?v=xP7YvdlnHfA
@synthesize viewBackground;
@synthesize view_in;
@synthesize touchZoneUIView;
@synthesize circleOut_View;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    cgp_offsetOrigin = frame.origin;
    
    DB_JOYSTICKPRINT(@"Tag %d, x= %f, y= %f", 100, cgp_offsetOrigin.x,cgp_offsetOrigin.y);
    
    if (self) {
        
        circleOut_View = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, R_VIEWBACKGROUND*2, R_VIEWBACKGROUND*2)];
        
        touchZoneUIView = [[UIView alloc]initWithFrame:frame];
        [touchZoneUIView setBackgroundColor:[UIColor blueColor]];
        [touchZoneUIView setAlpha:0.0];

        [circleOut_View setBackgroundColor:[UIColor grayColor]];
        circleOut_View.layer.cornerRadius = [self.circleOut_View bounds].size.height/2;
        circleOut_View.layer.masksToBounds = NO;
        circleOut_View.layer.borderWidth = 1;
        circleOut_View.alpha = 0.3;
        
        view_in = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, R_VIEWIN*2, R_VIEWIN*2)];
        
        view_in.center = circleOut_View.center;
        
        [view_in setBackgroundColor:[UIColor redColor]];
        view_in.layer.cornerRadius = R_VIEWIN;
        view_in.layer.masksToBounds = YES;
        view_in.layer.borderWidth = 1;
        view_in.alpha = 0.7;
        
        // 3. add as a subview
//        [self addSubview:self.view_in];
        [self addSubview:self.circleOut_View];
        [self addSubview:self.view_in];
        [self addSubview:self.touchZoneUIView];
        [self bringSubviewToFront:touchZoneUIView];
    }
    return self;
}

#pragma mark - set JoyStick
-(void)joyStickSetPosistion:(PosistionOfJoyStick)posistion
{
    float touchWidth = touchZoneUIView.bounds.size.width;
    float touchHeight = touchZoneUIView.bounds.size.height;
    
    switch (posistion) {
        case _JOYSTICK_CENTER_CENTER_:
            view_in.center = circleOut_View.center = CGPointMake(touchWidth/2, touchHeight/2);
            DB_JOYSTICKPRINT(@"Tag %d, x= %f, y= %f", self.tag, cgp_offsetOrigin.x,cgp_offsetOrigin.y);
            break;
            
        case _JOYSTICK_BOT_LEFT_:
            view_in.center = circleOut_View.center = CGPointMake( R_VIEWBACKGROUND + JOYSTICK_MAGRIN, touchHeight - R_VIEWBACKGROUND - JOYSTICK_MAGRIN);
            break;
            
        case _JOYSTICK_BOT_RIGHT_:
            view_in.center = circleOut_View.center = CGPointMake(touchWidth -  R_VIEWBACKGROUND - JOYSTICK_MAGRIN, touchHeight - R_VIEWBACKGROUND - JOYSTICK_MAGRIN);
            break;
            
        default:
            break;
    }
    
}

#pragma mark - touch function

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DB_JOYSTICKPRINT(@"Touch began");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[self touchZoneUIView]];
    
    
    CGPoint temPoint;
    temPoint.x = point.x + cgp_offsetOrigin.x;
    temPoint.y = point.y + cgp_offsetOrigin.y;
    
    CGPoint temPointMax, temPointMin;
    temPointMin.x = cgp_offsetOrigin.x + R_VIEWBACKGROUND;
    temPointMax.x = touchZoneUIView.bounds.size.width + cgp_offsetOrigin.x - R_VIEWBACKGROUND;
    
    temPointMin.y = cgp_offsetOrigin.y + R_VIEWBACKGROUND;
    temPointMax.y = touchZoneUIView.bounds.size.height + cgp_offsetOrigin.y - R_VIEWBACKGROUND;
    
    DB_JOYSTICKPRINT(@"Min X: %f, Y: %f - x: %f, y: %f", temPointMin.x, temPointMin.y, temPoint.x, temPoint.y);
    
    [UIView animateWithDuration:0.1 animations:^{
        circleOut_View.center = temPoint;
        view_in.center = temPoint;
    }];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DB_JOYSTICKPRINT(@"Touch Move");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    DB_JOYSTICKPRINT(@"X: %f, Y: %f", point.x, point.y);
    
    CGPoint temCordinate = self.circleOut_View.center;
    float temDistant = sqrtf(powf((point.x - temCordinate.x),2)+(powf((point.y - temCordinate.y),2)));
    
    float temMaxDistance = Huyen_LENGTH_VIEWIN_INBACKGROUND;

    if(temDistant <= temMaxDistance)
    {
        view_in.center = point;
    }
    else
    {
        float delta_x = point.x - X_VIEWBACKGROUND;
        float delta_y = point.y - Y_VIEWBACKGROUND;
        
        //    float temAngle = GET_ANGEL_TAN2(delta_x,delta_y);
        float temAngle = GET_ANGEL_TAN2(delta_x,-delta_y);
//        DB_JOYSTICKPRINT(@"ANGLE: %f, del_x: %f, del_y: %f", temAngle*180/M_PI, delta_x, delta_y);
        
        view_in.center = CGPointMake(X_VIEWIN_MAX(temAngle), Y_VIEWIN_MAX(temAngle));
        
        float delta_Angel = 360/16;
        temAngle = temAngle*180/M_PI;
        temAngle-=90;
        DB_JOYSTICKPRINT(@"ANGLE: %f, del_x: %f, del_y: %f", temAngle, delta_x, delta_y);
        
        StateOfJoyStick temState = _JOYSTICK_CODE_TIEN_TRAI;
        if(delegate!=nil && [delegate respondsToSelector:@selector(JoyStick_UIViewGetDirection:withTag:)])
        {
            if((temAngle <= (90+delta_Angel)) && (temAngle >= (90-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_TIEN_;
            }
            else if((temAngle <= (270+delta_Angel)) && (temAngle >= (270-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_LUI_;
            }
            else if((temAngle <= (180+delta_Angel)) && (temAngle >= (180-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_TRAI;
            }
            else if((temAngle <= (0+delta_Angel)) || (temAngle >= (360-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_PHAI;
            }
            else if((temAngle > (0+delta_Angel)) && (temAngle < (90-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_TIEN_PHAI;
            }
            else if((temAngle > (90+delta_Angel)) && (temAngle < (180-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_TIEN_TRAI;
            }
            else if((temAngle > (180+delta_Angel)) && (temAngle < (270-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_LUI_TRAI;
            }
            else if((temAngle > (270+delta_Angel)) && (temAngle < (360-delta_Angel)))
            {
                temState = _JOYSTICK_CODE_LUI_PHAI;
            }
            [delegate JoyStick_UIViewGetDirection:temState withTag:self.tag];
        }
    }
    
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DB_JOYSTICKPRINT(@"Touch end");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.circleOut_View];
    
    DB_JOYSTICKPRINT(@"X: %f, Y: %f", point.x, point.y);
    view_in.center = circleOut_View.center;
    
    if(delegate!=nil && [delegate respondsToSelector:@selector(JoyStick_UIViewGetDirection:withTag:)])
    {
        [delegate JoyStick_UIViewGetDirection:_JOYSTICK_CODE_STOP withTag:self.tag];
    }
}

-(float)cal_angle_kxn:(float)x andY:(float)y
{
        if(x >= 0 && y >= 0)
            return atanf(y/x);
        else if(x < 0 && y >= 0)
            return atanf(y/x) + M_PI;
        else if(x < 0 && y < 0)
            return atanf(y/x) + M_PI;
        else if(x >= 0 && y < 0)
            return atanf(y/x) + (2 * M_PI);
    
    return 0;
}

//-(id)initWithFrame 1:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//
//    if (self) {
//        // 2. addjust bounds
//        circleOut_View = [[UIView alloc]initWithFrame:frame];
//
//        [circleOut_View setBackgroundColor:[UIColor grayColor]];
//        circleOut_View.layer.cornerRadius = [self.circleOut_View bounds].size.height/2;
//        circleOut_View.layer.masksToBounds = YES;
//        circleOut_View.layer.borderWidth = 1;
//        circleOut_View.alpha = 0.3;
//
//        view_in = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width/3, frame.size.height/3)];
//
//        view_in.center = circleOut_View.center;
//
//        [view_in setBackgroundColor:[UIColor redColor]];
//        view_in.layer.cornerRadius = [self.view_in bounds].size.height/2;
//        view_in.layer.masksToBounds = YES;
//        view_in.layer.borderWidth = 1;
//        view_in.alpha = 0.7;
//
//        // 3. add as a subview
//        //        [self addSubview:self.view_in];
//        [self addSubview:self.circleOut_View];
//        [self.circleOut_View addSubview:self.view_in];
//        [self setUpViewKxn];
//    }
//    return self;
//}
//
//-(void)touchesMoved 1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"Touch Move");
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.circleOut_View];
//
//    NSLog(@"X: %f, Y: %f", point.x, point.y);
//
//    CGPoint temCordinate = self.circleOut_View.center;
//    float temDistant = sqrtf(powf((point.x - temCordinate.x),2)+(powf((point.y - temCordinate.y),2)));
//
//    float temMaxDistance = Huyen_LENGTH_VIEWIN_INBACKGROUND;
//
//    if(temDistant <= temMaxDistance)
//    {
//        view_in.center = point;
//    }
//    else
//    {
//        float delta_x = point.x - X_VIEWBACKGROUND;
//        float delta_y = point.y - Y_VIEWBACKGROUND;
//
//        //    float temAngle = GET_ANGEL_TAN2(delta_x,delta_y);
//        float temAngle = GET_ANGEL_TAN2(delta_x,-delta_y);
//        NSLog(@"ANGLE: %f, del_x: %f, del_y: %f", temAngle*180/M_PI, delta_x, delta_y);
//        view_in.center = CGPointMake(X_VIEWIN_MAX(temAngle), Y_VIEWIN_MAX(temAngle));
//    }
//
//
//}
@end
