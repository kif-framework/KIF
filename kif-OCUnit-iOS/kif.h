//
//  kif-OCUnit-iOS.h
//  kif-OCUnit-iOS
//
//  Created by Simone Manganelli on 25/03/15.
//
//

#import <UIKit/UIKit.h>

//! Project version number for kif-OCUnit-iOS.
FOUNDATION_EXPORT double kif_OCUnit_iOSVersionNumber;

//! Project version string for kif-OCUnit-iOS.
FOUNDATION_EXPORT const unsigned char kif_OCUnit_iOSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <kif_OCUnit_iOS/PublicHeader.h>


#import <KIF/KIFTestActor.h>
#import <KIF/KIFTestCase.h>
#import <KIF/KIFSystemTestActor.h>
#import <KIF/KIFUITestActor.h>
#import <KIF/KIFUITestActor-ConditionalTests.h>
#import <KIF/CGGeometry-KIFAdditions.h>
#import <KIF/KIFTestStepValidation.h>
#import <KIF/KIFTypist.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#import <KIF/LoadableCategory.h>
#import <KIF/NSBundle-KIFAdditions.h>
#import <KIF/NSError-KIFAdditions.h>
#import <KIF/NSException-KIFAdditions.h>
#import <KIF/NSFileManager-KIFAdditions.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <KIF/UIApplication-KIFAdditions.h>
#import <KIF/UIScrollView-KIFAdditions.h>
#import <KIF/UITableView-KIFAdditions.h>
#import <KIF/UITouch-KIFAdditions.h>
#import <KIF/UIWindow-KIFAdditions.h>

#ifndef KIF_SENTEST
#import <KIF/XCTestCase-KIFAdditions.h>
#else
#import <KIF/SenTestCase-KIFAdditions.h>
#endif