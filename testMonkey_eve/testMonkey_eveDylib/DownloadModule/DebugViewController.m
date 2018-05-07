//
//  DebugViewController.m
//  TogetherHomeworkDylib
//
//  Created by john on 2018/4/23.
//  Copyright © 2018 john. All rights reserved.
//

#import "DebugViewController.h"
#import "DebugCenter.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.text = @"这是个调试view";
    
    [textLabel sizeToFit];
    
    textLabel.center = self.view.center;
    [self.view addSubview:textLabel];
    
    UIButton *hiddenCenter = [[UIButton alloc] init];
    [hiddenCenter addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:hiddenCenter];
    
    hiddenCenter.frame = CGRectOffset(textLabel.frame, 0, textLabel.frame.size.height + 20);
    
    [hiddenCenter setTitle:@"hidden" forState:UIControlStateNormal];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)hidden {
    
    [[DebugCenter sharedInstance] hiddenDebugCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}
- (IBAction)hiddenDebug:(id)sender {
    
    [[DebugCenter sharedInstance] hiddenDebugCenter];
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
