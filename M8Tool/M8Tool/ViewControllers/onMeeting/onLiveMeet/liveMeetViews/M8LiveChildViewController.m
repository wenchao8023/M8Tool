//
//  M8LiveChildViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveChildViewController.h"
#import "M8LiveContentScroll.h"

@interface M8LiveChildViewController ()

@property (nonatomic, assign) CGRect    selfFrame;
@property (nonatomic, assign) CGFloat   selfWidth;
@property (nonatomic, assign) CGFloat   selfHeight;

@property (strong, nonatomic) M8LiveContentScroll *contentScroll;


@end

@implementation M8LiveChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selfFrame  = self.view.frame;
    _selfWidth  = self.view.frame.size.width;
    _selfHeight = self.view.frame.size.height;
    
    [self contentScroll];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    WCLog(@"livc child did move to parent vc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (M8LiveContentScroll *)contentScroll {
    if (!_contentScroll) {
        M8LiveContentScroll *contentScroll = [[M8LiveContentScroll alloc] initWithFrame:_selfFrame];
        [self.view addSubview:(_contentScroll = contentScroll)];
    }
    return _contentScroll;
}


- (void)updateFrameWithOffsetY:(CGFloat)offsetY {
    self.view.y = offsetY;
}

@end
