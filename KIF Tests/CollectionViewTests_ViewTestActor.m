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

- (instancetype)firstCollectionViewCell;
{
    return [viewTester usingAccessibilityLabel:@"First Cell"];
}

- (instancetype)lastCollectionViewCell;
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
    [[[viewTester lastCollectionViewCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
    [[viewTester collectionView] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [[[viewTester firstCollectionViewCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingLastItemAndSection
{
    [[viewTester collectionView] tapCollectionViewItemAtIndexPath:[NSIndexPath indexPathForItem:-1 inSection:-1]];
    [[[viewTester lastCollectionViewCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
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
    [[viewTester firstCollectionViewCell] tap];

    // Tap the last item, which will need to be scrolled up
    [[viewTester lastCollectionViewCell] tap];

    // Tap the first item, which will need to be scrolled down
    [[viewTester firstCollectionViewCell] tap];
}

@end
