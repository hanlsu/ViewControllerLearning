//
//  FirstViewController.m
//  Container VC
//
//  Created by HL on 16/10/20.
//  Copyright © 2016年 HL. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
@interface FirstViewController ()
@property (nonatomic) SecondViewController *secondVC;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.secondVC = [[SecondViewController alloc] init];
}
- (IBAction)btnClick:(id)sender {
    
    [self transitiongFromViewController:self toViewController:self.secondVC];
}
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
- (void)transitiongFromViewController:(UIViewController *)oldVC toViewController:(UIViewController *)newVC{
    [oldVC willMoveToParentViewController:nil];
    [self.parentVC addChildViewController:newVC];
    
    newVC.view.frame = CGRectMake(-kScreenW, 0, kScreenW, kScreenH - 20);
    CGRect endFrame = CGRectMake(kScreenW, 100, kScreenW, kScreenH - 200);
    
    [self.parentVC transitionFromViewController:oldVC toViewController:newVC duration:0.5 options:0 animations:^{
        newVC.view.frame = oldVC.view.frame;
        oldVC.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [oldVC removeFromParentViewController];
        [newVC didMoveToParentViewController:self.parentVC];
    }];
}

- (void)didReceiveMemoryWarning {
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
