//
//  SeedSync.m
//  SimplicITy
//
//  Created by Varghese Simon on 2/26/15.
//  Copyright (c) 2015 Vmoksha. All rights reserved.
//

#import "SeedSync.h"
#import <sqlite3.h>
#import "DBManager.h"
#import "SeedModel.h"
#import "Postman.h"
#import "Constant.h"

@interface SeedSync () <postmanDelegate, DBManagerDelegate>

@end

@implementation SeedSync
{
    Postman *postMan;
    NSString *URLString;
    NSString *databasePath;
    sqlite3 *database;
    DBManager *dbManager;

    NSMutableArray *seedDataArrAPI, *seedDataArrDB;
    NSMutableDictionary *seedDataDictFromAPI, *seeddataDictFromDB;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    URLString = SEED_API;
    
    postMan = [[Postman alloc] init];
    postMan.delegate = self;
}

- (void)initiateSeedAPI
{
    [postMan get:URLString];
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response forURL:(NSString *)urlString
{
    [self parseSeedata:response];
    [self saveSeeddata:response forUrl:urlString];
    
    if ([self.delegate respondsToSelector:@selector(seedSyncFinishedSuccessful:)])
    {
        [self.delegate seedSyncFinishedSuccessful:self];

    }


}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error forURL:(NSString *)urlString
{
    if ([self.delegate respondsToSelector:@selector(seedSyncFinishedWithFailure:)])
    {
        [self.delegate seedSyncFinishedWithFailure:self];
    }
}

- (void)parseSeedata:(NSData *)response
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    
    NSArray *arr= json[@"aaData"][@"seedmaster"];
    
    seedDataArrAPI = [[NSMutableArray alloc] init];
    seedDataDictFromAPI = [[NSMutableDictionary alloc] init];
    for (NSDictionary *aDict in arr)
    {
        SeedModel *seed = [[SeedModel alloc] init];
        seed.name = aDict[@"Name"];
        seed.type = aDict[@"Type"];
        seed.upDateCount = [aDict[@"Value"] intValue];
        [seedDataArrAPI addObject:seed];
        
        NSNumber *value = [NSNumber numberWithInteger:seed.upDateCount];
        
        [seedDataDictFromAPI setObject:value  forKey:seed.name];
    }
    
//    NSLog( @"Seed data from API's are %@ ",seedDataDictFromAPI);
    
    [self getData];
}

- (void)saveSeeddata:(NSData *)response forUrl:(NSString *)APILink
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate=self;
    }
    
    NSString *createQuery = @"create table if not exists seed (name text PRIMARY KEY, upDateCount  )";
    [dbManager createTableForQuery:createQuery];
    
    NSMutableString *stringFromData = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSRange rangeofString;
    rangeofString.location = 0;
    rangeofString.length = stringFromData.length;
    [stringFromData replaceOccurrencesOfString:@"'" withString:@"''" options:(NSCaseInsensitiveSearch) range:rangeofString];
    
    for (SeedModel *aSeed in seedDataArrAPI) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO  seed (name,upDateCount) values ('%@', '%i')", aSeed.name,aSeed.upDateCount];
        
        [dbManager saveDataToDBForQuery:insertSQL];
    }
}

- (void)getData
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"APIBackup.db"];
        dbManager.delegate=self;
    }
    
    //    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM seed WHERE API = '%@'", URLString];
    
    NSString *queryString = @"SELECT * FROM seed";
    
    if (![dbManager getDataForQuery:queryString])
    {
//        if (![AFNetworkReachabilityManager sharedManager].reachable)
//        {
//            UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:WARNING_TEXT message:INTERNET_IS_REQUIRED_TO_SYNC_DATA delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [noNetworkAlert show];
//        }
    }
   
    
    NSArray *arrkeys = [seedDataDictFromAPI allKeys];
    
    for (NSString *newkey in arrkeys)
    {
        if ([seedDataDictFromAPI[newkey] integerValue] > [seeddataDictFromDB[newkey] integerValue])
        {
            NSLog(@"Set Flags for %@" , newkey);
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:newkey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

    
   
}

- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    seedDataArrDB = [[NSMutableArray alloc] init ];
    seeddataDictFromDB = [[NSMutableDictionary alloc] init];
    
    while (sqlite3_step(statment) == SQLITE_ROW)
    {
        SeedModel *anSeed = [[SeedModel alloc] init];
        anSeed.name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 0)];
        anSeed.upDateCount = sqlite3_column_int(statment, 1);
        [seedDataArrDB addObject:anSeed];
        
        NSNumber *value = [NSNumber numberWithInt:anSeed.upDateCount];
        [seeddataDictFromDB setObject:value forKey:anSeed.name];
    }
}


@end
