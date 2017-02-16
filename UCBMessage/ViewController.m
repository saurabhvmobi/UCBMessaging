//
//  ViewController.m
//  UCBMessage
//
//  Created by vmoksha mobility on 08/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "ViewController.h"
#import <UrbanAirship-iOS-SDK/AirshipLib.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    [self performSegueWithIdentifier:@"MessageListSegua" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
