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


- (IBAction)dismiss:(id)sender
{
    [self.underlyingController dismissViewControllerAnimated:NO completion:^{
        NSLog(@"Finished");
    }];
}

@end
