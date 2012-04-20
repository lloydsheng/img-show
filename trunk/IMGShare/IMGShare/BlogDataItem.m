//
//  BlogDataItem.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlogDataItem.h"

@implementation BlogDataItem

@synthesize pic_pid;
@synthesize pic_pwidth;
@synthesize pic_pheight;
@synthesize pic_is_pic;

@synthesize created_at;
@synthesize blog_id;
@synthesize text;
@synthesize source;
@synthesize favorited;
@synthesize truncated;
@synthesize in_reply_to_status_id;
@synthesize in_reply_to_user_id;
@synthesize in_reply_to_screen_name;
@synthesize geo;
@synthesize mid;
@synthesize reposts_count;
@synthesize comments_count;
@synthesize annotations;

@synthesize user;

-(id) initWithDic:(NSDictionary*) dic
{
    self = [super init];
    if (self && dic) {
        self.pic_pid = [dic objectForKey:@"pid"];
        self.pic_pwidth = [dic objectForKey:@"pwidth"];
        self.pic_pheight = [dic objectForKey:@"pheight"];
        self.pic_is_pic = [dic objectForKey:@"is_pic"];
        
        NSDictionary* blogInfo = [dic objectForKey:@"status"];
        if (blogInfo) {
            self.created_at = [blogInfo objectForKey:@"created_at"];
            self.blog_id = [blogInfo objectForKey:@"id"];
            self.text = [blogInfo objectForKey:@"text"];
            self.source = [blogInfo objectForKey:@"source"];
            self.favorited = [blogInfo objectForKey:@"favorited"];
            self.truncated = [blogInfo objectForKey:@"truncated"];
            self.in_reply_to_status_id = [blogInfo objectForKey:@"in_reply_to_status_id"];
            self.in_reply_to_user_id = [blogInfo objectForKey:@"in_reply_to_user_id"];
            self.geo = [blogInfo objectForKey:@"geo"];
            self.mid = [blogInfo objectForKey:@"mid"];
            self.reposts_count = [blogInfo objectForKey:@"reposts_count"];
            self.comments_count = [blogInfo objectForKey:@"comments_count"];
            NSDictionary* userDic = [blogInfo objectForKey:@"user"];
            if (userDic) 
            {
                UserDataItem* userItem = [[UserDataItem alloc] initWithData:userDic];
                self.user = userItem;
                [userItem release];
            }
        }
    }
    return self;
}

-(void) dealloc
{
    self.pic_pid = nil;
    self.pic_pwidth = nil;
    self.pic_pheight = nil;
    self.pic_is_pic = nil;
    
    self.created_at = nil;
    self.blog_id = nil;
    self.text = nil;
    self.source = nil;
    self.favorited = nil;
    self.truncated = nil;
    self.in_reply_to_status_id = nil;
    self.in_reply_to_user_id = nil;
    self.geo = nil;
    self.mid = nil;
    self.reposts_count = nil;
    self.comments_count = nil;
        
    self.user = nil;
        

}

@end
