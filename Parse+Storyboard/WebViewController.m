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
    
    NSLog(@"The url in webview is: '%@'", self.itemURL);
    
    // Initialize UIWebView
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width,
                                                                 self.view.frame.size.height)];;
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
    
//    // Bottom Tab Bar (with back button)
//    self.webViewToolBar = [[UIToolbar alloc] init];
//     CGRect toolBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44, [[UIScreen mainScreen] bounds].size.width, 44);
//    self.webViewToolBar.frame = toolBarFrame;
//    NSMutableArray *barItems = [[NSMutableArray alloc] init];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"downarrow.png"]
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target:self
//                                                                  action:@selector(webViewBackAction)];
//    [barItems addObject:backButton];
//    
//    [self.webViewToolBar setItems:barItems animated:YES];
//    [self.view addSubview:self.webViewToolBar];
    
    
    // Activity indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    // set the url
    NSURL *url = [NSURL URLWithString:self.itemURL];
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

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    // snip ...
//    _backButton.enabled = (self.myWebView.canGoBack);
//    //forwardButton.enabled = (self.myWebView.canGoForward);
//}

//- (void)webViewBackAction:(id)sender {
//    [self.myWebView goBack];
//}



- (IBAction)webViewDone:(id)sender {
    NSLog(@"YALA KHALAS");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender {
    NSLog(@"WE GON SHARE");
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Share via iMessage",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
//                case 0:
//                    NSLog(@"lets share on email");
//                    if ([MFMailComposeViewController canSendMail]) {
//                        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
//                        [mailController setMailComposeDelegate:self];
//                        [mailController setSubject:@"Item I found On Denarri"];
//                        [mailController setMessageBody:(@"Check out this awesome deal I found on the Denarri app!:") isHTML:NO];
//                        [self presentViewController:mailController animated:YES completion:nil];
//                    }
//                    break;
                case 0:
                    NSLog(@"Check out this awesome deal on a '%@' I found on the Denarri app: '%@'", _searchTerm, _itemURL);
                    if ([MFMessageComposeViewController canSendText]) {
                        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
                        [messageController setMessageComposeDelegate:self];
                        [messageController setBody: [NSString stringWithFormat: @"Check out this deal on a '%@' I found on the Denarri app: '%@'", _searchTerm, _itemURL]];
                        
//                        [NSString stringWithFormat: @"Check out this awesome deal I found on the Denarri app!: '%@'", _itemURL];
                        [self presentViewController:messageController animated:NO completion:nil];
                    }
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

// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Then implement the delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
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
