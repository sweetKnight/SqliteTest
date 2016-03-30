//
//  ViewController.m
//  SqliteTest
//
//  Created by 冯剑锋 on 16/3/30.
//  Copyright © 2016年 冯剑锋. All rights reserved.
//

#import "ViewController.h"
#import "SqiltBLL.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SqiltBLL * bll = [SqiltBLL shareSqiltBll];
    
    [bll creatTableWithTableName:@"PERSONINFO" AndDictionary:@{@"name":@"TEXT",@"age":@"TEXT",@"address":@"TEXT"}];
    
    [bll insertOneModel:@{@"name":@"张三",@"age":@(125),@"address":@"西城区"}];
    
    NSArray * array = [bll findAllData];
    NSLog(@"%@",array);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
