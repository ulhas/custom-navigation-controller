//
//  UICustomNavigationController.m
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/20/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import "UIOverlayViewController.h"
#import "UICustomNavigationController.h"

static const NSTimeInterval kTransitionAnimationDuration = 0.5f;

@interface UICustomNavigationController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong, readwrite) NSMutableArray *overlayControllers;
@property (nonatomic, strong, readwrite) UIViewController *rootViewController;

@property (nonatomic, assign) BOOL shouldPop;

@end

@implementation UICustomNavigationController

#pragma mark - Controller Methods

- (id)initWithRootViewController:(UIViewController *)rootViewController shouldPop:(BOOL)shouldPop
{
    self = [super init];
    if (self)
    {
        self.rootViewController = rootViewController;
        self.shouldPop = shouldPop;
        self.overlayControllers = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupContainerView];
    [self pushViewController:self.rootViewController animated:NO completion:nil];
}

#pragma mark - Controller View Contraint Methods

- (void)addFillConstraintsToView:(UIView *)view
{
    NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                            options:NSLayoutFormatDirectionLeadingToTrailing
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(view)];
    
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(view)];
    
    [self.view addConstraints:horizontalConstraint];
    [self.view addConstraints:verticalConstraint];
    [self.view layoutIfNeeded];
}

- (void)addTopConstraintToView:(UIView *)view
{
    NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                            options:NSLayoutFormatDirectionLeadingToTrailing
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(view)];
    
    NSDictionary *metrics = @{@"viewHeight": @(view.bounds.size.height), @"statusBarHeight": @(UIApplication.sharedApplication.statusBarFrame.size.height)};
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-statusBarHeight-[view(viewHeight)]"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:metrics
                                                                            views:NSDictionaryOfVariableBindings(view)];
    
    [self.view addConstraints:horizontalConstraint];
    [self.view addConstraints:verticalConstraint];
    [self.view layoutIfNeeded];
}

- (void)addBottomConstraintToView:(UIView *)view
{
    NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                            options:NSLayoutFormatDirectionLeadingToTrailing
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(view)];
    
    NSDictionary *metrics = @{@"viewHeight": @(view.bounds.size.height)};
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(viewHeight)]|"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:metrics
                                                                            views:NSDictionaryOfVariableBindings(view)];
    
    [self.view addConstraints:horizontalConstraint];
    [self.view addConstraints:verticalConstraint];
    [self.view layoutIfNeeded];
}

#pragma mark - Controller View Methods

- (void)setupContainerView
{
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.containerView];
    [self addFillConstraintsToView:self.containerView];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if ([backgroundView isEqual:self.backgroundView])
    {
        return;
    }
    
    [self.backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    [self setupBackgroundView];
}

- (void)setupBackgroundView
{
    [self.view addSubview:self.backgroundView];
    [self addFillConstraintsToView:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
}

- (void)setNavigationView:(UIView *)navigationView
{
    if (navigationView == nil)
    {
        [_navigationView removeFromSuperview];
        _navigationView = nil;
        return;
    }
    
    if ([navigationView isEqual:self.navigationView])
    {
        return;
    }
    
    [self.navigationView removeFromSuperview];
    _navigationView = navigationView;
    [self setupNavigationView];
}

- (void)setupNavigationView
{
    [self.view addSubview:self.navigationView];
    [self addTopConstraintToView:self.navigationView];
    [self.view bringSubviewToFront:self.navigationView];
}

- (void)setToolBarView:(UIView *)toolBarView
{
    if (toolBarView == nil)
    {
        [_toolBarView removeFromSuperview];
        _toolBarView = nil;
        return;
    }
    
    if ([toolBarView isEqual:self.toolBarView])
    {
        return;
    }
    
    [self.toolBarView removeFromSuperview];
    _toolBarView = toolBarView;
    [self setupToolBarView];
}

- (void)setupToolBarView
{
    [self.view addSubview:self.toolBarView];
    self.toolBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addBottomConstraintToView:self.toolBarView];
    [self.view bringSubviewToFront:self.toolBarView];
}

#pragma mark - ChildViewController Methods

- (void)setupControllerInContainerView:(UIViewController *)viewController
{
    [self willTransitionFromViewController:nil toViewController:viewController animated:NO];
    [self.containerView addSubview:viewController.view];
    [self didTransitionFromViewController:nil toViewController:viewController];
}

- (NSArray *)viewControllers
{
    return self.childViewControllers;
}

- (UIViewController *)topViewController
{
    return self.childViewControllers.lastObject;
}

#pragma mark - Transition Methods

- (void)willTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController animated:(BOOL)animated
{
    [self addChildViewController:toViewController];
    
    self.navigationView.userInteractionEnabled = NO;
    self.toolBarView.userInteractionEnabled = NO;
    
    toViewController.view.frame = self.containerView.frame;
    
    [fromViewController beginAppearanceTransition:NO animated:animated];
    [toViewController beginAppearanceTransition:YES animated:animated];
    
    if (!self.shouldPop)
    {
        [fromViewController willMoveToParentViewController:nil];
    }
}

