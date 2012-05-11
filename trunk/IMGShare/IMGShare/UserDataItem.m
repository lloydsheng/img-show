//
//  UserDataItem.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserDataItem.h"

@implementation UserDataItem

@synthesize user_id;
@synthesize screen_name;
@synthesize name;
@synthesize province;
@synthesize city;
@synthesize location;
@synthesize description;
@synthesize url;
@synthesize profile_image_url;
@synthesize domain;
@synthesize gender;
@synthesize followers_count;
@synthesize friends_count;
@synthesize statuses_count;
@synthesize favourites_count;
@synthesize created_at;
@synthesize following;
@synthesize allow_all_act_msg;
@synthesize remark;
@synthesize geo_enabled;
@synthesize verified;
@synthesize allow_all_comment;
@synthesize avatar_large;
@synthesize verified_reason;
@synthesize follow_me;
@synthesize online_status;
@synthesize bi_followers_count;


- (id) initWithData: (NSDictionary*) itemDic
{
    self = [super init];
    if (self && itemDic) {
        //所有成员是nsstring,都retain+1
        self.user_id = [itemDic objectForKey:@"id"];
        self.screen_name = [itemDic objectForKey:@"screen_name"];
        self.name = [itemDic objectForKey:@"name"];
        self.province = [itemDic objectForKey:@"province"];
        self.city = [itemDic objectForKey:@"city"];
        self.location = [itemDic objectForKey:@"location"];
        self.description = [itemDic objectForKey:@"description"];
        self.url = [itemDic objectForKey:@"url"];
        self.profile_image_url = [itemDic objectForKey:@"profile_image_url"];
        self.domain = [itemDic objectForKey:@"domain"];
        self.gender = [itemDic objectForKey:@"gender"];
        self.followers_count = [itemDic objectForKey:@"followers_count"];
        self.friends_count = [itemDic objectForKey:@"friends_count"];
        self.statuses_count = [itemDic objectForKey:@"statuses_count"];
        self.favourites_count = [itemDic objectForKey:@"favourites_count"];
        self.created_at = [itemDic objectForKey:@"created_at"];
        self.following = [itemDic objectForKey:@"following"];
        self.allow_all_act_msg = [itemDic objectForKey:@"allow_all_act_msg"];
        self.remark = [itemDic objectForKey:@"remark"];
        self.geo_enabled = [itemDic objectForKey:@"geo_enabled"];
        self.verified = [itemDic objectForKey:verified];
        self.allow_all_comment = [itemDic objectForKey:@"allow_all_comment"];
        self.avatar_large = [itemDic objectForKey:@"avatar_large"];
        self.verified_reason = [itemDic objectForKey:@"verified_reason"];
        self.follow_me = [itemDic objectForKey:@"follow_me"];
        self.online_status = [itemDic objectForKey:@"online_status"];
        self.bi_followers_count = [itemDic objectForKey:@"bi_followers_count"];
                            
    }
    return self;
}

-(void) dealloc
{
    self.user_id = nil;
    self.screen_name = nil;
    self.name = nil;
    self.province = nil;
    self.city = nil;
    self.location = nil;
    self.description = nil;
    self.url = nil;
    self.profile_image_url = nil;
    self.domain = nil;
    self.gender = nil;
    self.followers_count = nil;
    self.friends_count = nil;
    self.statuses_count = nil;
    self.favourites_count = nil;
    self.created_at = nil;
    self.following = nil;
    self.allow_all_act_msg = nil;
    self.remark = nil;
    self.geo_enabled = nil;
    self.verified = nil;
    self.allow_all_comment = nil;
    self.avatar_large = nil;
    self.verified_reason = nil;
    self.follow_me = nil;
    self.online_status = nil;
    self.bi_followers_count = nil;
    [super dealloc];
}


@end
