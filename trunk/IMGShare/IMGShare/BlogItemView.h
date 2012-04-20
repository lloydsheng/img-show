//
//  BlogItemView.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCtrl.h"
#import "BlogDataItem.h"
@interface BlogItemView : UIView
{
    UserCtrl* userView;
    UIImageView* blogPhoto;
    UITextView* blogContent;
    
    NSMutableArray* btList;//UIButton;
    
    BlogDataItem* blogData;
    
    int  height;
}

//retain data 是否合理
@property (nonatomic, retain) UserCtrl* userView;
@property (nonatomic, retain) BlogDataItem* blogData;
@property (nonatomic, assign) int height;
- (id) initWithData:(BlogDataItem*) data frame:(CGRect) rect;
- (void) updateWithData:(BlogDataItem*) data;
- (void) onBtPressed:(UIButton*) sender;


@end
