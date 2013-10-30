//
//  CollectionViewController.m
//  KIF
//
//  Created by Andrew Farmer on 10/28/13.
//
//

@interface CollectionViewController : UICollectionViewController

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionviewcell"];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionviewcell" forIndexPath:indexPath];
  if (!cell) {
    cell = [[UICollectionViewCell alloc] init];
  }
  
  int item = [indexPath item];
  if (item == 0) {
    [cell setAccessibilityLabel:@"First Cell"];
  } else if (item == [self.collectionView numberOfItemsInSection:0] - 1) {
    [cell setAccessibilityLabel:@"Last Cell"];
  } else {
    [cell setAccessibilityLabel:nil];
  }
  
  [cell setBackgroundColor:[UIColor blueColor]];
  
  return cell;
}

- (int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 100;
}


@end
