//
//  ScrollImageItem.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollImageItem : UIView
{
    UIImageView*    imageView;
    UIButton*       imageBt;
    
    //id              btDelegate;
    UILabel*        imageTitle;
    
    UIActivityIndicatorView* imageWait;
}

@property (nonatomic, retain) UIImageView* imageView;

- (id)initWithFrame:(CGRect)frame delegate:(id) delegate;

- (void) config: (NSString*) imgUrl withIndex:(int) itemIndex;

- (void) releaseInfo;

@end
