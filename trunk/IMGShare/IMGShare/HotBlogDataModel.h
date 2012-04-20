//
//  HotBlogDataModel.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"
#import "constDef.h"

@interface HotBlogDataModel : NSObject<WBEngineDelegate>
{
 
    NSMutableArray* hotBlogArray;
    
    int     currentPageIndex;
    bool    isActive;
    id      delegate;
    
    bool    needResetList;
    
    NSDictionary* typeList;
    
}

@property (nonatomic, retain) NSMutableArray* hotBlogArray;
@property (nonatomic, retain) WBEngine* wbEngine;
@property (nonatomic, assign) bool isActive;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSDictionary* typeList;

+ (HotBlogDataModel*) shareInstance;
- (void) login;
- (void) requestDataWithType:(TRequestType) requestType;
- (bool) isLogin;

- (void) requestData:(NSString*) typeCode withRequestType: (TRequestType) requestType;


@end
