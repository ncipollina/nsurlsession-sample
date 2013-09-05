//
//  CTSessionOperation.m
//  NSURLSample
//
//  Created by Nicholas Cipollina on 9/4/13.
//  Copyright (c) 2013 Nicholas Cipollina. All rights reserved.
//

#import "CTSessionOperation.h"

@implementation CTSessionOperation

- (NSOperationQueue *)operationQueue{
    static NSOperationQueue *operationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [NSOperationQueue new];
        [operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return operationQueue;
}

- (NSURLSession *)session {
    static NSURLSession *session = nil;
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration
                backgroundSessionConfiguration:@"com.captech.NSURLSample.BackgroundSession"];
        backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                                                          delegate:self
                                                     delegateQueue:nil];
    });

    return self.isBackground ? backgroundSession : session;
}

- (void)enqueueOperation{
    [[self operationQueue] addOperation:self];
}

#pragma mark - NSOperation

- (void)start {
    if (!self.isCancelled){
        NSURL *downloadURL = [NSURL URLWithString:self.downloadUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
        self.downloadTask = [self.session downloadTaskWithRequest:request];
        [self.downloadTask resume];
    }
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [urls objectAtIndex:0];

    NSURL *originalUrl = [[downloadTask originalRequest] URL];
    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
    NSError *error;

    [fileManager removeItemAtURL:destinationUrl error:NULL];
    BOOL success = [fileManager copyItemAtURL:location toURL:destinationUrl error:&error];
    if (self.completionAction){
        self.completionAction(destinationUrl, success);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (downloadTask == self.downloadTask && self.progressAction){
        self.progressAction((double)totalBytesWritten, (double)totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (self.progressAction){
        self.progressAction((double)task.countOfBytesReceived, (double)task.countOfBytesExpectedToReceive);
    }

    self.downloadTask = nil;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    if (self.backgroundCompletionAction){
        self.backgroundCompletionAction();
    }
}

@end
