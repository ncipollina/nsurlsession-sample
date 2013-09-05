//
//  CTAppDelegate.h
//  NSURLSample
//
//  Created by Nicholas Cipollina on 9/4/13.
//  Copyright (c) 2013 Nicholas Cipollina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^backgroundSessionCompletionHandler)();

@end
