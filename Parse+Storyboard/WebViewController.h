//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCenterViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *itemURL;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end
