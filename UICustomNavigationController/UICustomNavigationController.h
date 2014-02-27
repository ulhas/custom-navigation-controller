//
//  UICustomNavigationController.h
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/20/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import "UIOverlayViewController.h"

@interface UICustomNavigationController : UIViewController

@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, readonly) UIViewController *topViewController;
@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) NSMutableArray *overlayControllers;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *toolBarView;

- (id)initWithRootViewController:(UIViewController *)rootViewController shouldPop:(BOOL)shouldPop;

- (void)slideUpViewControler:(UIViewController *)viewController completion:(void (^)(void))completion;
- (void)fadeInViewControler:(UIViewController *)viewController completion:(void (^)(void))completion;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)presentOverLayViewController:(UIOverlayViewController *)overlayController animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissOverLayViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
