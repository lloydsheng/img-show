//
//  HotBlogDataModel.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HotBlogDataModel.h"
#import "constDef.h"
#import "BlogDataItem.h"

const int kDefHotBlogNumPerPage = 50;

@interface HotBlogDataModel(Private)
- (bool) checkItemIsUseful:(NSDictionary*) item;
@end
@implementation HotBlogDataModel

@synthesize hotBlogArray;
@synthesize wbEngine;
@synthesize isActive;
@synthesize delegate;
@synthesize typeList;


+ (HotBlogDataModel*) shareInstance
{
    static HotBlogDataModel* hotBlog = nil;
    if (hotBlog == nil) {
        hotBlog = [[HotBlogDataModel alloc] init];
    }
    
    return hotBlog;
}

- (id) init
{
    self = [super init];
    if (self) {
        
        needResetList = NO;
       NSMutableArray* array  = [[NSMutableArray alloc] initWithCapacity:kDefHotBlogNumPerPage];
        self.hotBlogArray = array;
        [array release];
        
        //inti wbEngine
        self.wbEngine = [[[WBEngine alloc] initWithAppKey:KAppKey appSecret:KAppSecret] autorelease];
        
        //[wbEngine setRootViewController:self];
        [wbEngine setDelegate:self];
        [wbEngine setRedirectURI:@"http://"];
        [wbEngine setIsUserExclusive:NO];

        currentPageIndex = 1;
        isActive = NO;
        
        typeList = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"typelist" ofType:@"plist"]];
        
    }
    
    return self;
}

- (void) login
{
    if (![wbEngine isLoggedIn]) {
        [wbEngine logIn];
    }
    else
    {
        [self engineDidLogIn:wbEngine];
    }
}

- (bool) isLogin
{
    if (wbEngine) {
        return  [wbEngine isLoggedIn];
    }
    else return NO;
}

#pragma mark wbengine delegate
- (void)engineAlreadyLoggedIn:(WBEngine *)engine;
{
    
}

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    NSLog(@"log in sucess");
    if (delegate && [delegate respondsToSelector:@selector(loginFinished)])
    {
        [delegate loginFinished];
    }
    
    NSMutableDictionary* para = [[NSMutableDictionary alloc] initWithCapacity:3];
    [para setObject:@"1" forKey:@"type"];
    [para setObject:@"1" forKey:@"is_pic"];
    [para setObject:@"100" forKey:@"count"];
    [engine loadRequestWithMethodName:@"suggestions/statuses/hot.json" httpMethod:@"GET" params:para postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
    isActive = YES;
    
    [para release];
}
// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    
}

// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine
{
    
}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    isActive = NO;
    needResetList = NO;
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    //    NSString *dataString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    //    id data = [dataString JSONValue];
    //    if ([data isKindOfClass: [NSDictionary class]])
    //    {
    //        
    //    }
    //返回的已是字典
    if ([result isKindOfClass:[NSDictionary class]]) {
        id statuses = [result objectForKey:@"statuses"];
        if ([statuses isKindOfClass:[NSDictionary class]]) {
            
        }
        else if([statuses isKindOfClass:[NSArray class]])
        {
            if (needResetList == YES) {
                [hotBlogArray removeAllObjects];
                needResetList = NO;
            }
            
            NSMutableArray* delList = [[NSMutableArray alloc] initWithCapacity:4];
            for (NSDictionary* item in statuses) 
            {
                if([self checkItemIsUseful: item])
                {
                    BlogDataItem* dataItem = [[BlogDataItem alloc] initWithDic:item];
                    [self.hotBlogArray addObject:dataItem];
                    [dataItem release];
                }
                else
                {
                    [delList addObject:item];
                }
            }
            
            [statuses removeObjectsInArray:delList];
            [delList release];
            
            if (hotBlogArray.count > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KHotBlogUpdateNotify object:nil];
                currentPageIndex ++;
            }

        }
        
    }
    isActive = NO;
}

- (void) requestDataWithType:(TRequestType) requestType
{
    NSMutableDictionary* para = [[NSMutableDictionary alloc] initWithCapacity:3];
    [para setObject:@"3" forKey:@"type"];
    [para setObject:@"1" forKey:@"is_pic"];
    [para setObject:@"100" forKey:@"count"];
    
    if(requestType == KRequestNextPage)
    {
        [para setObject:[NSString stringWithFormat:@"%d", currentPageIndex + 1] forKey:@"page"];

    }
    else//kRequestRefresh
    {
        currentPageIndex = 0;
    }
    [wbEngine loadRequestWithMethodName:@"suggestions/statuses/hot.json" httpMethod:@"GET" params:para postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
    isActive = YES;
    [para release];
}

- (void) requestData:(NSString*) typeCode withRequestType: (TRequestType) requestType;
{
    NSMutableDictionary* para = [[NSMutableDictionary alloc] initWithCapacity:3];
    [para setObject:typeCode forKey:@"type"];
    [para setObject:@"1" forKey:@"is_pic"];
    
    if(requestType == KRequestNextPage)
    {
        [para setObject:[NSString stringWithFormat:@"%d", currentPageIndex + 1] forKey:@"page"];
        
    }
    else//kRequestRefresh
    {
        currentPageIndex = 0;
        needResetList = YES;
    }
    [wbEngine loadRequestWithMethodName:@"suggestions/statuses/hot.json" httpMethod:@"GET" params:para postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
    isActive = YES;
    [para release];
}

- (bool) checkItemIsUseful:(NSDictionary*) item
{
    NSString* widStr = [item objectForKey:@"pwidth"];
    NSString* heightStr = [item objectForKey:@"pheight"];
    if (widStr && heightStr) 
    {
        int wid = [widStr intValue];
        int height = [heightStr intValue];
        if (wid != 0 && height / wid <= 2) {
            return YES;
        }
    }
    
    return NO;
}

- (void) dealloc
{
    self.hotBlogArray = nil;
    self.typeList = nil;
}

@end
