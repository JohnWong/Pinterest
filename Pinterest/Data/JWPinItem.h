//
//  JWPinItem.h
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

@interface JWPinner : NSObject

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *imageSmallUrl;
@property (nonatomic, strong) NSString *imageMediumUrl;
@property (nonatomic, strong) NSString *imageLargeUrl;

@end

@interface JWPinImage : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end

@interface JWPinItem : NSObject

@property (nonatomic, strong) JWPinImage *image;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger repinCount;
@property (nonatomic, strong) NSString *board;
@property (nonatomic, strong) JWPinner *pinner;
@property (nonatomic, assign) NSUInteger dominantColor;

/**
 *  Set width to item. Then you can get height and label height.
 */
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize labelSize;
@property (nonatomic, assign) CGSize imageSize;

+ (NSArray<JWPinItem *> *)loadSampleData;

@end
