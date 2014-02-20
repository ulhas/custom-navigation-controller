//
//  UICustomNavigationController.h
//  UICustomNavigationController
//
//  Created by Ulhas Mandrawadkar on 2/20/14.
//  Copyright (c) 2014 Ulhas Mandrawadkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomNavigationController : UIViewController

@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic, strong, readonly) UIViewController *rootViewController;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
