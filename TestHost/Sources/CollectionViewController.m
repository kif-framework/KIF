//
//  CollectionViewController.m
//  Test Suite
//
//  Created by Tony Mann on 11/5/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *label;
@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.clipsToBounds = YES;
        self.multipleTouchEnabled = YES;
        self.contentMode = UIViewContentModeCenter;

        self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.label.opaque = NO;
        self.label.backgroundColor = nil;
        self.label.contentMode = UIViewContentModeLeft;
        self.label.text = @"Label";
        self.label.font = [UIFont systemFontOfSize:17];
        self.label.textColor = [UIColor darkTextColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
        [self.label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end

@interface CollectionViewController : UICollectionViewController
@end

@implementation CollectionViewController

- (void)loadView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 414, 804) collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.opaque = NO;
    collectionView.multipleTouchEnabled = YES;
    collectionView.minimumZoomScale = 0;
    collectionView.maximumZoomScale = 0;
    if (@available(iOS 14.0, *)) {
        collectionView.allowsSelectionDuringEditing = YES;
    }
    collectionView.backgroundColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    collectionView.accessibilityIdentifier = @"CollectionView Tests CollectionView";
    collectionView.dataSource = self;
    collectionView.delegate = self;

    self.collectionView = collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
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
