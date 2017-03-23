//
//  JJBaseTableViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseTableViewController.h"

@interface JJBaseTableViewController ()

@end

@implementation JJBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JJHud dismiss];
}



@end
