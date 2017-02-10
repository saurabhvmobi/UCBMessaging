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




@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UAirship takeOff];
    
    [UAirship push].userPushNotificationsEnabled = YES;

    [UNUserNotificationCenter currentNotificationCenter].delegate = self;

    [[UAirship push] addTag:@"MyTag"];
    [[UAirship push] updateRegistration];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
   
    // Define an action for the category
    UANotificationAction *categoryAction = [UANotificationAction actionWithIdentifier: @"category_action"
                                                                                title:@"Action!"
                                                                              options:(UNNotificationActionOptionForeground |
                                                                                       UNNotificationActionOptionDestructive |
                                                                                       UNNotificationActionOptionAuthenticationRequired)];
    
    // Define the category
    UANotificationCategory *category = [UANotificationCategory categoryWithIdentifier:@"custom_category"
                                                                              actions:@[categoryAction]
                                                                    intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    
    // Set the custom categories
    [UAirship push].customCategories = [NSSet setWithArray:@[category]];
    
    // Update registration
    [[UAirship push] updateRegistration];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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





// UIApplicationDelegate methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UAAppIntegration application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [UAAppIntegration application:application didRegisterUserNotificationSettings:notificationSettings];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UAAppIntegration application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];


    [self getNotification:userInfo];


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

- (void)getNotification:(NSDictionary *)appInfo
{
    NSString *message = appInfo[@"display"][@"alert"];
    
    MessageModel *aModel =[[MessageModel alloc]init];
    aModel.messageTitle = message;
    [self.messageArr addObject:aModel];

}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response{


}

-(void)receivedNotificationResponse:(UANotificationResponse *)notificationResponse
                  completionHandler:(void (^)())completionHandler
{




}








@end
