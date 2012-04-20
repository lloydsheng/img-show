//
//  SelfGridItem.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridItemDelegate <NSObject>

-(void) onProcessBtPressed:(NSString*) btTitle;

@end

@interface SelfGridItem : UIView
{
    UIButton*       itemButton;
    UIImageView*    itemImageView;
    UILabel*        itemTitle;
    id              btDelegate;
}

@property (nonatomic, assign) id btDelegate;

- (void) updateInfo: (NSString*) imgUrl withTitle:(NSString*) title;
- (void) btPressed;

@end
