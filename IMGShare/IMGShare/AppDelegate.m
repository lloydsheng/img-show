//
//  AppDelegate.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HotBlogViewController.h"
#import "HotBlogDataModel.h"
#import "HomePageViewController.h"
#import "ScrollImageListViewController.h"
#import "CKViewController.h"

@interface AppDelegate (Private)

- (void) prepareTabBar;

- (void) prepareLoading;

- (void) login;

- (void) datafinishDownloadNotify;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController;
@synthesize rootController;



- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self prepareLoading];
    //[self performSelector:@selector(prepareTabBar) withObject:nil afterDelay:3.0];
    
    if ([[HotBlogDataModel shareInstance] isLogin]) 
    {
        [self performSelector:@selector(prepareTabBar) withObject:nil afterDelay:1.0];
        
        [[HotBlogDataModel shareInstance] requestDataWithType:kRequestRefresh];

    }
    else
    {
        [HotBlogDataModel shareInstance].delegate = self;
        [[HotBlogDataModel shareInstance] performSelector:@selector(login) withObject: nil afterDelay: 0];
    }

    //[[NSNotificationCenter defaultCenter] postNotificationName:KHotBlogUpdateNotify object:nil];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(datafinishDownloadNotify) name:KHotBlogUpdateNotify object:nil];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) prepareTabBar
{
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    //HomePageViewController* viewC = [[HomePageViewController alloc] init];
    CKViewController* viewCamera = [[CKViewController alloc] init];
    //viewC.view = [[[UIView alloc] initWithFrame:rootController.view.bounds] autorelease];
    //[viewC.view setBackgroundColor:[UIColor blueColor]];
    viewCamera.tabBarItem = [[ UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed: @"heart.png"] tag:0];
    
    ScrollImageListViewController* viewC2 = [[ScrollImageListViewController alloc] init];
    //viewC2.view = [[[UIView alloc] initWithFrame:rootController.view.bounds] autorelease];
    //[viewC2.view setBackgroundColor:[UIColor yellowColor]];
    viewC2.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"热门" image:[UIImage imageNamed:@"group.png"] tag:1];
    
    HotBlogViewController* hotBlogController = [[HotBlogViewController alloc] init];
//    hotBlogController.view = [[[UITableView alloc] initWithFrame:rootController.view.bounds] autorelease];
    hotBlogController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"MM" image:[UIImage imageNamed:@"heart.png"] tag:2];

    NSArray* viewList = [[NSArray alloc] initWithObjects:hotBlogController, viewCamera, viewC2, nil];
    tabBarController.viewControllers = viewList;
    tabBarController.view.frame = CGRectMake(0, 0, rootController.view.bounds.size.width, rootController.view.bounds.size.height);
    [rootController.view addSubview:tabBarController.view];
    
    lastIndex = 0;
    
    [viewCamera release];
    //[viewC release];
    [viewC2 release];
    [viewList release];

}

- (void) prepareLoading
{
    rootController = [[UIViewController alloc] init];
    rootController.view.frame = [UIScreen mainScreen].applicationFrame;
    [self.window addSubview:rootController.view];

    UIImageView* loadImgView = [[UIImageView alloc] initWithFrame:rootController.view.bounds];
    UIImage* img = [ UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"startLoad" ofType:@"PNG"]];
    
    loadImgView.image = img;
    [rootController.view addSubview:loadImgView];
    
    
}

- (void) loginFinished
{
    
    [self prepareTabBar];
    [[HotBlogDataModel shareInstance] requestDataWithType:kRequestRefresh];

}

- (void) datafinishDownloadNotify
{
    NSArray* vcList = [tabBarController viewControllers];
    if (vcList.count > 0 && [vcList objectAtIndex:0]) {
        HotBlogViewController* hotVC = (HotBlogViewController*)[vcList objectAtIndex:0];
        [hotVC.tableView reloadData];
    }
    
}
- (void)tabBarController:(UITabBarController *)curtabBarController didSelectViewController:(UIViewController *)viewController
{
    
    //[UIView beginAnimations:nil context:nil];
    //[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //[UIView setAnimationTransition:UIViewAnimationOptionTransitionCrossDissolve forView:curtabBarController.view cache:YES];
    //[UIView setAnimationDuration:1];
    //[curtabBarController.view bringSubviewToFront:viewController.view];
    //[UIView transitionFromView:curtabBarController.selectedViewController.view toView:viewController.view duration:0.7 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished){}];

    //[UIView commitAnimations];

    CATransition* tran = [CATransition animation];
    tran.duration = 0.5;
    tran.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    NSString *moreTypes[]={@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
    //	
	//NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	//NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    tran.type = kCATransitionPush;
    if (curtabBarController.selectedIndex > lastIndex)
    {
        tran.subtype = kCATransitionFromRight;

    }
    else if(curtabBarController.selectedIndex < lastIndex)
    {
        tran.subtype = kCATransitionFromLeft;
    }
    lastIndex = curtabBarController.selectedIndex;
    
    [curtabBarController.view.layer addAnimation:tran forKey:nil];
    [curtabBarController.view bringSubviewToFront:viewController.view];
    
    //return YES;
}
@end
