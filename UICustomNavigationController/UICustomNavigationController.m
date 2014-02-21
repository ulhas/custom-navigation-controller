//
//  UICustomNavigationController.m
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/20/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import "UICustomNavigationController.h"

static const NSTimeInterval kTransitionAnimationDuration = 5.0f;

@interface UICustomNavigationController ()

@property (nonatomic, strong) UIView *containerView;
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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupContainerView];
    [self setupControllerInContainerView:self.rootViewController];
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
}

- (void)addTopConstraintToView:(UIView *)view
{
    NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                            options:NSLayoutFormatDirectionLeadingToTrailing
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(view)];
    
    NSDictionary *metrics = @{@"viewHeight": @(view.bounds.size.height)};
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(viewHeight)]"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:metrics
                                                                            views:NSDictionaryOfVariableBindings(view)];
    
    [self.view addConstraints:horizontalConstraint];
    [self.view addConstraints:verticalConstraint];
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
    [self addBottomConstraintToView:self.toolBarView];
    [self.view bringSubviewToFront:self.toolBarView];
}

#pragma mark - ChildViewController Methods

- (void)setupControllerInContainerView:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.containerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (NSArray *)viewControllers
{
    return self.childViewControllers;
}

#pragma mark - Transition Methods

- (void)willTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    [self addChildViewController:toViewController];
    
    if (!self.shouldPop)
    {
        [fromViewController willMoveToParentViewController:nil];
    }
}

- (void)didTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    [toViewController didMoveToParentViewController:self];
    
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
                          toViewController:viewController];
    
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
                                    dispatch_sync(dispatch_get_main_queue(), completion);
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
                          toViewController:viewController];
    
    viewController.view.transform = CGAffineTransformMakeTranslation(0, topViewController.view.bounds.size.height);
    
    [self transitionFromViewController:topViewController
                      toViewController:viewController
                              duration:kTransitionAnimationDuration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                viewController.view.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
                                topViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -1 * topViewController.view.bounds.size.height);
                            }
                            completion:^(BOOL finished) {
                                [self didTransitionFromViewController:topViewController toViewController:viewController];
                                
                                if (completion)
                                {
                                    dispatch_sync(dispatch_get_main_queue(), completion);
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
                          toViewController:viewController];
    
    [self transitionFromViewController:topViewController
                      toViewController:viewController
                              duration:kTransitionAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {
                                [self didTransitionFromViewController:topViewController toViewController:viewController];
                                
                                if (completion)
                                {
                                    dispatch_sync(dispatch_get_main_queue(), completion);
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
