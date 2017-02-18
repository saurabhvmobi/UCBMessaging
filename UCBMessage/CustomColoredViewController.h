//
//  CustomColoredViewController.h
//  SimplicITy
//
//  Created by Varghese Simon on 12/11/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomFontNames)
{
    MuseoSans_100 = 1,
    MuseoSans_300,
    MuseoSans_700
};

@interface CustomColoredViewController : UIViewController
- (NSString *)stingForColorTheme;
- (UIColor *)barColorForIndex:(NSInteger)index;
-(UIColor *)subViewsColours;
-(UIColor *)seperatorColours;

-(UIFont *)customFont:(NSInteger)size ofName:(CustomFontNames)fontName;



@end
