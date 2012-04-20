//
//  UserDataItem.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataItem : NSObject
{
    NSString* user_id;
    NSString* screen_name;
    NSString* name;
    NSString* province;
    NSString* city;
    NSString* location;
    NSString* description;
    NSString* url;
    NSString* profile_image_url;
    NSString* domain;
    NSString* gender;
    NSString* followers_count;
    NSString* friends_count;
    NSString* statuses_count;
    NSString* favourites_count;
    NSString* created_at;
    NSString* following;
    NSString* allow_all_act_msg;
    NSString* remark;
    NSString* geo_enabled;
    NSString* verified;
    NSString* allow_all_comment;
    NSString* avatar_large;
    NSString* verified_reason;
    NSString* follow_me;
    NSString* online_status;
    NSString* bi_followers_count;
    
//    "id": 1404376560,
//    "screen_name": "zaku",
//    "name": "zaku",
//    "province": "11",
//    "city": "5",
//    "location": "北京 朝阳区",
//    "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
//    "url": "http://blog.sina.com.cn/zaku",
//    "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
//    "domain": "zaku",
//    "gender": "m",
//    "followers_count": 1204,
//    "friends_count": 447,
//    "statuses_count": 2908,
//    "favourites_count": 0,
//    "created_at": "Fri Aug 28 00:00:00 +0800 2009",
//    "following": false,
//    "allow_all_act_msg": false,
//    "remark": "",
//    "geo_enabled": true,
//    "verified": false,
//    "allow_all_comment": true,
//    "avatar_large": "http://tp1.sinaimg.cn/1404376560/180/0/1",
//    "verified_reason": "",
//    "follow_me": false,
//    "online_status": 0,
//    "bi_followers_count": 215

}

- (id) initWithData: (NSDictionary*) itemDic;

@property (nonatomic, retain) NSString* user_id;
@property (nonatomic, retain) NSString* screen_name;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* province;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* location;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* profile_image_url;
@property (nonatomic, retain) NSString* domain;
@property (nonatomic, retain) NSString* gender;
@property (nonatomic, retain) NSString* followers_count;
@property (nonatomic, retain) NSString* friends_count;
@property (nonatomic, retain) NSString* statuses_count;
@property (nonatomic, retain) NSString* favourites_count;
@property (nonatomic, retain) NSString* created_at;
@property (nonatomic, retain) NSString* following;
@property (nonatomic, retain) NSString* allow_all_act_msg;
@property (nonatomic, retain) NSString* remark;
@property (nonatomic, retain) NSString* geo_enabled;
@property (nonatomic, retain) NSString* verified;
@property (nonatomic, retain) NSString* allow_all_comment;
@property (nonatomic, retain) NSString* avatar_large;
@property (nonatomic, retain) NSString* verified_reason;
@property (nonatomic, retain) NSString* follow_me;
@property (nonatomic, retain) NSString* online_status;
@property (nonatomic, retain) NSString* bi_followers_count;



@end
