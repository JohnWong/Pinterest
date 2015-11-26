//
//  JWPinCollectionCell.m
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWPinCollectionCell.h"
#import "UIImageView+WebCache.h"

static CGFloat const minGap = 10;


@interface JWPinImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation JWPinImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView.frame = frame;
}

@end


@interface JWPinDescriptionView : UIView

@property (nonatomic, strong) UILabel *descLabel;

@end


@implementation JWPinDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:9];
        _descLabel.textColor = [UIColor blackColor];
        [self addSubview:_descLabel];
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


@interface JWPinCountsView : UIView

@property (nonatomic, strong) UIImageView *repinImageView;
@property (nonatomic, strong) UILabel *repinLabel;

- (void)setRepinCount:(NSInteger)count;

@end


@implementation JWPinCountsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _repinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closeup-repins-icon"]];
        _repinImageView.left = minGap;
        [self addSubview:_repinImageView];

        _repinLabel = [[UILabel alloc] initWithFrame:CGRectMake(_repinImageView.right + 2, 0, 0, 12)];
        _repinLabel.textColor = HEXCOLOR(0xB9B9B9);
        _repinLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_repinLabel];
    }
    return self;
}

- (void)setRepinCount:(NSInteger)count
{
    _repinLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    [_repinLabel sizeToFit];
}

@end


@interface JWPinnerView : UIView

@property (nonatomic, strong) UIImageView *pinnerImage;
@property (nonatomic, strong) UILabel *pinnerName;
@property (nonatomic, strong) UILabel *pick;
@property (nonatomic, strong) UIView *seperator;

@end


@implementation JWPinnerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kOnePix)];
        _seperator.backgroundColor = HEXCOLOR(0xe0e1e2);
        [self addSubview:_seperator];

        _pinnerImage = [[UIImageView alloc] initWithFrame:CGRectMake(minGap, minGap, 24, 24)];
        _pinnerImage.layer.cornerRadius = 2;
        _pinnerImage.clipsToBounds = YES;
        _pinnerImage.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_pinnerImage];

        _pick = [[UILabel alloc] initWithFrame:CGRectMake(_pinnerImage.right + 5, _pinnerImage.top, self.width - _pinnerImage.right - minGap, 12)];
        _pick.font = [UIFont systemFontOfSize:9];
        _pick.textColor = [UIColor blackColor];
        _pick.text = @"Picked for your";
        [self addSubview:_pick];

        _pinnerName = [[UILabel alloc] initWithFrame:CGRectMake(_pick.left, _pick.bottom, _pick.width, 12)];
        _pinnerName.font = [UIFont boldSystemFontOfSize:9];
        _pinnerName.textColor = [UIColor blackColor];
        [self addSubview:_pinnerName];
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


@implementation JWPinCollectionCell {
    JWPinImageView *_imageView;
    JWPinDescriptionView *_descView;
    JWPinCountsView *_countView;
    JWPinnerView *_pinnerView;
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

        _imageView = [[JWPinImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];

        _descView = [[JWPinDescriptionView alloc] initWithFrame:CGRectZero];
        [self addSubview:_descView];

        _countView = [[JWPinCountsView alloc] initWithFrame:CGRectZero];
        [self addSubview:_countView];

        _pinnerView = [[JWPinnerView alloc] initWithFrame:CGRectMake(minGap, minGap, self.width - minGap * 2, 24)];
        [self addSubview:_pinnerView];
    }
    return self;
}

- (void)setItem:(JWPinItem *)item
{
    _imageView.frame = (CGRect){CGPointZero, item.imageSize};
    _imageView.backgroundColor = HEXCOLOR(item.dominantColor);
    [_imageView.imageView sd_setImageWithURL:[NSURL URLWithString:item.image.url]];

    CGFloat top = _imageView.bottom + minGap;

    if (item.desc.length > 0) {
        _descView.hidden = NO;
        CGRect frame = CGRectMake(0, top, item.itemWidth, item.labelSize.height);
        _descView.frame = frame;
        _descView.descLabel.text = item.desc;
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
    [_pinnerView.pinnerImage sd_setImageWithURL:[NSURL URLWithString:item.pinner.imageLargeUrl]];
    _pinnerView.pinnerName.text = item.pinner.fullName;
}


@end
