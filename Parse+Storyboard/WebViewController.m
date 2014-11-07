//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () 

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    NSLog(@"The url dude is: '%@'", _itemURL);
    
    self.myWebView.delegate = self;
    
    // set the url
    NSURL *url = [NSURL URLWithString:_itemURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // make url request
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             [self.myWebView loadRequest:request];
             [activityIndicator stopAnimating];
         }
         else if (error != nil) NSLog(@"Error: %@", error);
     }];
    
    [self.myWebView setScalesPageToFit:YES];
    
}

- (IBAction)webViewDone:(id)sender {
    NSLog(@"YALA KHALAS");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender {
    NSLog(@"WE GON SHARE");
    
    
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Share on Facebook",
                            @"Share on Twitter",
                            @"Share via E-mail",
                            @"Share via iMessage",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"lets share on fb");
//                    [self FBShare];
                    break;
                case 1:
                    NSLog(@"lets share on twitter");
//                    [self TwitterShare];
                    break;
                case 2:
                    NSLog(@"lets share on email");
//                    [self emailContent];
                    break;
                case 3:
                    NSLog(@"lets share on iMessage");
//                    [self saveContent];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
