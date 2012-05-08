//
//  AppDelegate.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    int lastIndex;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIViewController* rootController;
@property (nonatomic, retain) UITabBarController* tabBarController;

- (void) loginFinished;

@end
