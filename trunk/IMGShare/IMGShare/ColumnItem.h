//
//  ColumnItem.h
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageItem.h"

@interface ColumnItem : NSObject
{
    CGPoint     topLeftPos;
    CGPoint     bottomLeftPos;
    int         width;
    
    ScrollImageItem*    itemView;
    
    int         itemIndex;
}

- (id) initWithFrame:(CGRect) frame withIndex:(int) index;
- (void) configItem:(ScrollImageItem*) item;
- (void) configItem:(ScrollImageItem*) item withFrame:(CGRect) frame withIndex:(int) index;
- (void) releaseItem;
- (int) getItemIndex;
- (bool) beforeYPos:(int) Ypos;
- (bool) afterYPos:(int) Ypos;
- (bool) isNoItemView;

@property (nonatomic, assign) CGPoint topLeftPos;
@property (nonatomic, assign) CGPoint bottomLeftPos;
@property (nonatomic, retain) ScrollImageItem* itemView;
@property (nonatomic, assign) int itemIndex;

@end
