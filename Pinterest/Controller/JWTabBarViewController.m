//
//  JWTabBarViewController.m
//  Pinterest
//
//  Created by John Wong on 11/25/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

#import "JWTabBarViewController.h"


@interface JWTabBarViewController ()

@end


@implementation JWTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 6;
    self.view.clipsToBounds = YES;

    self.tabBar.items[0].image = [[UIImage imageNamed:@"tab-bar-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBar.items[0].selectedImage = [[UIImage imageNamed:@"tab-bar-home-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBar.items[1].image = [[UIImage imageNamed:@"tab-bar-explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBar.items[1].selectedImage = [[UIImage imageNamed:@"tab-bar-explore-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
