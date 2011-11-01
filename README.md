KIF iOS Integration Testing Framework
=====================================

KIF, which stands for Keep It Functional, is an iOS integration test framework. It allows for easy automation of iOS apps by leveraging the accessibility attributes that the OS makes available for those with visual disabilities.

**KIF uses undocumented Apple APIs.** This is true of most iOS testing frameworks, and is safe for testing purposes, but it's important that KIF does not make it into production code, as it will get your app submission denied by Apple. Follow the instructions below to ensure that KIF is configured correctly for your project.

There's [a port underway to use KIF with Mac OS X apps](https://github.com/joshaber/KIF), as well.

Features
--------

#### Minimizes Indirection
All of the tests for KIF are written in Objective C. This allows for maximum integration with your code while minimizing the number of layers you have to build.

#### Easy Configuration
KIF integrates directly into your iOS app, so there's no need to run an additional web server or install any additional packages.

#### Test Like a User
KIF attempts to imitate actual user input. Automation is done using tap events wherever possible.


Installation
------------

To install KIF, you'll need to link the libKIF static library directly into your application. Download the source from the [KIF GitHub repository](https://github.com/square/KIF) and follow the instructions below.

*NOTE* These instruction assume you are using Xcode 4. For Xcode 3 you won't be able to take advantage of Workspaces, so the instructions will differ slightly.

### Add KIF to your project files
The first step is to add the KIF project into the ./Frameworks/KIF subdirectory of your existing app. If your project uses Git for version control, you can use submodules to make updating in the future easier:

	cd /path/to/MyApplicationSource
	mkdir Frameworks
	git submodule add https://github.com/square/KIF.git Frameworks/KIF

If you're not using Git, simply download the source and copy it into the ./Frameworks/KIF directory.

### Add KIF to Your Workspace
Let your project know about KIF by adding the KIF project into a workspace along with your main project. Find the KIF.xcodeproj file in Finder and drag it into the Project Navigator (⌘1). If you don't already have a workspace, Xcode will ask if you want to create a new one. Click "Save" when it does.

![Create workspace screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Create Workspace.png)

### Create a Testing Target
You'll need to create a second target for the KIF-enabled version of the app to test. This gives you an easy way to begin testing -- just run this second target -- and also helps make sure that no testing code ever makes it into your App Store submission and gets your app rejected.

The new target will start as a duplicate of your old target. To create the duplicate target, select the project file for your app in the Project Navigator. From there, CTRL+click the target for your app and select the "Duplicate" option.

![Duplicate target screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Duplicate Target.png)

Xcode may ask you if you want your copy to be for a different iOS device, which you don't, so choose "Duplicate Only". 

![Duplicate target confirmation screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Duplicate Target Confirmation.png)

The new target will be created and you can rename it to something like "Integration Tests" if you wish.

![Rename target screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Rename Target.png)

You can also (optionally) rename the new target from the default "MyApp copy" to something like "MyApp (Integration Tests)" by selecting the "Build Settings" tab and searching for "Product Name", then changing the value to what you want.

![Rename product screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Rename Product.png)

### Configure the Testing Target
Now that you have a target for your tests, add the tests to that target. With the project settings still selected in the Project Navigator, and the new integration tests target selected in the project settings, select the "Build Phases" tab. Under the "Link Binary With Libraries" section, hit the "+" button. In the sheet that appears, select "libKIF.a" and click "Add".

![Add libKIF library screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Add Library.png)

![Add libKIF library screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Add Library Sheet.png)

Next, make sure that we can access the KIF header files. To do this, add the KIF directory to the "Header Search Paths" build setting. Start by selecting the "Build Settings" tab of the project settings, and from there, use the filter control to find the "Header Search Paths" setting. Double click the value, and add the search path `$(SRCROOT)/Frameworks/KIF/` to the list. Mark the entry as recursive. If it's not there already, you should add the `$(inherited)` entry as the first entry in this list.

![Add header search paths screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Add Header Search Paths.png)

KIF takes advantage of Objective C's ability to add categories on an object, but this isn't enabled for static libraries by default. To enable this, add the `-ObjC` and `-all_load` flags to the "Other Linker Flags" build setting as shown below.

