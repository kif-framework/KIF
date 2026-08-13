//
//  CollectionViewController.m
//  Test Suite
//
//  Created by Tony Mann on 11/5/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@end

@implementation CollectionViewCell
@end

@interface CollectionViewSectionHeader : UICollectionReusableView
@end

@implementation CollectionViewSectionHeader
@end

@interface CollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        [self.collectionView registerClass:[CollectionViewSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewSectionHeader"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self.collectionView registerClass:[CollectionViewSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewSectionHeader"];
    [self.collectionView registerClass:[CollectionViewSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionViewSectionFooter"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BOOL isHeader = [kind isEqualToString:UICollectionElementKindSectionHeader];
    NSString *identifier = isHeader ? @"CollectionViewSectionHeader" : @"CollectionViewSectionFooter";
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    view.isAccessibilityElement = YES;
    view.accessibilityLabel = isHeader ? @"Section Header" : @"Section Footer";
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.accessibilityLabel = @"First Cell";
        cell.label.text = @"First";
    } else if (indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        cell.accessibilityLabel = @"Last Cell";
        cell.label.text = @"Last";
    } else {
        cell.accessibilityLabel = @"Filler";
        cell.label.text = @"Filler";
    }
    
    return cell;
}

@end
