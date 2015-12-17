//
//  UploadManager.m
//  Promises
//
//  Created by D. Brown on 2015-12-13.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "UploadManager.h"
#import <PromiseKit/PromiseKit.h>

@interface UploadManager ()
@end

@implementation UploadManager

- (PMKPromise *)contrivedLongRunningProcessWithInput:(NSString *)value
{
    return dispatch_promise(^{
        
        [self sendMainThreadUploadMessage:@"> > Start Long Running Process"];
        [self sendMainThreadUploadDidChange:0.25];
        sleep(4);
        
        [self sendMainThreadUploadDidChange:0.5];
        [self learnInternalChaining];
        sleep(4);
        
        [self sendMainThreadUploadDidChange:0.75];
        [self learnWhenCondition];
        sleep(4);
        
        [self sendMainThreadUploadDidChange:1.0];
        [self sendMainThreadUploadMessage:@"> > End Long Running Process"];
        
        return @"42";
    });
}

- (void)learnInternalChaining
{
    [self sendMainThreadUploadMessage:@"> > > Start Internal Chaining"];
    [self sendMainThreadNetworkActivity:YES];
    
    [self calculate]
    .thenInBackground(^(NSString *test)
    {
        NSString *message = [NSString stringWithFormat:@"> > > > Internal Chaining Result 1: %@", test];
        [self sendMainThreadUploadMessage:message];
        return @[@"Item 1", @"Item 2", @"Item 3"];
    })
    .thenInBackground(^(NSArray *stuff)
    {
        NSString *message = [NSString stringWithFormat:@"> > > > Internal Chaining Result 2: %@", stuff];
        [self sendMainThreadUploadMessage:message];
        [NSException raise:NSGenericException format:@"Something Broke"];
        
    })
    .catch(^(NSError *error)
    {
        NSString *message = [NSString stringWithFormat:@"> > > > Internal Chaining Error: %@", error.localizedDescription];
        [self sendMainThreadUploadMessage:message];
    })
    .finally(^
    {
        [self sendMainThreadUploadMessage:@"> > > > Internal Chaining Finally"];
        [self sendMainThreadNetworkActivity:NO];
    });
    
    [self sendMainThreadUploadMessage:@"> > > End Internal Chaining"];
}

- (PMKPromise *)calculate
{
    return dispatch_promise(^
    {
        [self sendMainThreadUploadMessage:@"> > > > Start Calculate"];
        sleep(4);
        [self sendMainThreadUploadMessage:@"> > > > End Calculate"];
        
        return @"1234";
    });
}

- (void)learnWhenCondition
{
    [self sendMainThreadUploadMessage:@"> > > Start When-Condition"];
    
    id search1 = [self search:@"X"];
    id search2 = [self search:@"Y"];
    id search3 = [self search:@"Z"];
    
    [PMKPromise when:@[search1, search2, search3]]
    .thenInBackground(^
    {
        [self sendMainThreadUploadMessage:@"> > > > When-Condition Satisfied"];
    });
    
    [self sendMainThreadUploadMessage:@"> > > End When-Condition"];
}

- (PMKPromise *)search:(NSString *)value
{
    return dispatch_promise(^
    {
        NSString *message = [NSString stringWithFormat:@"> > > > Searching: %@", value];
        [self sendMainThreadUploadMessage:message];
        sleep(4);
    });
}

- (void)sendMainThreadUploadDidChange:(float)value
{
    if([self.delegate respondsToSelector:@selector(uploadDidChange:)])
    {
        dispatch_promise_on(dispatch_get_main_queue(), ^{
            [self.delegate uploadDidChange:value];
        });
    }
}

- (void)sendMainThreadUploadMessage:(NSString *)message
{
    if([self.delegate respondsToSelector:@selector(uploadMessage:)])
    {
        dispatch_promise_on(dispatch_get_main_queue(), ^{
            [self.delegate uploadMessage:message];
        });
    }
}

- (void)sendMainThreadNetworkActivity:(BOOL)activity
{
    if([self.delegate respondsToSelector:@selector(setNetworkActivityIndicatorVisible:)])
    {
        dispatch_promise_on(dispatch_get_main_queue(), ^{
            [self.delegate showNetworkActivityIndicator:activity];
        });
    }
}

@end
