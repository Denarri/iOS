//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCenterViewController.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *itemURL;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIButton *webViewDone;

@end
