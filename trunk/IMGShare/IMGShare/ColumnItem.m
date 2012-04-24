//
//  ColumnItem.m
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColumnItem.h"

@implementation ColumnItem
@synthesize topLeftPos;
@synthesize bottomLeftPos;
@synthesize itemView;

- (id) initWithFrame:(CGRect) frame withIndex:(int) index
{
    self = [super init];
    [self setFrame:frame];
    itemIndex = index;
    return self;
}
- (void) configItem:(ScrollImageItem*) item
{
    item.frame = CGRectMake(topLeftPos.x, topLeftPos.y, width, bottomLeftPos.y - topLeftPos.y);
    self.itemView = item;
}
- (void) configItem:(ScrollImageItem*) item withFrame:(CGRect) frame withIndex:(int) index
{
    [self setFrame:frame];
    [self configItem:item];
    itemIndex = index;
    
}
- (void) releaseItem
{
    self.itemView = nil;
}
- (int) getItemIndex
{
    return itemIndex;
}

- (void) setFrame:(CGRect) frame
{
    topLeftPos = frame.origin;
    bottomLeftPos = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);
    width = frame.size.width;
}

- (bool) beforeYPos:(int) Ypos
{
    if (topLeftPos.y < Ypos) {
        return YES;
    }
    else {
        return NO;
    }
}

- (bool) afterYPos:(int) Ypos
{
    if (bottomLeftPos.y > Ypos) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
