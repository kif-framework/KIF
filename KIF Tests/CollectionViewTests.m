//
//  CollectionViewTests.m
//  Test Suite
//
//  Created by Andrew Farmer on 10/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface CollectionViewTests : KIFTestCase
@end

@implementation CollectionViewTests

- (void)beforeEach
{
  [tester tapViewWithAccessibilityLabel:@"CollectionViews"];
}

- (void)afterEach
{
  [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testTappingFirstAndLastCells
{
  [tester tapFirstCellInCollectionViewWithAccessibilityIdentifier:@"Test Collection View"];
  [tester waitForViewWithAccessibilityLabel:@"First Cell" traits:UIAccessibilityTraitSelected];

  [tester tapLastCellInCollectionViewWithAccessibilityIdentifier:@"Test Collection View"];
  [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testOutOfBounds
{
  KIFExpectFailure([tester tapCellAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:99] inCollectionViewWithAccessibilityIdentifier:@"CollectionView Test View"]);
}

- (void)testUnknownCollectionView
{
  KIFExpectFailure([tester tapCellAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] inCollectionViewWithAccessibilityIdentifier:@"Unknown Collection View"]);
}

@end
