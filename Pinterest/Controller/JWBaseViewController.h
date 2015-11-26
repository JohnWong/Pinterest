//
//  JWBaseViewController.h
//  Pinterest
//
//  Created by John Wong on 11/24/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWPinItem.h"

@protocol JWPinWaterFallCell <NSObject>

- (void)setItem:(JWPinItem *)item;

@end

@interface JWBaseViewController : UIViewController

- (Class<JWPinWaterFallCell>)cellClass;

@end
