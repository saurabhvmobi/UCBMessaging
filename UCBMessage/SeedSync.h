//
//  SeedSync.h
//  SimplicITy
//
//  Created by Varghese Simon on 2/26/15.
//  Copyright (c) 2015 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeedSync;

@protocol SeedSyncDelegate <NSObject>
@optional
- (void)seedSyncFinishedSuccessful:(SeedSync *)seedSync;
- (void)seedSyncFinishedWithFailure:(SeedSync *)seedSync;
@end

@interface SeedSync : NSObject

@property (weak, nonatomic) id<SeedSyncDelegate> delegate;
- (void)initiateSeedAPI;

@end
