//
//  M8RegistSuccViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RegistSuccViewController.h"

@interface M8RegistSuccViewController ()

@property (weak, nonatomic) IBOutlet UITextField *psdFirstTF;
@property (weak, nonatomic) IBOutlet UITextField *psdSecondTF;

@end

@implementation M8RegistSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
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
- (IBAction)onVerifyAction:(id)sender {
    
}

@end