![Add category linker flags screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Add Category Linker Flags.png)

Finally, add a preprocessor flag to the testing target so that you can conditionally include code. This will help make sure that none of the testing code makes it into the production app. Call the flag `RUN_KIF_TESTS` and add it under the "Preprocessor Macros." Again, make sure the `$(inherited)` entry is first in the list, 

![Add preprocessor macro screen shot](https://github.com/square/KIF/raw/master/Documentation/Images/Add KIF Preprocessor Macro.png)

Example
-------
With your project configured to use KIF, it's time to start writing tests. There are three main classes used in KIF testing: the test runner (`KIFTestController`), a testable scenario (`KIFTestScenario`), and a test step (`KIFTestStep`). The test runner is composed of a list of scenarios that it runs, and in turn each scenario is composed of a list of steps. A step is a small and simple action which is generally used to imitate a user interaction. Three of the most common steps are "tap this view," "enter text into this view," and "wait for this view." These steps are included as factory methods on `KIFTestStep` in the base KIF implementation.

KIF relies on the built-in accessibility of iOS to perform its test steps. As such, it's important that your app is fully accessible. This is also a great way to ensure that your app is usable by the sight impaired. Making your application accessible is usually as easy as giving your views reasonable labels. More details are available in [Apple's Documentation](http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html#//apple_ref/doc/uid/TP40008785-CH102-SW5).

Although not required, it's recommended that you create a subclass of `KIFTestController` that is specific to your application. This subclass will override the `-initializeScenarios` method, which will contain a list of invocations for the scenarios that your test suite will run. We'll call our subclass `EXTestController`, and will add an initial test scenario, which we will define later.

*EXTestController.h*

	#import <Foundation/Foundation.h>
	#import "KIFTestController.h"

	@interface EXTestController : KIFTestController {}

	@end

*EXTestController.m*

	#import "EXTestController.h"

	@implementation EXTestController

	- (void)initializeScenarios;
	{
	    [self addScenario:[KIFTestScenario scenarioToLogIn]];
		// Add additional scenarios you want to test here
	}

	@end

The next step is to implement a scenario to test the login (`+[KIFTestScenario scenarioToLogin]`). We'll implement the scenarios as category class methods on `KIFTestScenario`. This will allow us to easily add on these category methods without needing additional subclasses, and the method name provides a unique identifier for referencing each scenario. Your `KIFTestScenario` category should look something like this:

*KIFTestScenario+EXAdditions.h*

	#import <Foundation/Foundation.h>
	#import "KIFTestScenario.h"

	@interface KIFTestScenario (EXAdditions)

	+ (id)scenarioToLogIn;

	@end

*KIFTestScenario+EXAdditions.m*

	#import "KIFTestScenario+EXAdditions.h"
	#import "KIFTestStep.h"
	#import "KIFTestStep+EXAdditions.h"

	@implementation KIFTestScenario (EXAdditions)

	+ (id)scenarioToLogIn;
	{
	    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
	    [scenario addStep:[KIFTestStep stepToReset]];
	    [scenario addStepsFromArray:[KIFTestStep stepsToGoToLoginPage]];
	    [scenario addStep:[KIFTestStep stepToEnterText:@"user@example.com" intoViewWithAccessibilityLabel:@"Login User Name"]];
	    [scenario addStep:[KIFTestStep stepToEnterText:@"thisismypassword" intoViewWithAccessibilityLabel:@"Login Password"]];
	    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log In"]];
    
	    // Verify that the login succeeded
	    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Welcome"]];
    
	    return scenario;
	}

	@end

Most of the steps in the scenario are already defined by the KIF framework, but `+stepToReset` is not. This is an example of a custom step which is specific to your application. Adding such a step is easy, and is done using a factory method in a category of `KIFTestStep`, similar to how we added the scenario.

*KIFTestStep+EXAdditions.h*

	#import <Foundation/Foundation.h>
	#import "KIFTestStep.h"

	@interface KIFTestStep (EXAdditions)

	+ (id)stepToReset;

	@end

*KIFTestStep+EXAdditions.m*

	#import "KIFTestStep+EXAdditions.h"

	@implementation KIFTestStep (EXAdditions)

	+ (id)stepToReset;
	{
	    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
	        BOOL successfulReset = YES;
        
	        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        
	        KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
        
	        return KIFTestStepResultSuccess;
	    }];
	}

	@end