- (void)didTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    [toViewController didMoveToParentViewController:self];
    
    self.navigationView.userInteractionEnabled = YES;
    self.toolBarView.userInteractionEnabled = YES;
    
    [fromViewController endAppearanceTransition];
    [toViewController endAppearanceTransition];
    
    if (!self.shouldPop)
    {
        [fromViewController removeFromParentViewController];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *topViewController = self.childViewControllers.lastObject;
    if (!topViewController)
    {
        [self setupControllerInContainerView:viewController];
        return;
    }
    
    [self willTransitionFromViewController:topViewController
                          toViewController:viewController
                                  animated:animated];
    
    NSTimeInterval duration = 0.0f;
    if (animated)
    {
        duration = kTransitionAnimationDuration;
        viewController.view.transform = CGAffineTransformMakeTranslation(topViewController.view.bounds.size.width, 0.0f);
    }
    
    [self transitionFromViewController:topViewController
                      toViewController:viewController
                              duration:duration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                if (animated)
                                {
                                    viewController.view.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
                                    topViewController.view.transform = CGAffineTransformMakeTranslation(-1 * topViewController.view.bounds.size.width, 0.0f);
                                }
                            }
                            completion:^(BOOL finished) {
                                [self didTransitionFromViewController:topViewController toViewController:viewController];
                                
                                if (completion)
                                {
                                    dispatch_async(dispatch_get_main_queue(), completion);
                                }
                            }];
}

- (void)slideUpViewControler:(UIViewController *)viewController completion:(void (^)(void))completion
{
    UIViewController *topViewController = self.childViewControllers.lastObject;
    if (!topViewController)
    {
        [self setupControllerInContainerView:viewController];
        return;
    }
    
    [self willTransitionFromViewController:topViewController
                          toViewController:viewController
                                  animated:YES];
    
    viewController.view.transform = CGAffineTransformMakeTranslation(0, topViewController.view.bounds.size.height);
    
    [self transitionFromViewController:topViewController
                      toViewController:viewController
                              duration:kTransitionAnimationDuration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                NSLog(@"Background View Frame : %@", NSStringFromCGRect(self.backgroundView.frame));
                                viewController.view.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
                                topViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -1 * topViewController.view.bounds.size.height);
                            }
                            completion:^(BOOL finished) {
                                
                                NSLog(@"Background View Frame : %@", NSStringFromCGRect(self.backgroundView.frame));
                                [self didTransitionFromViewController:topViewController toViewController:viewController];
                                
                                if (completion)
                                {
                                    dispatch_async(dispatch_get_main_queue(), completion);
                                }
                            }];
}

- (void)fadeInViewControler:(UIViewController *)viewController completion:(void (^)(void))completion
{
    UIViewController *topViewController = self.childViewControllers.lastObject;
    if (!topViewController)
    {
        [self setupControllerInContainerView:viewController];
        return;
    }
    
    [self willTransitionFromViewController:topViewController
                          toViewController:viewController
                                  animated:YES];
    
    [self transitionFromViewController:topViewController
                      toViewController:viewController
                              duration:kTransitionAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {
                                [self didTransitionFromViewController:topViewController toViewController:viewController];
                                
                                if (completion)
                                {
                                    dispatch_async(dispatch_get_main_queue(), completion);
                                }
                            }];
}- (void)presentOverLayViewController:(UIOverlayViewController *)overlayController animated:(BOOL)flag completion:(void (^)(void))completion
{
    overlayController.view.frame = self.view.bounds;
    overlayController.underlyingController = self;
    [self.view addSubview:overlayController.view];
    
    [self.overlayControllers addObject:overlayController];
    
    NSTimeInterval duration = 0.0f;
    if (flag)
    {
        duration = kTransitionAnimationDuration;
        overlayController.view.transform = CGAffineTransformMakeTranslation(0.0f, self.view.bounds.size.height);
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         overlayController.view.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                         {
                             dispatch_async(dispatch_get_main_queue(), completion);
                         }
                     }];
}

- (void)dismissOverLayViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    UIViewController *viewControllerToDismiss = self.overlayControllers.lastObject;
    if (!viewControllerToDismiss)
    {
        return;
    }
    
    NSTimeInterval duration = 0.0f;
    if (flag)
    {
        duration = kTransitionAnimationDuration;
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         viewControllerToDismiss.view.transform = CGAffineTransformMakeTranslation(0.0f, self.view.bounds.size.height);
                     }
                     completion:^(BOOL finished) {
                         [viewControllerToDismiss.view removeFromSuperview];
                         [self.overlayControllers removeObject:viewControllerToDismiss];
                         
                         if (completion)
                         {
                             dispatch_async(dispatch_get_main_queue(), completion);
                         }
                     }];
}

#pragma mark - Appearance Methods

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

@end
