//
//  ViewController.m
//  UCBMessage
//
//  Created by vmoksha mobility on 08/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "ViewController.h"
#import <UrbanAirship-iOS-SDK/AirshipLib.h>
#import "UAPush.h"
#import "UserInfo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"MessageListSegua" sender:self];
    });

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultChanged)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    [self updateTagsAndAlias];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userDefaultChanged
{
    [self performSelector:@selector(updateTagsAndAlias) withObject:nil afterDelay:1];
}

- (void)updateTagsAndAlias
{
    //When ever we update tags and alias nsuerdefault was also updating. so it was forming
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUserDefaultsDidChangeNotification
                                                  object:nil];
    
    [UAirship push].tags = [UserInfo sharedUserInfo].tags;
    [UAirship push].alias = [UserInfo sharedUserInfo].alias;
    [[UAirship push] updateRegistration];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultChanged)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}







@end
