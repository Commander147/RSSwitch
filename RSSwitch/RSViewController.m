//
//  RSViewController.m
//  RSSwitch
//
//  Created by Joseph Afework on 5/15/14.
//  Copyright (c) 2014 Joseph Afework. All rights reserved.
//

#import "RSViewController.h"
#import "RSSwitch.h"

@implementation RSViewController

-(void)viewDidAppear:(BOOL)animated
{
    int yoffset = 20;
    int spacing = 5;
    
    for(int i = 1;i<11;i++){
        int scale = i*10;
        int width = scale+10;
        int height = (scale+10)*.60;
        
        CGRect frame = {
            ((self.view.frame.size.width/2) - width/2)/2,
            yoffset,
            width,
            height
        };
        
        RSSwitch *toggle = [[RSSwitch alloc] initWithFrame:frame];
        toggle.tag = i;
        toggle.delegate = self;
        yoffset += height + spacing;
        toggle.onTint = [UIColor orangeColor];
        [self.view addSubview:toggle];
    }
}

-(void)RSSwitchDidChangeState:(RSSwitch *)toggle
{
    NSLog(@"Switch %d: state:%d",toggle.tag, toggle.isOn);
}

@end
