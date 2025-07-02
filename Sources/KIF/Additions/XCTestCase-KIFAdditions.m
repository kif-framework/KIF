//
//  XCTestCase-KIFAdditions.m
//  KIF
//
//  Created by Tony DiPasquale on 12/9/13.
//
//

#import "XCTestCase-KIFAdditions.h"
#import "LoadableCategory.h"
#import "UIApplication-KIFAdditions.h"
#import "UIView-Debugging.h"
#import <objc/runtime.h>

MAKE_CATEGORIES_LOADABLE(TestCase_KIFAdditions)

static inline void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@interface XCTestCase ()
- (void)_recordUnexpectedFailureWithDescription:(id)arg1 exception:(id)arg2;
@end

@implementation XCTestCase (KIFAdditions)

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    self.continueAfterFailure = YES;

#ifdef __IPHONE_14_0
    NSString *filePath = exception.userInfo[@"FilenameKey"];
    NSInteger lineNumber = [exception.userInfo[@"LineNumberKey"] unsignedIntegerValue];
    XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:filePath
                                                                           lineNumber:lineNumber];
    XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:location];
    XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeAssertionFailure
                                  compactDescription:exception.description
                                 detailedDescription:nil
                                   sourceCodeContext:context
                                     associatedError:nil
                                         attachments:@[]];
    [self recordIssue:issue];
#else
    [self recordFailureWithDescription:exception.description inFile:exception.userInfo[@"FilenameKey"] atLine:[exception.userInfo[@"LineNumberKey"] unsignedIntegerValue] expected:NO];
#endif

    if (stop) {
        [self writeScreenshotForException:exception];
        [self printViewHierarchyIfOptedIn];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Swizzle([XCTestCase class], @selector(_recordUnexpectedFailureWithDescription:exception:), @selector(KIF_recordUnexpectedFailureWithDescription:exception:));
        });
        [exception raise];
    }
}

- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop
{
    NSException *lastException = exceptions.lastObject;
    for (NSException *exception in exceptions) {
        [self failWithException:exception stopTest:(exception == lastException ? stop : NO)];
    }
}

- (void)KIF_recordUnexpectedFailureWithDescription:(id)arg1 exception:(NSException *)arg2
{
    if (![[arg2 name] isEqualToString:@"KIFFailureException"]) {
        [self KIF_recordUnexpectedFailureWithDescription:arg1 exception:arg2];
    }
}

- (void)writeScreenshotForException:(NSException *)exception;
{
    [[UIApplication sharedApplication] writeScreenshotForLine:[exception.userInfo[@"LineNumberKey"] unsignedIntegerValue] inFile:exception.userInfo[@"FilenameKey"] description:nil error:NULL];

    if (@available(iOS 11.0, *)) {
        //semaphore will make sure the screenshot will be captured. otherwise it will crash on getting screenshot!
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        [XCTContext runActivityNamed:(@"screenshot") block:^(id<XCTActivity>  _Nonnull activity) {
            XCTAttachment *attachment = [XCTAttachment attachmentWithImage:[self _snapshotScreen]];
            attachment.name = @"Screenshot";
            [activity addAttachment:(attachment)];
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }   
}

- (UIImage *)_snapshotScreen
{
    UIView *view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
    [view layoutIfNeeded];

    CGRect bounds = view.bounds;
    NSAssert1(CGRectGetWidth(bounds), @"Zero width for view %@", view);
    NSAssert1(CGRectGetHeight(bounds), @"Zero height for view %@", view);

    UIGraphicsImageRenderer *graphicsImageRenderer = [[UIGraphicsImageRenderer alloc] initWithSize:bounds.size];

    return [graphicsImageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    }];
}

- (BOOL)_shouldPrintViewHierarchy
{
    static BOOL shouldPrint;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *shouldPrintValue = [NSProcessInfo.processInfo.environment objectForKey:@"KIF_PRINTVIEWTREEONFAILURE"];
        shouldPrint = [[shouldPrintValue uppercaseString] isEqualToString:@"YES"];
    });

    return shouldPrint;
}

- (BOOL)_shouldAttachViewHierarchy
{
    static BOOL shouldPrint;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *shouldPrintValue = [NSProcessInfo.processInfo.environment objectForKey:@"KIF_ATTACHVIEWTREEONFAILURE"];
        shouldPrint = [[shouldPrintValue uppercaseString] isEqualToString:@"YES"];
    });

    return shouldPrint;
}

- (void)printViewHierarchyIfOptedIn;
{
    NSString *hierarchy = [UIView viewHierarchyDescription];
    if ([self _shouldPrintViewHierarchy]) {
        printf("%s", hierarchy.UTF8String);
    }
    if ([self _shouldAttachViewHierarchy]) {
        [XCTContext runActivityNamed:@"view hierarchy" block:^(id<XCTActivity>  _Nonnull activity) {
            XCTAttachment *attachment = [XCTAttachment attachmentWithString:hierarchy];
            attachment.name = @"View Hierarchy";
            [activity addAttachment:attachment];
        }];
    }
}

@end

#ifdef __IPHONE_8_0

@interface XCTestSuite ()
- (void)_recordUnexpectedFailureForTestRun:(id)arg1 description:(id)arg2 exception:(id)arg3;
@end

@implementation XCTestSuite (KIFAdditions)

+ (void)load
{
    Swizzle([XCTestSuite class], @selector(_recordUnexpectedFailureForTestRun:description:exception:), @selector(KIF_recordUnexpectedFailureForTestRun:description:exception:));
}

- (void)KIF_recordUnexpectedFailureForTestRun:(XCTestSuiteRun *)arg1 description:(id)arg2 exception:(NSException *)arg3
{
    if (![[arg3 name] isEqualToString:@"KIFFailureException"]) {
        [self KIF_recordUnexpectedFailureForTestRun:arg1 description:arg2 exception:arg3];
    } else {
#ifdef __IPHONE_14_0
        NSString *description = [NSString stringWithFormat:@"Test suite stopped on fatal error: %@", arg3.description];
        NSString *filePath = arg3.userInfo[@"FilenameKey"];
        NSInteger lineNumber = [arg3.userInfo[@"LineNumberKey"] unsignedIntegerValue];
        XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:filePath
                                                                               lineNumber:lineNumber];
        XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:location];
        XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeAssertionFailure
                                      compactDescription:description
                                     detailedDescription:nil
                                       sourceCodeContext:context
                                         associatedError:nil
                                             attachments:@[]];
        [arg1 recordIssue:issue];
#else
        [arg1 recordFailureWithDescription:[NSString stringWithFormat:@"Test suite stopped on fatal error: %@", arg3.description] inFile:arg3.userInfo[@"FilenameKey"] atLine:[arg3.userInfo[@"LineNumberKey"] unsignedIntegerValue] expected:NO];
#endif
    }
}

@end

#endif
