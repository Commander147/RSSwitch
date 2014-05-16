//
//  RSSwitch.m
//
//  Created by Joseph Afework on 4/21/14.
//  Copyright (c) 2014 Joseph Afework. All rights reserved.
//

#import "RSSwitch.h"

#define kCPSwitchToggleViewOffset       2
#define kCPSwitchPressedWidth           (self.frame.size.width/8)
#define kCPSwitchCornerRadius           (self.frame.size.height-4)/2
#define kCPSwitchToggleViewRadius       self.frame.size.height-(2*kCPSwitchToggleViewOffset)
#define kCPSwitchToggleRightOffset      (3*kCPSwitchToggleViewOffset)

#define CGRectSetWidth(rect, width)     CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)
#define CGRectSetHeight(rect, height)   CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height)
#define CGRectSetSize(rect, size)       CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height)
#define CGRectGetMidWidth(rect)         rect.size.width/2

@interface RSSwitch()

    @property (nonatomic, strong)           UIImageView *toggleView;
    @property (nonatomic, strong)           UIImageView *toggleShadowView;

@end

@implementation RSSwitch
@synthesize toggleTint = _toggleTint;

#pragma mark - Init Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [self colorFromHexString:@"D7D7D7"];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = kCPSwitchCornerRadius;
        self.on = NO;
        
        [self addSubview:self.toggleView];
        
        [self insertSubview:self.toggleShadowView belowSubview:self.toggleView];
    }
    return self;
}

-(UIImageView*)toggleView
{
    if(nil == _toggleView)
    {
        _toggleView = [[UIImageView alloc] init];
        
        _toggleView.frame = CGRectMake(
            kCPSwitchToggleViewOffset,
            kCPSwitchToggleViewOffset,
            kCPSwitchToggleViewRadius,
            kCPSwitchToggleViewRadius
        );
        _toggleView.backgroundColor = [UIColor whiteColor];
        _toggleView.clipsToBounds = YES;
        _toggleView.layer.cornerRadius = kCPSwitchCornerRadius;
    
    }
    return _toggleView;
}

-(UIImageView*)toggleShadowView{
    if(nil == _toggleShadowView)
    {
        _toggleShadowView = [[UIImageView alloc] initWithFrame:CGRectOffset(self.toggleView.frame,-1,2)];
        
        _toggleShadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        _toggleShadowView.clipsToBounds = YES;
        _toggleShadowView.layer.cornerRadius = kCPSwitchCornerRadius;
    }
    return _toggleShadowView;
}

#pragma mark - Public Properties
-(UIColor*)onTint{
    if(nil == _onTint){
        self.onTint = [self colorFromHexString:@"4cd964"];
    }
    return _onTint;
}

-(UIColor*)offTint{
    if(nil == _offTint){
        self.offTint = [self colorFromHexString:@"D7D7D7"];
    }
    return _offTint;
}

-(UIColor*)toggleTint{
    if(nil == _toggleTint){
        self.toggleTint = [UIColor whiteColor];
    }
    return _toggleTint;
}

-(void)setToggleTint:(UIColor *)toggleTint{
    _toggleTint = toggleTint;
    self.toggleView.backgroundColor = _toggleTint;
}

#pragma mark - UIControl Overriden Methods
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    self.toggleView.frame = CGRectSetWidth(
        self.toggleView.frame,
        self.toggleView.frame.size.width + kCPSwitchPressedWidth
    );
    
    if(YES == self.isOn)
    {
        self.toggleView.frame = CGRectMake(
            self.frame.size.width - self.toggleView.frame.size.height - kCPSwitchToggleViewOffset - kCPSwitchPressedWidth,
            self.toggleView.frame.origin.y,
            self.toggleView.frame.size.width,
            self.toggleView.frame.size.height
        );
    }
    
    self.toggleShadowView.frame = CGRectOffset(self.toggleView.frame,-1,2);
    
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    [UIView animateWithDuration:.3 animations:^{
    
        CGPoint location = [touch locationInView:self];
        
        if(location.x < CGRectGetMidWidth(self.frame))
        {
            self.on = NO;
            self.backgroundColor = self.offTint;
            self.toggleView.frame = CGRectMake(
                kCPSwitchToggleViewOffset,
                kCPSwitchToggleViewOffset,
                self.toggleView.frame.size.width,
                self.toggleView.frame.size.height
            );
        }
        else
        {
            self.on = YES;
            self.backgroundColor = self.onTint;
            self.toggleView.frame = CGRectMake(
                self.frame.size.width - self.toggleView.frame.size.width - kCPSwitchToggleViewOffset,
                kCPSwitchToggleViewOffset,
                self.toggleView.frame.size.width,
                self.toggleView.frame.size.height
            );
        }
        
        self.toggleShadowView.frame = CGRectOffset(self.toggleView.frame,-1,2);
        
    }];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [UIView animateWithDuration:.3 animations:^{
        if(YES == self.on)
        {
            self.toggleView.frame =
            CGRectMake(
                self.frame.size.width - kCPSwitchToggleViewRadius + kCPSwitchToggleRightOffset,
                self.toggleView.frame.origin.y,
                kCPSwitchToggleViewRadius,
                kCPSwitchToggleViewRadius
            );
        }
        else
        {
            self.toggleView.frame = CGRectSetWidth(
                self.toggleView.frame,
                kCPSwitchToggleViewRadius
            );
        }
        self.toggleShadowView.frame = CGRectOffset(self.toggleView.frame,-1,2);
    } completion:^(BOOL finished) {
        if([self.delegate respondsToSelector:@selector(RSSwitchDidChangeState:)])
        {
            __weak RSSwitch *this = self;
            [self.delegate RSSwitchDidChangeState:this];
        }
    }];
}

#pragma mark - Helper Methods
- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned int rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgb];
    
    float red = ((rgb & 0xFF0000) >> 16)/255.0;
    float green = ((rgb & 0xFF00) >> 8)/255.0;
    float blue = (rgb & 0xFF)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
