//
//  ViewController.m
//  Container VC
//
//  Created by HL on 16/10/20.
//  Copyright © 2016年 HL. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FirstViewController *first = [[FirstViewController alloc] init];
    first.parentVC = self;
    [self displayContentVC:first];
}

- (void)displayContentVC:(UIViewController *)vc{
    [self addChildViewController:vc];
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
