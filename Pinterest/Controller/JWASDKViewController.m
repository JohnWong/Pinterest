//
//  JWASDKViewController.m
//  Pinterest
//
//  Created by John Wong on 11/26/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWASDKViewController.h"
#import "JWASDKCollectionCell.h"


@implementation JWASDKViewController


- (Class<JWPinWaterFallCell>)cellClass
{
    return [JWASDKCollectionCell class];
}

@end
