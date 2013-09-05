//
//  CTSessionOperation.h
//  NSURLSample
//
//  Created by Nicholas Cipollina on 9/4/13.
//  Copyright (c) 2013 Nicholas Cipollina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CTProgressBlock)(double totalBytesWritten, double bytesExpected);
typedef void (^CTCompletionBlock)(NSURL *imageUrl, BOOL success);
typedef void (^CTBackgroundCompletionBlock)();

@interface CTSessionOperation : NSOperation<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) NSString *downloadUrl;
@property (strong) CTProgressBlock progressAction;
@property (strong) CTCompletionBlock completionAction;
@property (strong) CTBackgroundCompletionBlock backgroundCompletionAction;
@property (nonatomic, assign) BOOL isBackground;

- (void)enqueueOperation;
@end
