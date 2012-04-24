//
//  BlogDataItem.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataItem.h"

@interface BlogDataItem : NSObject
{
    NSString* pic_pid;
    NSString* pic_pwidth;
    NSString* pic_pheight;
    NSString* pic_is_pic;
    
    NSString* created_at;
    NSString* blog_id;
    NSString* text;
    NSString* source;
    NSString* favorited;
    NSString* truncated;
    NSString* in_reply_to_status_id;
    NSString* in_reply_to_user_id;
    NSString* in_reply_to_screen_name;
    NSString* geo;
    NSString* mid;
    NSString* reposts_count;
    NSString* comments_count;
    NSMutableArray* annotations;
    
    UserDataItem* user;

}

-(CGSize) getSize;

@property (nonatomic, retain) NSString* pic_pid;
@property (nonatomic, retain) NSString* pic_pwidth;
@property (nonatomic, retain) NSString* pic_pheight;
@property (nonatomic, retain) NSString* pic_is_pic;

@property (nonatomic, retain) NSString* created_at;
@property (nonatomic, retain) NSString* blog_id;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* source;
@property (nonatomic, retain) NSString* favorited;
@property (nonatomic, retain) NSString* truncated;
@property (nonatomic, retain) NSString* in_reply_to_status_id;
@property (nonatomic, retain) NSString* in_reply_to_user_id;
@property (nonatomic, retain) NSString* in_reply_to_screen_name;
@property (nonatomic, retain) NSString* geo;
@property (nonatomic, retain) NSString* mid;
@property (nonatomic, retain) NSString* reposts_count;
@property (nonatomic, retain) NSString* comments_count;
@property (nonatomic, retain) NSMutableArray* annotations;

@property (nonatomic, retain) UserDataItem* user;

-(id) initWithDic:(NSDictionary*) dic;

@end
