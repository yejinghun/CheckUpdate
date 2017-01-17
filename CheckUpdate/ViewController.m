//
//  ViewController.m
//  CheckUpdate
//
//  Created by lihuanzhou on 2017/1/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "CheckUpdateTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //输入服务器地址
    [CheckUpdateTool checkUpdateWithURL:@"xxx"];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
