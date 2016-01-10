
#import <Foundation/Foundation.h>
#import "UploadProgress.h"

@class PMKPromise;

@interface UploadManager : NSObject

@property (nonatomic, weak) id <UploadProgress> delegate;

- (PMKPromise *)contrivedLongRunningProcessWithInput:(NSString *)value;

@end
