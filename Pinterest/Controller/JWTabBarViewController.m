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
