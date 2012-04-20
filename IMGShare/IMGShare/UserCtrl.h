//
//  UserCtrl.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCtrl : UIView
{
    NSString*       userPhotoUrl;
    UIImageView*    userPhotoView;
    UILabel*        nickLabel;
    NSString*       pubTimeStr;
    UILabel*        pubTimeLable;
    
    UIButton*       userInfoBt;
}

@property (nonatomic, retain) NSString* userPhotoUrl;
@property (nonatomic, retain) UIImageView* userPhotoView;
@property (nonatomic, retain) UILabel* nickLabel;
@property (nonatomic, retain) NSString* pubTimeStr;
@property (nonatomic, retain) UILabel* pubTimeLabel;

- (void) update:(NSString*) imgUrl nick:(NSString*) nickName time: (NSString*) pubTime;
- (void) updateWithOther:(UserCtrl*) otherUser;
- (void) setBgAlpha;
- (void) onBtPressed:(UIButton*) sender;
@end
