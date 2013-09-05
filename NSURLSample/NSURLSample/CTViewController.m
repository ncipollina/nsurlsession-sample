//
//  CTViewController.m
//  NSURLSample
//
//  Created by Nicholas Cipollina on 9/4/13.
//  Copyright (c) 2013 Nicholas Cipollina. All rights reserved.
//

#import "CTViewController.h"
#import "CTSessionOperation.h"
#import "CTAppDelegate.h"

static NSString *downloadUrl = @"http://www.wallpele.com/wp-content/uploads/2013/03/Download-Default-HD-Apple-Wallpaper.jpg";

@interface CTViewController ()

@property (nonatomic, strong) NSOperation *downloadOperation;

@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.progressView.progress = 0;
    self.downloadedImage.hidden = NO;
    self.progressView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadBackground:(id)sender {
    [self downloadImageInBackground:YES];
}

- (IBAction)downloadImage:(id)sender {
    [self downloadImageInBackground:NO];
}

- (void)downloadImageInBackground:(BOOL)background{
    if (self.downloadOperation){
        return;
    }

    CTSessionOperation *operation = [CTSessionOperation new];
    operation.downloadUrl = downloadUrl;
    operation.progressAction = ^(double bytesWritten, double bytesExpected){
        double progress = bytesWritten / bytesExpected;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (float) progress;
        });
    };
    operation.completionAction = ^(NSURL *imageUrl, BOOL success){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success){
                UIImage *image = [UIImage imageWithContentsOfFile:[imageUrl path]];
                self.downloadedImage.image = image;
            }
            self.downloadedImage.hidden = NO;
            self.progressView.progress = 0;
            self.progressView.hidden = YES;
            self.downloadOperation = nil;
        });
    };
    operation.isBackground = background;
    if (background){
        operation.backgroundCompletionAction = ^{
            CTAppDelegate *appDelegate = (CTAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.backgroundSessionCompletionHandler) {
                void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
                appDelegate.backgroundSessionCompletionHandler = nil;
                completionHandler();
            }
        };
    }

    [operation enqueueOperation];
    self.downloadedImage.hidden = YES;
    self.progressView.hidden = NO;
    self.downloadOperation = operation;
}

@end
