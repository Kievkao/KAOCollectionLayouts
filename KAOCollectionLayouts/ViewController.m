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

typedef enum : NSUInteger {
    KAOCardLayoutType,
    KAOPickerLayoutType
} KAOLayoutType;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGPoint contentOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareCollectionView:self.collectionView forLayoutType:KAOPickerLayoutType];
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
    return [self itemSizeForLayoutType:KAOPickerLayoutType];
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

- (CGSize)itemSizeForLayoutType:(KAOLayoutType)layoutType {
    
    switch (layoutType) {
        case KAOCardLayoutType:
            return CGRectInset(self.collectionView.frame, 20, 20).size;
            
        case KAOPickerLayoutType:
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame) - 40, 50);
            
        default:
            return CGSizeZero;
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
            
        case KAOPickerLayoutType:
        {
            UICollectionViewFlowLayout *pickerLayout = [[KAOPickerLayout alloc] init];
            pickerLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            pickerLayout.minimumLineSpacing = 20 + 20;
            
            collectionView.collectionViewLayout = pickerLayout;
        }
            break;
            
        default:
            break;
    }
}

@end
