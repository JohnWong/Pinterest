//
//  FirstViewController.m
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "FirstViewController.h"
#import "JWPinItem.h"
#import "JWPinCollectionCell.h"
#import "JWPinCollectionLayout.h"
#import "JWPinViewUtil.h"


@interface FirstViewController () <UICollectionViewDataSource, JWPinCollectionViewDelegateWaterfallLayout>

@end

static NSString *const kJWReuseIdentifier = @"Pin";


@implementation FirstViewController {
    UICollectionView *_collectionView;
    UIRefreshControl *_refreshControl;
    NSArray<JWPinItem *> *_data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    _data = [JWPinItem loadSampleData];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[JWPinCollectionLayout alloc] init]];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.backgroundColor = HEXCOLOR(0xE7E7E7);
    [_collectionView registerClass:[JWPinCollectionCell class] forCellWithReuseIdentifier:kJWReuseIdentifier];
    [self.view addSubview:_collectionView];
    [_collectionView reloadData];

    _refreshControl = [[UIRefreshControl alloc] init];
    [_collectionView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLayoutSubviews
{
    CGRect frame = self.view.frame;
    if (frame.origin.y != 20) {
        frame.origin.y += 20;
        frame.size.height -= 20;
        self.view.frame = frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    JWPinCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJWReuseIdentifier forIndexPath:indexPath];
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
