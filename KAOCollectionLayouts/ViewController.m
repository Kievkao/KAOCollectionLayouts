//
//  ViewController.m
//  KAOCollectionLayouts
//
//  Created by Andrey Kravchenko on 8/17/15.
//  Copyright (c) 2015 Kievkao. All rights reserved.
//

#import "ViewController.h"
#import "KAOCardLayout.h"
#import "KAOPickerLayout.h"
#import "KAOPickerCell.h"
#import "KAOFallingLayout.h"
#import "KAOWaterfallLayout.h"
#import "KAOImageCell.h"

typedef enum : NSUInteger {
    KAOCardLayoutType,
    KAOPickerLayoutType,
    KAOFallingLayoutType,
    KAOWaterfallLayoutType
} KAOLayoutType;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  >

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGPoint contentOffset;

@property (nonatomic) KAOLayoutType currentLayoutType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentLayoutType = KAOWaterfallLayoutType;
    
    [self prepareCollectionView:self.collectionView forLayoutType:self.currentLayoutType];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForLayoutType:self.currentLayoutType indexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemSizeForLayoutType:self.currentLayoutType forIndexPath:indexPath];
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

- (CGSize)itemSizeForLayoutType:(KAOLayoutType)layoutType forIndexPath:(NSIndexPath *)indexPath {
    
    switch (layoutType) {
        case KAOCardLayoutType:
        case KAOFallingLayoutType:
            return CGRectInset(self.collectionView.frame, 20, 20).size;
            
        case KAOPickerLayoutType:
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame) - 40, 50);
            
        case KAOWaterfallLayoutType:
        {
            NSUInteger width = 50 + arc4random() %(250+1-50);
            NSUInteger height = 50 + arc4random() %(250+1-50);
            return CGSizeMake(width, height);
//            return CGSizeMake((indexPath.row + 1)*40, (indexPath.row + 1)*50);
        }
        default:
            return CGSizeZero;
    }
}

- (UICollectionViewCell *)cellForLayoutType:(KAOLayoutType)layoutType indexPath:(NSIndexPath *)indexPath {
    
    switch (layoutType) {
        case KAOCardLayoutType:
        case KAOFallingLayoutType:
            return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"KAODemoCell" forIndexPath:indexPath];
            
        case KAOPickerLayoutType:
            return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"KAOPickerCell" forIndexPath:indexPath];
            
        case KAOWaterfallLayoutType:
            return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"KAOImageCell" forIndexPath:indexPath];
            
        default:
            return nil;
    }
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
            KAOFallingLayout *fallingLayout = [[KAOFallingLayout alloc] init];
            fallingLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            fallingLayout.minimumLineSpacing = 20 + 20;
            fallingLayout.backwardFalling = NO;
            
            collectionView.collectionViewLayout = fallingLayout;
            collectionView.pagingEnabled = YES;
        }
            break;

            
        case KAOPickerLayoutType:
        {
            UICollectionViewFlowLayout *pickerLayout = [[KAOPickerLayout alloc] init];
            pickerLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            pickerLayout.minimumLineSpacing = 20 + 20;
            
            collectionView.collectionViewLayout = pickerLayout;
        }
            break;
            
        case KAOWaterfallLayoutType:
        {
            UICollectionViewLayout *pickerLayout = [[KAOWaterfallLayout alloc] init];
            collectionView.collectionViewLayout = pickerLayout;
        }
            break;
            
        default:
            break;
    }
}

@end
