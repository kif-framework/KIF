//
//  KIFTestStep+Exposers.h
//  KIF
//
//  Created by Nate Chandler on 4/3/13.
//
//

#import "KIFTestStep.h"

@interface KIFTestStep (Exposers)

@property (nonatomic) KIFTestStepExecutionBlock executionBlock;
@property (nonatomic) NSString *notificationName;
@property (nonatomic) id notificationObject;
@property (nonatomic) BOOL notificationOccurred;
@property (nonatomic) BOOL observingForNotification;

@end
