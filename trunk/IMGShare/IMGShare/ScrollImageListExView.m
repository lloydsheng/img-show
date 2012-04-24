//
//  ScrollImageListExView.m
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageListExView.h"
#import "ScrollImageItem.h"
#import "BlogDataItem.h"
#import "UtilsModel.h"
#import "ColumnItemsList.h"

@interface ScrollImageListExView(Private)
- (void) confiyArr:(NSMutableArray*) array withLimit:(int) count;
- (CGSize) GetSizeInView:(CGSize) orgialSize;
- (ColumnItemsList*) getNextPosColumn;
- (ColumnItemsList*) getPrePosColumn;

@end

@implementation ScrollImageListExView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame withColumn:(int) column
{
    [self initWithFrame:frame];
    if (column == 0)
    {
        column = 4;
    }
    else
    {
        itemCountEachRow = column;
    }
    
    reuseList = [[NSMutableArray alloc] initWithCapacity:10];
    
    hightPreCache = frame.size.height / 2;
    hightNextCache = frame.size.height / 2;
    
    eachItemWidGrap = 4;
    itemWidth = (self.bounds.size.width - itemCountEachRow * (eachItemWidGrap + 1)) / itemCountEachRow;
    
    allItemsColumn = [[NSMutableArray alloc] initWithCapacity:column];
    for (int index = 0; index < column; index++)
    {
        [allItemsColumn addObject:[[ColumnItemsList alloc] init:self withWidth:itemWidth]];
    }
    
    return self;
    
}

- (void) config
{

    for (int itemIndex = 0; itemIndex < [imageDelegate GetItemsCount]; itemIndex++) 
    {
        
        ColumnItemsList* list = [self getNextPosColumn];
        if (list)
        {
            BlogDataItem* itemData = (BlogDataItem*)[imageDelegate GetImageItem:itemIndex];
            [list initSubItem: itemData withIndex:itemIndex];
        }
    }
}

- (void) configImage:(ScrollImageItem*) scrollItem withIndex:(int) itemIndex withPos:(CGPoint) pos
{
    if (imageDelegate && [imageDelegate respondsToSelector:@selector(GetImageItem:)])
    {
        BlogDataItem* itemData = (BlogDataItem*)[imageDelegate GetImageItem:itemIndex];
        if (itemData) 
        {
            
            NSString* url = [UtilsModel GetFullBlogUrlStr:itemData.pic_pid withImgType:EImageThumb];
            [scrollItem config:url withIndex:itemIndex];
            CGSize size = [self GetSizeInView:[imageDelegate GetItemSize:itemIndex]];
            scrollItem.frame = CGRectMake(pos.x, pos.y, size.width, size.height);
            scrollItem.hidden = NO;
                                    
        }
    }
}

- (CGSize) GetSizeInView:(CGSize) orgialSize
{
    int itemHeight = orgialSize.height * itemWidth / (orgialSize.width ? orgialSize.width : 300);
    return CGSizeMake(itemWidth, itemHeight);
}

- (ColumnItemsList*) getNextPosColumn
{
    if (allItemsColumn.count ==0)
    {
        return nil;
    }
    int offsetY = 0;
    int index = 0;
    int lastIndex = 0;
    for (; index < allItemsColumn; index++) {
        ColumnItemsList* item = [allItemsColumn objectAtIndex: index];
        if (index == 0) 
        {
            offsetY = [item getLastPos].y;
            lastIndex = 0;
        }
        else if ([item getLastPos].y < offsetY)
        {
            offsetY = [item getLastPos].y;
            lastIndex = index;
        }
    }
    return [allItemsColumn objectAtIndex:lastIndex];
}

- (ColumnItemsList*) getPrePosColumn
{
    if (allItemsColumn.count ==0)
    {
        return nil;
    }
    int offsetY = 0;
    int index = 0;
    int lastIndex = 0;
    for (; index < allItemsColumn; index++) {
        ColumnItemsList* item = [allItemsColumn objectAtIndex: index];
        if (index == 0) 
        {
            offsetY = [item getLastPos].y;
            lastIndex = 0;
        }
        else if ([item getLastPos].y > offsetY)
        {
            offsetY = [item getLastPos].y;
            lastIndex = index;
        }
    }
    return [allItemsColumn objectAtIndex:lastIndex];
}

#pragma mark
#pragma ColumnListDelegate
- (int) getTopCacheOffset
{
    return hightPreCache;
}

- (int) getBottomCacheOffset
{
    return hightNextCache;
}
- (ScrollImageItem*) getSubImageItem
{
    if (reuseList.count > 0) 
    {
        ScrollImageItem* item = [reuseList objectAtIndex:0];
        [item retain];
        [reuseList removeObjectAtIndex:0];
        return [item autorelease];
    }
    else
    {
        ScrollImageItem* item = [[ScrollImageItem alloc] initWithFrame:CGRectZero delegate:self];
        return [item autorelease];
    }
    
}

- (void) releaseSubImageItem:(ScrollImageItem*) imageItem
{
    if (imageItem)
    {
        [imageItem releaseInfo];
        [reuseList addObject:imageItem];
    }
}

- (void) btPressed
{
    
}


@end
