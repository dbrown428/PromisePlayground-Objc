
#import <Foundation/Foundation.h>

@protocol UploadProgress <NSObject>

- (void)uploadDidChange:(float)value;
- (void)uploadMessage:(NSString *)message;
- (void)showNetworkActivityIndicator:(BOOL)show;

@end
