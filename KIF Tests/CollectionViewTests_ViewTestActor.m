//
//  NewCollectionViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@implementation KIFUIViewTestActor (collectionViewTests)

- (instancetype)collectionView;
{
    return [viewTester usingAccessibilityIdentifier:@"CollectionView Tests CollectionView"];
}

- (instancetype)firstCell;
{
    return [viewTester usingAccessibilityLabel:@"First Cell"];
}

- (instancetype)lastCell;
{
    return [viewTester usingAccessibilityLabel:@"Last Cell"];
}

@end

@interface CollectionViewTests_ViewTestActor : KIFTestCase
@end

@implementation CollectionViewTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"CollectionViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingItems
{
    [[viewTester collectionView] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:199 inSection:0]];
    [[[viewTester lastCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
    [[viewTester collectionView] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [[[viewTester firstCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingLastItemAndSection
{
    [[viewTester collectionView] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:-1 inSection:-1]];
    [[[viewTester lastCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testOutOfBounds
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityIdentifier:@"CollectionView Tests CollectionView"] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:99]]);
}

- (void)testUnknownCollectionView
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityIdentifier:@"Unknown CollectionView"] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]);
}

- (void)testTappingItemsByLabel
{
    // Tap the first item, which is already visible
    [[viewTester firstCell] tap];

    // Tap the last item, which will need to be scrolled up
    [[viewTester lastCell] tap];

    // Tap the first item, which will need to be scrolled down
    [[viewTester firstCell] tap];
}

@end
