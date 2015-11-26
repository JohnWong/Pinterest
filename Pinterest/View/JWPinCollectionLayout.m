//
//  JWPinCollectionLayout.m
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWPinCollectionLayout.h"


@interface JWPinCollectionLayout ()

@property (nonatomic, weak) id<JWPinCollectionViewDelegateWaterfallLayout> delegate;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;

@end


@implementation JWPinCollectionLayout

static CGFloat JWPinFloorCGFloat(CGFloat value)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _columnCount = 2;
        _minimumSpacing = 10;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self.allItemAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    [self.columnHeights removeAllObjects];


    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return;
    }

    for (int section = 0; section < numberOfSections; section++) {
        NSInteger columnCount = [self columnCountForSection:section];
        NSMutableArray *sectionColumnHeights = [NSMutableArray arrayWithCapacity:columnCount];
        for (int idx = 0; idx < columnCount; idx++) {
            [sectionColumnHeights addObject:@(0)];
        }
        [self.columnHeights addObject:sectionColumnHeights];
    }

    UICollectionViewLayoutAttributes *attributes;
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        NSInteger columnCount = [self columnCountForSection:section];
        CGFloat width = self.collectionView.bounds.size.width;
        CGFloat itemWidth = JWPinFloorCGFloat((width - (columnCount + 1) * self.minimumSpacing) / columnCount);

        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];

        for (int idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            NSUInteger columnIndex = [self nextColumnIndexForItem:idx inSection:section];
            CGFloat xOffset = self.minimumSpacing + (itemWidth + self.minimumSpacing) * columnIndex;
            CGFloat yOffset = MAX([self.columnHeights[section][columnIndex] floatValue], self.minimumSpacing);
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath withWidth:itemWidth];
            CGFloat itemHeight = 0;
            if (itemSize.height > 0 && itemSize.width > 0) {
                itemHeight = JWPinFloorCGFloat(itemSize.height * itemWidth / itemSize.width);
            }

            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            self.columnHeights[section][columnIndex] = @(CGRectGetMaxY(attributes.frame) + self.minimumSpacing);
        }
        [self.sectionItemAttributes addObject:itemAttributes];
    }
}

- (NSInteger)columnCountForSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self columnCountForSection:section];
    } else {
        return self.columnCount;
    }
}

- (NSUInteger)nextColumnIndexForItem:(NSInteger)item inSection:(NSInteger)section
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;

    [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];

    return index;
}

- (CGSize)collectionViewContentSize
{
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }

    CGSize contentSize = self.collectionView.bounds.size;
    CGFloat max = 0;
    for (NSNumber *value in self.columnHeights.lastObject) {
        max = fmax(max, [value floatValue]);
    }
    contentSize.height = max;
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attrs = [NSMutableArray array];

    for (int i = 0; i < self.allItemAttributes.count; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }

    return [NSArray arrayWithArray:attrs];
}

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)allItemAttributes
{
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes
{
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (void)setColumnCount:(NSInteger)columnCount
{
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setMinimumSpacing:(CGFloat)minimumSpacing
{
    if (_minimumSpacing != minimumSpacing) {
        _minimumSpacing = minimumSpacing;
        [self invalidateLayout];
    }
}

- (id<JWPinCollectionViewDelegateWaterfallLayout>)delegate
{
    return (id<JWPinCollectionViewDelegateWaterfallLayout>)self.collectionView.delegate;
}

@end
