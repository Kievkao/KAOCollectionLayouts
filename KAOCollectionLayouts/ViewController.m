//
//  ViewController.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/17/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "ViewController.h"

#import "KAOCardLayout.h"
#import "KAOFallingLayout.h"

typedef enum : NSUInteger {
    KAOCardLayoutType,
    KAOFallingLayoutType
} KAOLayoutType;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGPoint contentOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareCollectionView:self.collectionView forLayoutType:KAOCardLayoutType];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 25;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KAODemoCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectInset(collectionView.frame, 20, 20).size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    self.contentOffset = CGPointMake(indexPath.item * [self.collectionView bounds].size.height, 0);
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self.collectionView setContentOffset:self.contentOffset];
}

- (void)prepareCollectionView:(UICollectionView *)collectionView forLayoutType:(KAOLayoutType)layoutType {
    
    switch (layoutType) {
        case KAOCardLayoutType:
        {
            UICollectionViewFlowLayout *cardLayout = [[KAOCardLayout alloc] initWithZoomIntensity:5.0];
            cardLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            cardLayout.minimumLineSpacing = 20 + 20;
            
            collectionView.collectionViewLayout = cardLayout;
            collectionView.pagingEnabled = YES;
        }
            break;
            
        case KAOFallingLayoutType:
        {
            UICollectionViewFlowLayout *fallingLayout = [[KAOFallingLayout alloc] init];
            fallingLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            fallingLayout.minimumLineSpacing = 20 + 20;
            
            collectionView.collectionViewLayout = fallingLayout;
            collectionView.pagingEnabled = YES;
        }
            break;
            
        default:
            break;
    }
}

@end
