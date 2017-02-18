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
#import "SeedSync.h"
#import <AFNetworking/AFNetworking.h>
#import "NewsCategoryFetcher.h"
@interface ViewController ()<SeedSyncDelegate>

@end

@implementation ViewController
{

    SeedSync *seedSyncer;
    NewsCategoryFetcher *categoryFetcher;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
   
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self performSegueWithIdentifier:@"MessageListSegua" sender:self];
//    });
//
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultChanged)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    [self updateTagsAndAlias];
    
    BOOL updatedSyncID = [[NSUserDefaults standardUserDefaults] boolForKey:@"updatedSyncID"];
    if (!updatedSyncID)
    {
        if (categoryFetcher == nil)
        {
            categoryFetcher = [[NewsCategoryFetcher alloc] init];
        }
        
        [categoryFetcher getLatestNewsIDWithCompletionner:^(BOOL success, NSInteger latestID) {
            if (success)
            {
                NSInteger currentID = [[NSUserDefaults standardUserDefaults] integerForKey:@"SinceID"];
                if (currentID == 0)
                {
                    [[NSUserDefaults standardUserDefaults] setInteger:latestID forKey:@"SinceID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"updatedSyncID"];
            }
        }];
    }



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(checkRechability) withObject:nil afterDelay:1];
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


- (void)checkRechability
{
//    if ([AFNetworkReachabilityManager sharedManager].isReachable)
//    {
//        if (seedSyncer == nil)
//        {
//            seedSyncer = [[SeedSync alloc] init];
//            seedSyncer.delegate = self;
//        }
//        
//        [seedSyncer initiateSeedAPI];
//        NSLog(@"Rechable");
//    }
//    else
//    {
//        NSLog(@"Not rechable");
//       // [langChanger readLanguageFileFromDocumentDirectory:NO];
//        [self performSegueWithIdentifier:@"MessageListSegua" sender:nil];
//    }
//

    if (seedSyncer == nil)
    {
        seedSyncer = [[SeedSync alloc] init];
        seedSyncer.delegate = self;
    }
    
    [seedSyncer initiateSeedAPI];




}

#pragma mark
#pragma mark SeedSyncDelegate
- (void)seedSyncFinishedSuccessful:(SeedSync *)seedSync
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"news"])
    {
        NSInteger sinceID = [[NSUserDefaults standardUserDefaults]integerForKey:@"SinceID"];
        //        sinceID = 1;
        if (sinceID > 0)
        {
            categoryFetcher = [[NewsCategoryFetcher alloc] init];
            [categoryFetcher initiateNewsCategoryAPIFor:sinceID
                                 fetchCompletionHandler:nil
                                      andDownloadImages:YES];
        }
    }
   
    [self performSegueWithIdentifier:@"MessageListSegua" sender:nil];

    
//    NSString *langCode =  [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguageCode"];
//    NSString *seedKeyForLang = [NSString stringWithFormat:@"uilabel,%@", langCode];
//    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:seedKeyForLang])
//    {
//      //  [langChanger changeLanguageWithCode:langCode];
//    }else
//    {
//        //[langChanger readLanguageFileFromDocumentDirectory:NO];
//        // [self performSegueWithIdentifier:@"SplashToLoginVC_Segue" sender:nil];
//    }
    
 
}

-(void)successResponseDelegateMethod
{
    [self performSegueWithIdentifier:@"MessageListSegua" sender:nil];
    
    
}

-(void)failourResponseDelegateMethod
{
    [self performSegueWithIdentifier:@"MessageListSegua" sender:nil];
  
}

- (void)seedSyncFinishedWithFailure:(SeedSync *)seedSync
{
   // [langChanger readLanguageFileFromDocumentDirectory:NO];
    [self performSegueWithIdentifier:@"MessageListSegua" sender:nil];
}




@end