The other line to notice in the sample scenario is the one that calls `+[KIFTestStep stepsToGoToLoginPage]`. This is an example of an organizational technique which allows for easy code reuse. If you have a set of steps that are reused in a number of your scenarios, then you can group them together as a factory method that returns them as an array. Here's the `KIFTestStep` category again, this time including the step collection array:

*KIFTestStep+EXAdditions.h*

	#import <Foundation/Foundation.h>
	#import "KIFTestStep.h"

	@interface KIFTestStep (EXAdditions)

	// Factory Steps

	+ (id)stepToReset;

	// Step Collections

	// Assumes the application was reset and sitting at the welcome screen
	+ (NSArray *)stepsToGoToLoginPage;

	@end

*KIFTestStep+EXAdditions.m*

	#import "KIFTestStep+EXAdditions.h"

	@implementation KIFTestStep (EXAdditions)

	#pragma mark - Factory Steps

	+ (id)stepToReset;
	{
	    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
	        BOOL successfulReset = YES;
        
	        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        
	        KIFTestCondition(successfulReset, error, @"Failed to reset some part of the application.");
        
	        return KIFTestStepResultSuccess;
	    }];
	}

	#pragma mark - Step Collections

	+ (NSArray *)stepsToGoToLoginPage;
	{
	    NSMutableArray *steps = [NSMutableArray array];
    
	    // Dismiss the welcome message
	    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"That's awesome!"]];
    
	    // Tap the "I already have an account" button
	    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"I already have an account."]];
    
	    return steps;
	}

	@end

Finally, the app needs a hook so that it actually runs the KIF tests when executing the Integration Tests target. To do this we'll take advantage of the `RUN_KIF_TESTS` macro that was defined earlier. This macro is only defined in the testing target, so the tests won't run in the regular target. To invoke the test suite, add the following code to the end of the `-application:didFinishLaunchingWithOptions:` method in your application delegate:

	#if RUN_KIF_TESTS
	    [[EXTestController sharedInstance] startTestingWithCompletionBlock:^{
	        // Exit after the tests complete so that CI knows we're done
	        exit([[EXTestController sharedInstance] failureCount]);
	    }];
	#endif

Everything should now be configured. When you run the integration tests target it will launch your app and begin running the testing scenarios. When the scenarios finish, the app will exit and return a zero if all scenarios pass, or the number of failures if any fail.

KIF also generates a nicely formatted log containing the full results and timings of the test suite run. The logs can be found in 	

	~/Library/Application Support/iPhone Simulator/<iOS version>/Applications/<Application UUID>/Library/Logs/

For a simple but complete example of KIF in action, check out the Testable sample project in Documentation/Examples.

Environment Variables
---------------------

You can set a number of environment variables to unlock hidden features of KIF.

### `KIF_SCREENSHOTS`

Set `KIF_SCREENSHOTS` to the full path to a folder on your computer to have KIF output a screenshot of your app as it appears when any given step fails.

### `KIF_FAILURE_FILE`

Set `KIF_FAILURE_FILE` to the full path to a file on your computer -- that need not exist -- to have KIF keep track of the failing scenarios it encounters during a test run. If any scenarios fail during a run and `KIF_FAILURE_FILE` is set, the next run will only run the scenarios that failed the previous time. Once all of the scenarios succeed again, KIF will return to running all scenarios. This is useful if you're fixing a failing scenario, as it allows you to jump right back to where the problem was.

### `KIF_SCENARIO_FILTER`

Set `KIF_SCENARIO_FILTER` to a regular expression and KIF will only run scenarios with descriptions matching the expression. This can be useful to skip straight to a particular point in your testing suite.

### `KIF_SCENARIO_LIMIT`

Set `KIF_SCENARIO_LIMIT` to exit after a certain number of scenarios. This can be useful if you want to divide your test suite among several machines or several devices when combined with `KIF_INITIAL_SKIP_COUNT` below.

