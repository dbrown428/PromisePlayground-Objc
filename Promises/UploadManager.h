//
//  UploadManager.h
//  Promises
//
//  Created by D. Brown on 2015-12-13.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadProgress.h"

@class PMKPromise;

@interface UploadManager : NSObject

@property (nonatomic, weak) id <UploadProgress> delegate;

- (PMKPromise *)contrivedLongRunningProcessWithInput:(NSString *)value;

@end
