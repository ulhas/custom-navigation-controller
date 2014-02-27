//
//  BViewController.m
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/21/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()

@end

@implementation BViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self);
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self);
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self);
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self);
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self);
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self);
}


- (IBAction)dismiss:(id)sender
{
    [self.underlyingController dismissViewControllerAnimated:NO completion:^{
        NSLog(@"Finished");
    }];
}

@end
