//
//  MySignUpViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "MySignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MySignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MySignUpViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denarri_ios_retina.png"]]];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
