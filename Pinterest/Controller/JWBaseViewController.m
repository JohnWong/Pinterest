//
//  JWBaseViewController.m
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWBaseViewController.h"
#import "JWPinCollectionLayout.h"
#import "JWPinViewUtil.h"
#import "YYFPSLabel.h"


@interface JWBaseViewController () <UICollectionViewDataSource, JWPinCollectionViewDelegateWaterfallLayout>

@end

static NSString *const kJWReuseIdentifier = @"Pin";


@implementation JWBaseViewController {
    UICollectionView *_collectionView;
    UIRefreshControl *_refreshControl;
    NSArray<JWPinItem *> *_data;
    UIView *_topBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    _topBar.backgroundColor = HEXCOLOR(0xE7E7E7);
    [self.view addSubview:_topBar];
    
    _data = [JWPinItem loadSampleData];
    
    CGRect frame = self.view.bounds;
    frame.origin.y += _topBar.height;
    frame.size.height -= _topBar.height;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[[JWPinCollectionLayout alloc] init]];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.backgroundColor = HEXCOLOR(0xE7E7E7);
    [_collectionView registerClass:[self cellClass] forCellWithReuseIdentifier:kJWReuseIdentifier];
    [self.view addSubview:_collectionView];
    [_collectionView reloadData];

    _refreshControl = [[UIRefreshControl alloc] init];
    [_collectionView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:[[YYFPSLabel alloc] initWithFrame:CGRectMake(16, self.view.height - 30 - self.tabBarController.tabBar.height, 0, 0)]];
}

- (Class<JWPinWaterFallCell>)cellClass
{
    NSAssert(NO, @"Must be override by sub class");
    return nil;
}

- (void)reload
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
        [_refreshControl endRefreshing];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWPinItem *item = _data[indexPath.row];
    UICollectionViewCell<JWPinWaterFallCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJWReuseIdentifier forIndexPath:indexPath];
    [cell setItem:item];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath withWidth:(CGFloat)width
{
    JWPinItem *item = _data[indexPath.row];
    item.itemWidth = width;
    return item.itemSize;
}

@end
