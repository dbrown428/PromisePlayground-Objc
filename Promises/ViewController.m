//
//  ViewController.m
//  Promises
//
//  Created by D. Brown on 2015-12-13.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "ViewController.h"
#import "UploadManager.h"
#import <PromiseKit/PromiseKit.h>

@interface ViewController()
@property (nonatomic, strong) UploadManager *manager;
@property (nonatomic, weak) IBOutlet UITextView *log;
@property (nonatomic, weak) IBOutlet UIProgressView *progress;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIButton *longProcessButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [[UploadManager alloc] init];
    [self.manager setDelegate:self];
}

- (IBAction)helloWorld:(id)sender
{
    [self appendToLog:@"> Start Button Method"];
    [self disableButton:YES];
    
    [self appendToLog:@"> Start Activity Animation"];
    [self.activityIndicator startAnimating];
    
    [self.manager contrivedLongRunningProcessWithInput:@"Hello World"]
    .then (^(NSString *result)
    {
        NSString *message = [NSString stringWithFormat:@"> Button Result: %@", result];
        [self appendToLog:message];
        
        // Return a tuple
        return PMKManifold(result, [NSNumber numberWithFloat:63.1], @"Awesome");
    })
    .thenInBackground (^(NSString *result1, NSNumber *result2, NSString *result3)
    {
        NSString *message = [NSString stringWithFormat:@"Tuple result: %@, %@, %@", result1, result2, result3];
        [NSException raise:NSInvalidArgumentException format:@"Background Fault (%@)", message];
    })
    .catch (^(NSError *error)
    {
        NSString *message = [NSString stringWithFormat:@"> Button Error: %@", error.localizedDescription];
        [self appendToLog:message];
    })
    .finally (^
    {
        [self appendToLog:@"> Stop Activity Animation"];
        [self.activityIndicator stopAnimating];
        [self disableButton:NO];
        [self appendToLog:@"> Button Promise is FINALLY Done"];
        [self uploadDidChange:0.0];
        [self promptUserToPromise];
    });
    
    [self appendToLog:@"> End Button Method"];
}

- (void)promptUserToPromise
{
    UIAlertView *alert = [UIAlertView new];
    [alert setTitle:@"Do you promise?"];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    
    [alert promise]
    .then(^(NSNumber *dismissedButtonIndex)
    {
        if (dismissedButtonIndex.intValue == 0)
        {
            [self appendToLog:@"> User promised!!"];
        }
        else
        {
            [self appendToLog:@"> User breaks promises!!"];
        }
    });
}

- (void)disableButton:(BOOL)disabled
{
    if (disabled)
    {
        [self.longProcessButton setEnabled:NO];
        [self.longProcessButton setBackgroundColor:[UIColor grayColor]];
        [self.longProcessButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateDisabled];
    }
    else
    {
        [self.longProcessButton setEnabled:YES];
        [self.longProcessButton setBackgroundColor:[UIColor redColor]];
        [self.longProcessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)outputSomething:(id)sender
{
    [self appendToLog:@"Button Pressed"];
}

- (void)appendToLog:(NSString *)output
{
    NSString *updatedLog = [self.log.text stringByAppendingFormat:@"%@\n", output];
    [self.log setText:updatedLog];
}

#pragma mark - UploadProgress Protocol implementation

- (void)uploadDidChange:(float)value
{
    if (value <= 0)
    {
        [self.progress setProgress:0.0 animated:NO];
    }
    else if (value > 1)
    {
        [self.progress setProgress:1.0 animated:NO];
    }
    else
    {
        [self.progress setProgress:value animated:YES];
    }
}

- (void)uploadMessage:(NSString *)message
{
    [self appendToLog:message];
}

- (void)showNetworkActivityIndicator:(BOOL)show
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:show];
}

@end
