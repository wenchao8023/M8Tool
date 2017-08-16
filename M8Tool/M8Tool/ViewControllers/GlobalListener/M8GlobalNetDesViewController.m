//
//  M8GlobalNetDesViewController.m
//  M8Tool
//
//  Created by chao on 2017/8/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalNetDesViewController.h"

@interface M8GlobalNetDesViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation M8GlobalNetDesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"网络连接异常"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.bgImageView.hidden = YES;
    self.contentView.hidden = YES;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"netUnableReachable" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:request];
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kDefaultNaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kDefaultNaviHeight)];
        [self.view addSubview:(_webView = webView)];
    }
    return _webView;
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
