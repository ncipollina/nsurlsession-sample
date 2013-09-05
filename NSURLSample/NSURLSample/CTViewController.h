//
//  CTViewController.h
//  NSURLSample
//
//  Created by Nicholas Cipollina on 9/4/13.
//  Copyright (c) 2013 Nicholas Cipollina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTViewController : UIViewController
- (IBAction)downloadBackground:(id)sender;
- (IBAction)downloadImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *downloadedImage;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end
