//
//  AppDelegate.m
//  UCBMessage
//
//  Created by vmoksha mobility on 08/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "AppDelegate.h"
#import <UrbanAirship-iOS-SDK/AirshipLib.h>
#import "MessageModel.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "PushHandler.h"
#import "InboxDelegate.h"




@interface AppDelegate ()<UAPushNotificationDelegate,UNUserNotificationCenterDelegate>
@property(nonatomic, strong) PushHandler *pushHandler;
@property(nonatomic, strong) InboxDelegate *inboxDelegate;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UAConfig *config = [UAConfig defaultConfig];
    [UAirship takeOff:config];

    NSString *channelID = [UAirship push].channelID;
    NSLog(@"My Application Channel ID: %@", channelID);
    
    [UAirship push].notificationOptions = (UANotificationOptionAlert |
                                           UANotificationOptionBadge |
                                           UANotificationOptionSound);
   
    [UAirship push].userPushNotificationsEnabled = YES;

    
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    // Set a custom delegate for handling message center events
    self.inboxDelegate = [[InboxDelegate alloc] initWithRootViewController:self.window.rootViewController];
    [UAirship inbox].delegate = self.inboxDelegate;
    
    self.pushHandler = [[PushHandler alloc] init];
    [UAirship push].pushNotificationDelegate = self.pushHandler;
    [UAirship push].registrationDelegate = self;

    
    // In App messaging Parameter
    
    [UAirship inAppMessaging].displayDelay = 10;
    [UAirship inAppMessaging].displayASAPEnabled = YES;
    [[UAirship inAppMessaging] displayPendingMessage];


    
   
    
    [[UAirship push] addTag:@"MyTag"];
    [[UAirship push] updateRegistration];
    
  
    
 
    
   
    
    
    
    
    
    
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
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UAAppIntegration application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [UAAppIntegration application:application didRegisterUserNotificationSettings:notificationSettings];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UAAppIntegration application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())handler {
    [UAAppIntegration application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:handler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())handler {
    [UAAppIntegration application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:handler];
}







// UNUserNotificationCenterDelegate methods

- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [UAAppIntegration userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];



}

- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
   
    [UAAppIntegration userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        //app is in foreground
        //the push is in your control
    } else {
        //app is in background:
        //iOS is responsible for displaying push alerts, banner etc..
    }
}




@end
