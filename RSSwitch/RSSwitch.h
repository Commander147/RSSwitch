//
//  RSSwitch.h
//
//  Created by Joseph Afework on 4/21/14.
//  Copyright (c) 2014 Joseph Afework. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSwitchDelegate;

@interface RSSwitch : UIControl
    @property (nonatomic, strong)           UIColor  *onTint;
    @property (nonatomic, strong)           UIColor  *offTint;
    @property (nonatomic, strong)           UIColor  *toggleTint;
    @property (nonatomic, weak)             id delegate;
    @property (nonatomic, getter = isOn)    BOOL on;
@end

@protocol RSSwitchDelegate <NSObject>
@optional
-(void)RSSwitchDidChangeState:(RSSwitch*)toggle;
@end
