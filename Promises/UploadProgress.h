//
//  UploadProgress.h
//  Promises
//
//  Created by D. Brown on 2015-12-16.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadProgress <NSObject>

- (void)uploadDidChange:(float)value;
- (void)uploadMessage:(NSString *)message;
- (void)showNetworkActivityIndicator:(BOOL)show;

@end
