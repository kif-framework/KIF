//
//  KIFTester+Generic.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <UIKit/UIKit.h>
#import "KIFTestActor.h"
#import <UIKit/UIKit.h>

#define system KIFActorWithClass(KIFSystemTestActor)

@interface KIFSystemTestActor : KIFTestActor

/*!
 @abstract Waits for a specific NSNotification.
 @discussion Useful when a test requires an asynchronous task to complete, especially when that task does not trigger a visible change in the view hierarchy.
 @param name The name of the NSNotification.
 @param object The object to which the step should listen. Nil value will listen to all objects.
 @return The detected NSNotification.
 */
- (NSNotification *)waitForNotificationName:(NSString*)name object:(id)object;

/*!
 @abstract Waits for a specific NSNotification, emitted during or after execution of a block.
 @discussion Useful when step execution causes a notification to be emitted, but executes too quickly for waitForNotificationName: to observe it.
 An observer will be registered for the notification before the block is executed.
 @param name The name of the NSNotification.
 @param object The object to which the step should listen. Nil value will listen to all objects.
 @param block The block of code to be executed.
 @return The detected NSNotification.
 */
- (NSNotification *)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)())block;

/*!
 @abstract Simulates a memory warning.
 */
- (void)simulateMemoryWarning;

/*!
 @abstract Simulates a device rotation to a specific orentation from its last set orientation.
 @discussion The first time this method is called, it will be from the device's natural orientation to the orientation described.
 @param orientation The desired orientation.
 */
- (void)simulateDeviceRotationToOrientation:(UIDeviceOrientation)orientation;

/*!
 @abstract Waits for the application to request a specific URL while executing a block.
 @param URLString The absolute string representation of the URL to detect.
 @param block The block of code to be executed.
 @param returnValue The value to return from @c +[UIApplication openURL:].
 */
- (void)waitForApplicationToOpenURL:(NSString *)URLString whileExecutingBlock:(void(^)())block returning:(BOOL)returnValue;

/*!
 @abstract Waits for the application to request any URL while executing a block.
 @param block The block of code to be executed.
 @param returnValue The value to return from @c +[UIApplication openURL:].
 */
- (void)waitForApplicationToOpenAnyURLWhileExecutingBlock:(void(^)())block returning:(BOOL)returnValue;

/*!
 @abstract Captured a screenshot of the current screen and writes it to disk with an optional description.
 @discussion This step will fail if the @c KIF_SCREENSHOTS environment variable is not set or if the screenshot cannot be written to disk.
 @param description A description to use when writing the file to disk.
 */
- (void)captureScreenshotWithDescription:(NSString *)description;

@end

/**
 The `ViewControllerActions` category provides system level actions for triggering the instantation and presentation of `UIViewController` objects from code or loaded from Storyboards. These actions support the use of KIF during TDD or as a functional testing tool.
 */
@interface KIFSystemTestActor (ViewControllerActions)

/**
 The default `UINavigationBar` subclass to use when presenting view controllers without a navigation bar class specified.

 This is a subclass of `UINavigationBar` that is used when presenting view controllers via `presentViewControllerWithClass:withinNavigationControllerWithNavigationBarClass:toolbarClass:configurationBlock:` when the `navigationBarClass` argument is `nil`.
 */
@property (nonatomic, strong) Class defaultNavigationBarClass;

/**
 The default `UIToolbar` subclass to use when presenting view controllers without a toolbar bar class specified.

 This is a subclass of `UIToolbar` to use when presenting view controllers via `presentViewControllerWithClass:withinNavigationControllerWithNavigationBarClass:toolbarClass:configurationBlock:` when the `toolbarClass` argument is `nil`.
 */
@property (nonatomic, strong) Class defaultToolbarClass;

/**
 Instantiates and presents an instance of the specified `UIViewController` subclass within a `UINavigationController` instance with the specified `UINavigationBar` and `UIToolbar` subclasses, optionally yielding the instantiated controller to the block for configuration.

 @param viewControllerClass The `UIViewController` subclass to instantiate. Cannot be `nil`.
 @param navigationBarClass A subclass of `UINavigationBar` to use when instantiating the `UINavigationController` instance within which the view controller instance will be presented. If `nil`, then the class specified via `setDefaultNavigationBarClass:` will be used.
 @param toolbarClass A subclass of `UIToolbar` to use when instantiating the `UINavigationController` instance within which the view controller instance will be presented. If `nil`, then the class specified via `setDefaultToolbarClass:` will be used.
 @param configurationBlock An optional block in which to yield the newly instantiated view controller instance prior to presenting it in the main window.
 */
- (void)presentViewControllerWithClass:(Class)viewControllerClass withinNavigationControllerWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
                    configurationBlock:(void (^)(id viewController))configurationBlock;

/*!
 @method stepToPresentViewControllerWithIdentifier:fromStoryboardWithName:configurationBlock:
 @abstract A step that presents a view controller with a given identifier from a Storyboard
 with a given name.
 @discussion The view controller will be instantiated through the Storyboard and presented within a
 new UINavigationController, which will be configured as the root view controller of the
 application's primary window. The UIViewController is yielded to the configuration block before
 presentation so that any required setup work may be done (i.e. setting required properties).
 @param controllerIdentifier The identifier of the desired controller within the Storyboard.
 @param storyboardName The name of the Storyboard from which to instantiate the view controller.
 @param configurationBlock An optional configuration block which is invoked with the view controller
 before it is presented.
 @result A configured test step.
 */
- (void)presentViewControllerWithIdentifier:(NSString *)controllerIdentifier fromStoryboardWithName:(NSString *)storyboardName configurationBlock:(void (^)(UIViewController *viewController))configurationBlock;

/*!
 @method stepToPresentModalViewControllerWithIdentifier:fromStoryboardWithName:configurationBlock:
 @abstract A step that modally presents a view controller with a given identifier from a Storyboard
 with a given name.
 @discussion The view controller will be instantiated through the Storyboard and presented
 modally over a vanilla UIViewController configured as the root view controller of a new
 UINavigationController, which will be configured as the root view controller of the
 application's primary window. The UIViewController is yielded to the configuration block before
 presentation so that any required setup work may be done (i.e. setting required properties).
 @param controllerIdentifier The identifier of the desired controller within the Storyboard.
 @param storyboardName The name of the Storyboard from which to instantiate the view controller.
 @param configurationBlock An optional configuration block which is invoked with the view controller
 before it is presented.
 @result A configured test step.
 */
- (void)presentModalViewControllerWithIdentifier:(NSString *)controllerIdentifier fromStoryboardWithName:(NSString *)storyboardName configurationBlock:(void (^)(UIViewController *viewController))configurationBlock;

@end
