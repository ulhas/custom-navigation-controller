//
//  AViewController.m
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/20/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import "UICustomNavigationController.h"

#import "BViewController.h"
#import "AViewController.h"

@interface AViewController ()

@end

@implementation AViewController

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

- (IBAction)buttonClicked:(id)sender
{
    AViewController *aViewController = [[AViewController alloc] initWithNibName:@"AViewController" bundle:nil];
    
    UICustomNavigationController *navCon = (UICustomNavigationController *)self.parentViewController;
    [navCon pushViewController:aViewController animated:YES completion:nil];
}

- (IBAction)slideButtonClicked:(id)sender
{
    AViewController *aViewController = [[AViewController alloc] initWithNibName:@"AViewController" bundle:nil];
    
    UICustomNavigationController *navCon = (UICustomNavigationController *)self.parentViewController;
    [navCon slideUpViewControler:aViewController completion:nil];
}

- (IBAction)faceButton:(id)sender
{
    BViewController *aViewController = [[BViewController alloc] initWithNibName:@"BViewController" bundle:nil];
    
    UICustomNavigationController *navCon = (UICustomNavigationController *)self.parentViewController;
    [navCon fadeInViewControler:aViewController completion:nil];
}



@end
