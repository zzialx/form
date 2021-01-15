//
//  MianRootViewController.m
//  FormExampleDemo
//
//  Created by mwj on 2020/12/29.
//  Copyright © 2020 lx. All rights reserved.
//

#import "MianRootViewController.h"
#import "LeftViewController.h"
#import "ViewController.h"

@interface MianRootViewController ()<UISplitViewControllerDelegate>


@end

@implementation MianRootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //设置两个装有tableView的导航控制器作为左右视图
    LeftViewController *left=[[LeftViewController alloc]init];
    UINavigationController *leftNav=[[UINavigationController alloc]initWithRootViewController:left];
    
    ViewController *right=[[ViewController alloc]init];
    UINavigationController *rightNav=[[UINavigationController alloc]initWithRootViewController:right];
    self.viewControllers=[NSArray arrayWithObjects:leftNav,rightNav, nil];
    
    self.delegate = right;
}
//支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
    
}
- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode NS_AVAILABLE_IOS(8_0){
    
}
//显示或者隐藏一般都是针对左边的那个菜单式的视图
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    //按钮点击事件官方已经封装
    self.navigationItem.leftBarButtonItem=nil;
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title=@"班级";
    self.navigationItem.leftBarButtonItem=barButtonItem;
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
