//
//  LUConsolePluginViewController.m
//  LunarConsole
//
//  Created by Alex Lementuev on 2/26/16.
//  Copyright © 2016 Space Madness. All rights reserved.
//

#import "Lunar.h"

#import "LUConsolePluginController.h"

@interface LUConsolePluginController () <UIPageViewControllerDataSource, LUActionControllerDelegate>
{
    LU_WEAK LUConsolePlugin  * _consolePlugin;
    UIPageViewController    * _pageController;
    NSArray                 * _pageControllers;
}

@end

@implementation LUConsolePluginController

+ (instancetype)controllerWithPlugin:(LUConsolePlugin *)consolePlugin
{
    return [[self alloc] initWithPlugin:consolePlugin];
}

- (instancetype)initWithPlugin:(LUConsolePlugin *)consolePlugin
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        _consolePlugin = consolePlugin;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LUConsoleLogController *consoleLogController = [LUConsoleLogController controllerWithConsole:_consolePlugin.console];
    if (consoleLogController == nil)
    {
        NSLog(@"Can't create plugin root controller: console log controller was not initialized");
        return;
    }
    
    LUActionController *actionController = [LUActionController controllerWithActionRegistry:_consolePlugin.actionRegistry];
    if (actionController == nil)
    {
        NSLog(@"Can't create plugin root controller: action controller was not initialized");
        return;
    }
    actionController.delegate = self;
    
    _pageControllers = [[NSArray alloc] initWithObjects:consoleLogController, actionController, nil];
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    [_pageController setViewControllers:[NSArray arrayWithObject:consoleLogController]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    _pageController.dataSource = self;
    
    [self addChildController:_pageController];
}


#pragma mark -
#pragma mark Controllers

- (NSInteger)indexOfViewController:(UIViewController *)controller
{
    for (NSInteger i = 0; i < _pageControllers.count; ++i)
    {
        if (controller == _pageControllers[i])
        {
            return i;
        }
    }
    
    return -1;
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self indexOfViewController:viewController];
    return currentIndex != -1 && currentIndex > 0 ? _pageControllers[currentIndex - 1] : nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self indexOfViewController:viewController];
    return currentIndex != -1 && currentIndex < _pageControllers.count - 1 ? _pageControllers[currentIndex + 1] : nil;
}

#pragma mark -
#pragma mark LUActionControllerDelegate

- (void)actionController:(LUActionController *)controller didSelectActionWithId:(int)actionId
{
    if ([_delegate respondsToSelector:@selector(pluginController:didSelectActionWithId:)])
    {
        [_delegate pluginController:self didSelectActionWithId:actionId];
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)onClose:(id)sender
{
    if ([_delegate respondsToSelector:@selector(pluginControllerDidClose:)])
    {
        [_delegate pluginControllerDidClose:self];
    }
}

#pragma mark -
#pragma mark Helpers

- (void)addChildController:(UIViewController *)childController
{
    [self addChildViewController:childController];
    childController.view.frame = self.view.bounds;
    [self.view insertSubview:childController.view atIndex:0];
    [childController didMoveToParentViewController:self];
}

@end