### `KIF_INITIAL_SKIP_COUNT`

Set `KIF_INITIAL_SKIP_COUNT` to skip a certain number of scenarios at the beginning of the testing run. For example, if you wanted to split your suite of 100 scenarios between two iPads, you could set `KIF_SCENARIO_LIMIT` to 50, start the first iPad, then set `KIF_INITIAL_SKIP_COUNT` to 50 and start the second iPad.

### `KIF_EXIT_ON_FAILURE`

Set this to a value that evaluates to true to make KIF exit on the first failing scenario. This may be useful if you want to isolate failures or if your app doesn't properly recover when a test fails.

Troubleshooting
---------------

### Step fails because a view cannot be found

If KIF is failing to find a view, the most likely cause is that the view doesn't have its accessibility label set. If the view is defined in a xib, then the label can be set using the inspector. If it's created programmatically, simply set the accessibilityLabel attribute to the desired label.

If the label is definitely set correctly, take a closer look at the error given by KIF. This error should tell you more specifically why the view was not accessible. If you are using `-stepToWaitForTappableViewWithAccessibilityLabel:`, then make sure the view is actually tappable. For items such as labels which cannot become the first responder, you may need to use `-stepToWaitForViewWithAccessibilityLabel:` instead.

### Project fails to build because KIF classes are missing

If your project doesn't build because the compiler can't find the KIF classes, there are common problems. First, check that the header search paths points to the correct location, as described above. Second, make sure that all of your KIF related implementation files (.m files) are included in the correct target. Select each of the your KIF related files and check the Target Membership section of the inspector on the righthand side of Xcode. For each file, *only* the integration tests target should be checked.

### Unrecognized selector when first trying to run

If the first time you try to run KIF you get the following error:

	2011-06-13 13:54:53.295 Testable (Integration Tests)[12385:207] -[NSFileManager createUserDirectory:]: unrecognized selector sent to instance 0x4e02830
	2011-06-13 13:54:53.298 Testable (Integration Tests)[12385:207] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[NSFileManager createUserDirectory:]: unrecognized selector sent to instance 0x4e02830'

or if you get another "unrecognized selector" error inside the KIF code, make sure that you've properly set the -ObjC and -all_load flags as described above. Without these flags your app can't access the category methods that are necessary for KIF to work properly.

Continuous Integration
----------------------

A continuous integration (CI) process is highly recommended and is extremely useful in ensuring that your application stays functional. In order to run our KIF tests in CI, you'll need to be able to launch the simulator from the command line. One tool for accomplishing this is [WaxSim](https://github.com/square/waxsim). Note that the Square fork of WaxSim provides a number of bug fixes and some useful additional functionality. Your CI script should resemble something like the this:
	
	#!/bin/bash
	
	killall "iPhone Simulator"
	
	set -o errexit
	set -o verbose
	
	# Build the "Integration Tests" target to run in the simulator
	xcodebuild -target "Integration Tests" -configuration Release -sdk iphonesimulator build
	
	# Run the app we just built in the simulator and send its output to a file
	# /path/to/MyApp.app should be the relative or absolute path to the application bundle that was built in the previous step
	/path/to/waxsim -f "ipad" "/path/to/MyApp.app" > /tmp/KIF-$$.out 2>&1
	
	# WaxSim hides the return value from the app, so to determine success we search for a "no failures" line
	grep -q "TESTING FINISHED: 0 failures" /tmp/KIF-$$.out
	
This should provide a strong starting point, but you'll likely want to customize the script further. For example, you may want it to run `iphone` rather than `ipad`, or perhaps both.

Contributing
------------

We're glad you're interested in KIF, and we'd love to see where you take it.

Any contributors to the master KIF repository must sign the [Individual Contributor License Agreement (CLA)](https://spreadsheets.google.com/spreadsheet/viewform?formkey=dDViT2xzUHAwRkI3X3k5Z0lQM091OGc6MQ&ndplr=1). It's a short form that covers our bases and makes sure you're eligible to contribute.

When you have a change you'd like to see in the master repository, [send a pull request](https://github.com/square/KIF/pulls). Before we merge your request, we'll make sure you're in the list of people who have signed a CLA.

Thanks, and happy testing!
