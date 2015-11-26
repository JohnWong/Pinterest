//
//  JWPinViewController.m
//  Pinterest
//
//  Created by John Wong on 11/26/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWPinViewController.h"
#import "JWPinCollectionCell.h"


@implementation JWPinViewController

- (Class<JWPinWaterFallCell>)cellClass
{
    return [JWPinCollectionCell class];
}

@end
