//
//  CheckUpdateTool.m
//  CheckUpdate
//
//  Created by lihuanzhou on 2017/1/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CheckUpdateTool.h"

@implementation CheckUpdateTool

+(void)checkUpdateWithURL:(NSString *)url{
    [self requireWithURL:url];
}

+(CheckUpdateTool *)shared{
    static CheckUpdateTool *checkUpdateTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkUpdateTool = [[CheckUpdateTool alloc] init];
    });
    return checkUpdateTool;
}

+(void)requireWithURL:(NSString *)url{
    
    //需要传入3个参数，level为当前是release还是debug,version为当前的版本号,appid为Bundle Identifier
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *str = [NSString stringWithFormat:@"http://%@:8082/checkUpdate?level=%@&device=ios&version=%@&appid=com.bl.ios",url,XcodeLevel,localVersion];
    NSURL *requireUrl = [NSURL URLWithString:str];
    NSLog(@"%@",requireUrl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requireUrl];
    
    //这里是POST需要设置的
    //    request.HTTPMethod = @"POST";
    //    request.HTTPBody = [@"device=iOS&version=1.0.0&appId=125324324&level=release" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",data);
        if (data) {
            NSLog(@"success!");
            NSLog(@"%@",data);
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"=%@",jsonData);
            NSDictionary *paraData = [jsonData objectForKey:@"data"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[paraData valueForKey:@"status"] forKey:@"status"];
            [defaults setObject:[paraData valueForKey:@"title"] forKey:@"title"];
            [defaults setObject:[paraData valueForKey:@"msg"] forKey:@"msg"];
            [defaults setObject:[paraData valueForKey:@"url"] forKey:@"url"];
            [self receiveData];
        }else{
            NSLog(@"failed");
        }
    }];
    [dataTask resume];
    
    
}

+(void)receiveData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *status = [defaults objectForKey:@"status"];
    
    NSLog(@"%@",status);
    
    if ([status isEqualToString:@"0"]) {
        NSLog(@"Do Nothing");
    }else if([status isEqualToString:@"1"]){
        [self optionalUpdate];
    }else if ([status isEqualToString:@"2"]){
        [[self shared] forceUpdate];
    }
}

+(void)optionalUpdate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [defaults objectForKey:@"url"];
    NSString *title = [defaults objectForKey:@"title"];
    NSString *msg = [defaults objectForKey:@"msg"];
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"就是不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"????");
    }];
    
    [alertContr addAction:cancel];
    [alertContr addAction:update];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertContr animated:YES completion:nil];
}

-(void)forceUpdate{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceUpdate) name:UIApplicationWillEnterForegroundNotification object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"--%@",defaults);
    NSString *url = [defaults objectForKey:@"url"];
    NSString *title = [defaults objectForKey:@"title"];
    NSString *msg = [defaults objectForKey:@"msg"];
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"-%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        
    }];
    [alertContr addAction:update];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertContr animated:YES completion:nil];
    
}

@end
