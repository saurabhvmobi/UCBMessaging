/*
 Copyright 2009-2017 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PushHandler.h"
#import "DBManager.h"




@implementation PushHandler
{
    DBManager *dbManager;
}


-(void)receivedBackgroundNotification:(UANotificationContent *)notificationContent completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Application received a background notification
    UA_LDEBUG(@"The application received a background notification");

    // Call the completion handler

    NSLog(@"%@",notificationContent.alertBody);
    [self savePushNotificationinSqlite:notificationContent];
}

-(void)receivedForegroundNotification:(UANotificationContent *)notificationContent completionHandler:(void (^)())completionHandler {
    // Application received a foreground notification
    UA_LDEBUG(@"The application received a foreground notification");

    [self savePushNotificationinSqlite:notificationContent];

    completionHandler();

}

-(void)receivedNotificationResponse:(UANotificationResponse *)notificationResponse completionHandler:(void (^)())completionHandler {
    UA_LDEBUG(@"The user selected the following action identifier:%@", notificationResponse.actionIdentifier);

    completionHandler();
}

- (UNNotificationPresentationOptions)presentationOptionsForNotification:(UNNotification *)notification {
    return UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound;
}




-(void)savePushNotificationinSqlite:(UANotificationContent *)notificationContent
{
    
   
//    NSDictionary *notificationInfo =  notificationContent.notificationInfo;
//    NSDictionary *notificationAlert =notificationInfo[@"aps"][@"alert"];
//    NSString *body = notificationAlert[@"body"];
//    NSString *subtitle = notificationAlert[@"subtitle"];
//    NSString *title = notificationAlert[@"title"];
//    
    
    
    NSDictionary *notificationInfo =  notificationContent.notificationInfo;
    NSDictionary *notificationAlert =notificationInfo[@"aps"][@"alert"];
    NSString *body = notificationAlert[@"body"];
    NSString *subtitle = notificationAlert[@"subtitle"];
    NSString *title = notificationAlert[@"title"];
    

    
    
    
    
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"UCBMessage.db"];
        dbManager.delegate=self;
    }
    NSString *createQuery = @"create table if not exists Message (body text, subtitle text,title text)";
    [dbManager createTableForQuery:createQuery];
   
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  Message (body,subtitle,title) values ('%@', '%@', '%@')",body,subtitle,title];
        [dbManager saveDataToDBForQuery:insertSQL];
   }




@end
