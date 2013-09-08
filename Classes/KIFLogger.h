//
//  KIFLogger.h
//  KIF
//
//  Created by Fahim Farook on 10/3/13.
//
//

#import <Foundation/Foundation.h>

@class KIFTestController;
@class KIFTestScenario;
@class KIFTestStep;

@interface KIFLogger: NSObject

@property (nonatomic, retain) KIFTestController *controller;
@property (nonatomic, retain) NSString *logDirectory;
@property (nonatomic, retain) NSString *logFile;
@property (nonatomic, retain) NSString *fileExt;
@property (nonatomic, retain) NSString *filePath;

-(NSFileHandle *)logFileHandle;
-(void)logTestingDidStart;
-(void)logTestingDidFinish;
-(void)logDidStartScenario:(KIFTestScenario *)scenario;
-(void)logDidSkipScenario:(KIFTestScenario *)scenario;
-(void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString;
-(void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;
-(void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
-(void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;

@end
