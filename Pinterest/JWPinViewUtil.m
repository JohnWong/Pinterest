//
//  JWPinViewUtil.m
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWPinViewUtil.h"

@implementation JWPinViewUtil

+ (CGFloat)screenWidth
{
    static CGFloat _screenWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    });
    return _screenWidth;
}

+ (CGFloat)screenHeight
{
    static CGFloat _screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    });
    return _screenHeight;
}

@end
