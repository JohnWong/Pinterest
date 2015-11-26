//
//  JWADKViewController.m
//  Pinterest
//
//  Created by John Wong on 11/26/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWADKViewController.h"
#import "JWADKCollectionCell.h"

@implementation JWADKViewController

- (Class<JWPinWaterFallCell>)cellClass
{
    return [JWADKCollectionCell class];
}

@end
