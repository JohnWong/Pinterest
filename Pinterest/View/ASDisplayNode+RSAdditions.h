//
//  ASDisplayNode+RSAdditions.h
//  UIViewAdditions
//
//  Created by Josh Brown on 8/2/12.
//  Copyright (c) 2012 Roadfire Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncDisplayKit.h"


@interface ASDisplayNode (RSAdditions)

@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;

@property CGPoint center;
@property CGFloat centerX;
@property CGFloat centerY;

@property CGFloat height;
@property CGFloat width;

@property CGSize size;

@end
