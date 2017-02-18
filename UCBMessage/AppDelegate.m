//
//  AppDelegate.m
//  UCBMessage
//
//  Created by vmoksha mobility on 08/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "AppDelegate.h"
#import <UrbanAirship-iOS-SDK/AirshipLib.h>
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "SeedSync.h"
#import "NewsCategoryFetcher.h"


@interface AppDelegate ()<UAPushNotificationDelegate,UNUserNotificationCenterDelegate>

{

    BOOL callSeedAPI;
    SeedSync *seedSyncer;
    NewsCategoryFetcher *categoryFetcher;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    callSeedAPI = NO;
    UAConfig *config = [UAConfig defaultConfig];
    [UAirship takeOff:config];

    NSString *channelID = [UAirship push].channelID;
    NSLog(@"My Application Channel ID: %@", channelID);
    
    [UAirship push].notificationOptions = (UANotificationOptionAlert |
                                           UANotificationOptionBadge |
                                           UANotificationOptionSound);
   
    [UAirship push].userPushNotificationsEnabled = YES;

    [[UAirship defaultMessageCenter] display];

    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    // Set a custom delegate for handling message center events
   

    
    // In App messaging Parameter
    
    [UAirship inAppMessaging].displayDelay = 10;
    [UAirship inAppMessaging].displayASAPEnabled = YES;
    //[[UAirship inAppMessaging] displayPendingMessage];
   
    [[UAirship defaultMessageCenter] display];


    
  
    
    [[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"SelectedLanguageCode"];
    
   
    
    
    
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                           NSFontAttributeName : [UIFont fontWithName:@"MuseoSans-700" size:20]}];
//    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                           NSFontAttributeName : [UIFont fontWithName:@"MuseoSans-700" size:16]}
//                                                forState:(UIControlStateNormal)];
//    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
    //tab bar colour
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.588 green:.729 blue:.223 alpha:1]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.13 green:.31 blue:.46 alpha:1]];
    
  
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    if ([UAirship inbox].messageList.unreadCount >= 0) {
        application.applicationIconBadgeNumber = [UAirship inbox].messageList.unreadCount;
    }

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    if (callSeedAPI)
    {
        if (seedSyncer == nil)
        {
            seedSyncer = [[SeedSync alloc] init];
            seedSyncer.delegate = self;
        }
        
        [seedSyncer initiateSeedAPI];
    }else
    {
        callSeedAPI = YES;
    }



}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

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

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    UA_LINFO(@"Received remote notification (in appDelegate): %@", userInfo);
    
    [self gotNotificatonWithUserInfo:userInfo fetchCompletionHandler:completionHandler];
    
    if (application.applicationState != UIApplicationStateBackground)
    {
        [[UAirship push] resetBadge];
    }
}

- (void)gotNotificatonWithUserInfo:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([userInfo[@"func"] isEqualToString:@"News"])
    {
        NSInteger currentSinceID = [[NSUserDefaults standardUserDefaults]integerForKey:@"SinceID"];
        if (currentSinceID == 0)
        {
            currentSinceID = [userInfo[@"id"] integerValue] - 1;
            
            //            //For the very first time (server itself is fresh) 'id' in the push notification will be '1'. So 'sinceId' created will be ZERO. For sinceID = ZERO, server wont give in response. So we have to check for that condition and we need to Call API with 'sinceID= ""'.
            //            if (currentSinceID == 0)
            //            {
            //                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RecivedVeryFirstNews"];
            //            }
        }
        [self getNewsCategoryFor:currentSinceID fetchCompletionHandler:completionHandler];
    }else
    {
        [self getNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)getNewsCategoryFor:(NSInteger)sinceID fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (!self.fetcher)
    {
        self.fetcher = [[NewsCategoryFetcher alloc] init];
    }
    
    [self.fetcher initiateNewsCategoryAPIFor:sinceID fetchCompletionHandler:completionHandler andDownloadImages:YES];
}

- (void)getNotification:(NSDictionary *)appInfo
{
    NSString *alert = appInfo[@"aps"][@"alert"];
    
    UIAlertView *alertForNotification =  [[UIAlertView alloc] initWithTitle:@"Notification" message:alert delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertForNotification show];
    
}







@end
