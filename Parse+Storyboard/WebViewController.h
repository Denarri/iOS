//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCenterViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString *itemURL;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIButton *webViewDone;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@end
