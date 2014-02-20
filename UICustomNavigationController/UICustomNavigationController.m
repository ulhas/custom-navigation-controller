//
//  UICustomNavigationController.m
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/20/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import "UICustomNavigationController.h"

@interface UICustomNavigationController ()

@property (nonatomic, strong, readwrite) UIViewController *rootViewController;

@end

@implementation UICustomNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self)
    {
        self.rootViewController = rootViewController;
    }
    
    return self;
}

- (NSArray *)viewControllers
{
    return self.childViewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pushViewController:self.rootViewController animated:NO];
}

- (void)removeTopViewControllerView
{
    UIViewController *topViewController = self.childViewControllers.lastObject;
    if (!topViewController)
    {
        return;
    }
    
    [topViewController willMoveToParentViewController:nil];
    [topViewController.view removeFromSuperview];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self removeTopViewControllerView];
    
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)popViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

@end
