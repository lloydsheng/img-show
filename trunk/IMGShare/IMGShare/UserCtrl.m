//
//  UserCtrl.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserCtrl.h"
#import "UIImageView+WebCache.h"

@implementation UserCtrl

@synthesize nickLabel;
@synthesize userPhotoUrl;
@synthesize userPhotoView;
@synthesize pubTimeStr;
@synthesize pubTimeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        userPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        
        UIImage* image = [UIImage imageNamed:@"default_photo.png"];
        userPhotoView.image = image;
        [self addSubview:userPhotoView];
        
        UIImageView* phoBg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        UIImage*  bgImg = [UIImage imageNamed:@"cell_profile_bg.png"];
        phoBg.image = bgImg;
        [self addSubview:phoBg];
        [phoBg release];
        
        nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 60, 30)];        
        nickLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        nickLabel.textColor = [UIColor blueColor];
        //nickLabel.shadowColor = [UIColor darkGrayColor];
        nickLabel.shadowOffset = CGSizeMake(0, 0.5);
        nickLabel.text = @"nick";
        [self addSubview:nickLabel];
        
        pubTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 60, 5, 60, 30)];
        pubTimeLable.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        pubTimeLable.textColor = [UIColor grayColor];
        //pubTimeLable.shadowColor = [UIColor darkGrayColor];
        pubTimeLable.shadowOffset = CGSizeMake(0, 0.5);
        pubTimeLable.text = @"time";
        [self addSubview:pubTimeLable];
                        
        userInfoBt = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, self.frame.size.height)];
        [userInfoBt addTarget:self action:@selector(onBtPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:userInfoBt];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) update:(NSString*) imgUrl nick:(NSString*) nickName time:  (NSString*) pubTime
{
    //[userPhotoView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_photo.png"]];
    self.userPhotoUrl = imgUrl;//retain +1
    self.pubTimeStr = pubTime;//retain +1
    
    [userPhotoView setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    nickLabel.text = nickName;
    [nickLabel sizeToFit];
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    //[format setTimeZone:[NSTimeZone systemTimeZone]];
     [format setDateFormat:@"EEE LLL dd HH:mm:ss zzzz yyyy"];
    NSDate* date = [format dateFromString:pubTime];
    
    //[format setDateFormat:@"HH:mm:ss"];
    //NSString* temp = [format stringFromDate:date];
    pubTimeLable.text = [self publishTimeFormat: date];
    [format release];
    
    [userInfoBt setFrame:CGRectMake(userInfoBt.frame.origin.x, userInfoBt.frame.origin.y, userPhotoView.frame.size.width + nickLabel.frame.size.width, userInfoBt.frame.size.height)];
}

- (NSString*) publishTimeFormat:(NSDate*) publishTime
{
    NSTimeInterval interval = 0 - [publishTime timeIntervalSinceNow];
    int min = interval / 60;
    int hour = min / 60;
    int day = hour / 12;
    if (min < 60) {
        return [NSString stringWithFormat:@"%d分钟之前", min];
    }
    else if( hour < 12)
    {
        return [NSString stringWithFormat:@"%d小时之前", hour];
    }
    else
    {
        return [NSString stringWithFormat:@"%d天之前", day];
    }
    
}

- (void) updateWithOther:(UserCtrl*) otherUser
{

    [self update: otherUser.userPhotoUrl nick: otherUser.nickLabel.text time: otherUser.pubTimeStr];

}

- (void) setBgAlpha
{
    UIColor* color = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    [self setBackgroundColor:color];
    UIColor* subColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:0];
    
    [userPhotoView setBackgroundColor:color];
    [nickLabel setBackgroundColor:subColor];
    [pubTimeLable setBackgroundColor:subColor];
}

- (void) onBtPressed:(UIButton*) sender
{
    
}

- (void) dealloc
{

    [userPhotoView release], userPhotoView = nil;
    [nickLabel release], nickLabel = nil;
    [pubTimeLable release], pubTimeLable = nil;
    
    [super dealloc];
}

@end
