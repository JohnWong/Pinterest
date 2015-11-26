//
//  JWASDKCollectionCell.m
//  Pinterest
//
//  Created by John Wong on 11/26/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWASDKCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "AsyncDisplayKit.h"
#import "ASDisplayNode+RSAdditions.h"
#import "WebASDKImageManager.h"

static CGFloat const minGap = 10;


@interface JWASDKImageView : ASDisplayNode

@property (nonatomic, strong) ASNetworkImageNode *imageView;

@end


@implementation JWASDKImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.layerBacked = YES;
        [self setFrame:frame];
        _imageView = [[ASNetworkImageNode alloc] initWithWebImage];
        _imageView.layerBacked = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubnode:_imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView.frame = frame;
}

@end


@interface JWASDKDescriptionView : ASDisplayNode

@property (nonatomic, strong) ASTextNode *descLabel;

@end


@implementation JWASDKDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.layerBacked = YES;
        [self setFrame:frame];
        _descLabel = [[ASTextNode alloc] init];
        _descLabel.layerBacked = YES;
        [self addSubnode:_descLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect labelFrame = frame;
    labelFrame.origin.x += minGap;
    labelFrame.origin.y = 0;
    labelFrame.size.width -= minGap * 2;
    _descLabel.frame = labelFrame;
}

@end


@interface JWASDKCountsView : ASDisplayNode

@property (nonatomic, strong) ASImageNode *repinImageView;
@property (nonatomic, strong) ASTextNode *repinLabel;

- (void)setRepinCount:(NSInteger)count;

@end


@implementation JWASDKCountsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.layerBacked = YES;
        [self setFrame:frame];
        _repinImageView = [[ASImageNode alloc] init];
        _repinImageView.layerBacked = YES;
        _repinImageView.image = [UIImage imageNamed:@"closeup-repins-icon"];
        _repinImageView.size = _repinImageView.image.size;
        _repinImageView.left = minGap;
        [self addSubnode:_repinImageView];

        _repinLabel = [[ASTextNode alloc] init];
        _repinLabel.layerBacked = YES;
        _repinLabel.frame = CGRectMake(_repinImageView.right + 2, 0, 0, 12);
        [self addSubnode:_repinLabel];
    }
    return self;
}

- (void)setRepinCount:(NSInteger)count
{
    _repinLabel.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(count)]
                                                                   attributes:@{
                                                                       NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                                                                       NSForegroundColorAttributeName : HEXCOLOR(0xB9B9B9)
                                                                   }];
    _repinLabel.frame = (CGRect){CGPointMake(_repinImageView.right + 2, 0), [_repinLabel measure:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]};
}

@end


@interface JWASDKnerView : ASDisplayNode

@property (nonatomic, strong) ASNetworkImageNode *pinnerImage;
@property (nonatomic, strong) ASTextNode *pinnerName;
@property (nonatomic, strong) ASTextNode *pick;
@property (nonatomic, strong) ASDisplayNode *seperator;

@end


@implementation JWASDKnerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.layerBacked = YES;
        [self setFrame:frame];
        _seperator = [[ASDisplayNode alloc] init];
        _seperator.layerBacked = YES;
        _seperator.frame = CGRectMake(0, 0, frame.size.width, kOnePix);
        _seperator.backgroundColor = HEXCOLOR(0xe0e1e2);
        [self addSubnode:_seperator];

        _pinnerImage = [[ASNetworkImageNode alloc] initWithWebImage];
        _pinnerImage.layerBacked = YES;
        _pinnerImage.frame = CGRectMake(minGap, minGap, 24, 24);
        _pinnerImage.layer.cornerRadius = 2;
        _pinnerImage.clipsToBounds = YES;
        _pinnerImage.backgroundColor = [UIColor lightGrayColor];
        [self addSubnode:_pinnerImage];

        _pick = [[ASTextNode alloc] init];
        _pick.layerBacked = YES;
        _pick.frame = CGRectMake(_pinnerImage.right + 5, _pinnerImage.top, self.width - _pinnerImage.right - minGap, 12);
        _pick.attributedString = [[NSAttributedString alloc] initWithString:@"Picked for your"
                                                                 attributes:@{
                                                                     NSFontAttributeName : [UIFont systemFontOfSize:9],
                                                                     NSForegroundColorAttributeName : [UIColor blackColor]
                                                                 }];
        [self addSubnode:_pick];

        _pinnerName = [[ASTextNode alloc] init];
        _pinnerName.layerBacked = YES;
        _pinnerName.frame = CGRectMake(_pick.left, _pick.bottom, _pick.width, 12);
        [self addSubnode:_pinnerName];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _seperator.width = frame.size.width;
    _pick.width = frame.size.width - _pinnerImage.right - 5 - minGap;
    _pinnerName.width = _pick.width;
}

@end


@implementation JWASDKCollectionCell {
    JWASDKImageView *_imageView;
    JWASDKDescriptionView *_descView;
    JWASDKCountsView *_countView;
    JWASDKnerView *_pinnerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.borderColor = HEXCOLOR(0x979899).CGColor;
        self.layer.borderWidth = kOnePix;
        self.clipsToBounds = YES;

        _imageView = [[JWASDKImageView alloc] initWithFrame:CGRectZero];
        [self addSubnode:_imageView];

        _descView = [[JWASDKDescriptionView alloc] initWithFrame:CGRectZero];
        [self addSubnode:_descView];

        _countView = [[JWASDKCountsView alloc] initWithFrame:CGRectZero];
        [self addSubnode:_countView];

        _pinnerView = [[JWASDKnerView alloc] initWithFrame:CGRectMake(minGap, minGap, self.width - minGap * 2, 24)];
        [self addSubnode:_pinnerView];
    }
    return self;
}

- (void)setItem:(JWPinItem *)item
{
    _imageView.frame = (CGRect){CGPointZero, item.imageSize};
    _imageView.backgroundColor = HEXCOLOR(item.dominantColor);
    [_imageView.imageView setURL:[NSURL URLWithString:item.image.url]];

    CGFloat top = _imageView.bottom + minGap;

    if (item.desc.length > 0) {
        _descView.hidden = NO;
        CGRect frame = CGRectMake(0, top, item.itemWidth, item.labelSize.height);
        _descView.frame = frame;
        _descView.descLabel.attributedString = [[NSAttributedString alloc] initWithString:item.desc
                                                                               attributes:@{
                                                                                   NSFontAttributeName : [UIFont systemFontOfSize:9],
                                                                                   NSForegroundColorAttributeName : [UIColor blackColor]
                                                                               }];
        top += _descView.height + minGap;
    } else {
        _descView.hidden = YES;
    }

    if (item.repinCount) {
        _countView.frame = CGRectMake(0, top, item.itemWidth, 12);
        [_countView setRepinCount:item.repinCount];
        _countView.hidden = NO;
        top += _countView.height + minGap;
    } else {
        _countView.hidden = YES;
    }

    if (top == _imageView.bottom + minGap) {
        top = _imageView.bottom;
    }
    _pinnerView.frame = CGRectMake(0, top, item.itemWidth, 44);
    [_pinnerView.pinnerImage setURL:[NSURL URLWithString:item.pinner.imageLargeUrl]];

    _pinnerView.pinnerName.attributedString = [[NSAttributedString alloc] initWithString:item.pinner.fullName
                                                                              attributes:@{
                                                                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:9],
                                                                                  NSForegroundColorAttributeName : [UIColor blackColor]
                                                                              }];
}


@end
