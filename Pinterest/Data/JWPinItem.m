//
//  JWPinItem.m
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWPinItem.h"


@implementation JWPinner

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.fullName = dict[@"full_name"];
        self.imageLargeUrl = dict[@"image_large_url"];
        self.imageMediumUrl = dict[@"image_medium_url"];
        self.imageSmallUrl = dict[@"image_small_url"];
    }
    return self;
}

@end


@implementation JWPinImage

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.url = dict[@"url"];
        self.width = [dict[@"width"] integerValue];
        self.height = [dict[@"height"] integerValue];
    }
    return self;
}

@end


@implementation JWPinItem

static CGFloat const minGap = 10;

+ (NSArray<JWPinItem *> *)loadSampleData
{
    NSURL *dataURL = [[NSBundle mainBundle] URLForResource:@"data" withExtension:@"txt"];
    NSData *data = [NSData dataWithContentsOfURL:dataURL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableArray *mutalbeArray = [NSMutableArray array];
    for (NSDictionary *item in dict[@"data"]) {
        [mutalbeArray addObject:[[self alloc] initWithDictionary:item]];
    }
    return [mutalbeArray copy];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _image = [[JWPinImage alloc] initWithDictionary:dict[@"images"][@"290x"]];
        _pid = dict[@"id"];
        _desc = [dict[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _repinCount = [dict[@"repin_count"] integerValue];
        _board = dict[@"board"][@"name"];
        _pinner = [[JWPinner alloc] initWithDictionary:dict[@"pinner"]];
        unsigned long long hexInt;
        [[NSScanner scannerWithString:[dict[@"dominant_color"] substringFromIndex:1]] scanHexLongLong:&hexInt];
        _dominantColor = hexInt;
    }
    return self;
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    if (_itemWidth != itemWidth) {
        _itemWidth = itemWidth;
        _itemSize = CGSizeZero;
        _labelSize = CGSizeZero;
        _imageSize = CGSizeZero;
    }
}

- (CGSize)imageSize
{
    NSAssert(_itemWidth != 0, @"width should not be 0");
    if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        _imageSize = CGSizeMake(_itemWidth, _itemWidth / _image.width * _image.height);
    }
    return _imageSize;
}

- (CGSize)labelSize
{
    NSAssert(_itemWidth != 0, @"width should not be 0");
    if (CGSizeEqualToSize(_labelSize, CGSizeZero)) {
        if (_desc.length == 0) {
            _labelSize = CGSizeZero;
        } else {
            _labelSize = CGSizeMake(_itemWidth - 2 * minGap, CGFLOAT_MAX);
            _labelSize = [_desc boundingRectWithSize:_labelSize
                                             options:kNilOptions
                                          attributes:@{
                                              NSFontAttributeName : [UIFont systemFontOfSize:9]
                                          }
                                             context:nil]
                             .size;
        }
    }
    return _labelSize;
}

- (CGSize)itemSize
{
    NSAssert(_itemWidth != 0, @"width should not be 0");
    CGFloat middle = 0;
    if (_desc.length > 0) {
        middle += self.labelSize.height + minGap;
    }
    if (_repinCount) {
        middle += 12 + minGap;
    }
    CGFloat top = self.imageSize.height + (middle > 0 ? middle + minGap : 0);
    top += 44;
    return CGSizeMake(_itemWidth, top);
}

@end
