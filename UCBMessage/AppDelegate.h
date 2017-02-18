//
//  AppDelegate.h
//  UCBMessage
//
//  Created by vmoksha mobility on 08/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCategoryFetcher.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)NSMutableArray *messageArr;
@property (strong, nonatomic) NewsCategoryFetcher *fetcher;

@end

