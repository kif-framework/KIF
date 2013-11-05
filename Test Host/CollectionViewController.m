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

@interface CollectionViewController : UICollectionViewController
@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:
            cell.accessibilityLabel = @"First Cell";
            cell.label.text = @"First";
            break;
        
        case 2:
            cell.accessibilityLabel = @"Last Cell";
            cell.label.text = @"Last";
            break;
            
        default:
            cell.label.text = @"Filler";
            break;
    }
    
    return cell;
}

@end
