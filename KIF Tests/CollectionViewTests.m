//
//  CollectionViewTests.m
//  Test Suite
//
//  Created by Tony Mann on 7/31/13.
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

- (void)testTappingItems
{
    [tester tapItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] inCollectionViewWithAccessibilityIdentifier:@"CollectionView Tests CollectionView"];
    [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
    [tester tapItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] inCollectionViewWithAccessibilityIdentifier:@"CollectionView Tests CollectionView"];
    [tester waitForViewWithAccessibilityLabel:@"First Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testTappingLastItemAndSection
{
    [tester tapItemAtIndexPath:[NSIndexPath indexPathForItem:-1 inSection:-1] inCollectionViewWithAccessibilityIdentifier:@"CollectionView Tests CollectionView"];
    [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testOutOfBounds
{
    KIFExpectFailure([tester tapItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:99] inCollectionViewWithAccessibilityIdentifier:@"CollectionView Tests CollectionView"]);
}

- (void)testUnknownCollectionView
{
    KIFExpectFailure([[tester usingTimeout:1] tapItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] inCollectionViewWithAccessibilityIdentifier:@"Unknown CollectionView"]);
}

@end
