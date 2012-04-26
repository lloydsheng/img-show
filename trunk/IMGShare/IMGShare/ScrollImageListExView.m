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
- (ColumnItemsList*) getNextVisiblePosColumn;
- (ColumnItemsList*) getPreVisiblePosColumn;

- (ColumnItemsList*) getNextInitPosColumn;

@end

@implementation ScrollImageListExView
@synthesize imageDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (ScrollImageListExView*) initWithFrame:(CGRect)frame withColumn:(int) column
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
    int offsetX = eachItemWidGrap;
    for (int index = 0; index < column; index++)
    {
        ColumnItemsList* subList = [[ColumnItemsList alloc] init:self withWidth:itemWidth offset: offsetX];
        [allItemsColumn addObject: subList];
        [subList release];
        offsetX = offsetX + eachItemWidGrap + itemWidth;
    }
    
    return self;
    
}

- (void) config
{

    for (int itemIndex = 0; itemIndex < [imageDelegate GetItemsCount]; itemIndex++) 
    {
        
        ColumnItemsList* list = [self getNextInitPosColumn];
        if (list)
        {
            BlogDataItem* itemData = (BlogDataItem*)[imageDelegate GetImageItem:itemIndex];
            [list initSubItem: itemData withIndex:itemIndex];
            NSLog(@"current all list index = %d\r\n", itemIndex);
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

- (ColumnItemsList*) getNextVisiblePosColumn
{
    if (allItemsColumn.count ==0)
    {
        return nil;
    }
    int offsetY = 0;
    int index = 0;
    int lastIndex = 0;
    for (; index < allItemsColumn.count; index++) {
        ColumnItemsList* item = [allItemsColumn objectAtIndex: index];
        if ([item getItemsCount] == 0) 
        {
            offsetY = [item getLastVisiblePos].y;
            lastIndex = index;
            break;
        }
        else if ([item getLastVisiblePos].y < offsetY || index == 0)
        {
            offsetY = [item getLastVisiblePos].y;
            lastIndex = index;
        }
    }
    NSLog(@"current list index = %d", lastIndex);
    return [allItemsColumn objectAtIndex:lastIndex];
}

- (ColumnItemsList*) getPreVisiblePosColumn
{
    if (allItemsColumn.count ==0)
    {
        return nil;
    }
    int offsetY = 0;
    int index = 0;
    int lastIndex = 0;
    for (; index < allItemsColumn.count; index++) {
        ColumnItemsList* item = [allItemsColumn objectAtIndex: index];
        if (index == 0) 
        {
            offsetY = [item getFirstVisiblePos].y;
            lastIndex = 0;
        }
        else if ([item getFirstVisiblePos].y > offsetY)
        {
            offsetY = [item getFirstVisiblePos].y;
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
    return hightNextCache + self.frame.size.height;
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
        [self addSubview:item];
        return [item autorelease];
    }
    
}

- (id) getSubDataItem:(int) allListIndex
{
    if (allListIndex < [imageDelegate GetItemsCount]) {
        return [imageDelegate GetImageItem:allListIndex];
    }
    return nil;
}

- (void) releaseSubImageItem:(ScrollImageItem*) imageItem
{
    if (imageItem)
    {
        [imageItem releaseInfo];
        [reuseList addObject:imageItem];
    }
}

- (ColumnItemsList*) getNextInitPosColumn;
{
    if (allItemsColumn.count ==0)
    {
        return nil;
    }
    int offsetY = 0;
    int index = 0;
    int lastIndex = 0;
    for (; index < allItemsColumn.count; index++) {
        ColumnItemsList* item = [allItemsColumn objectAtIndex: index];
        if ([item getItemsCount] == 0) 
        {
            offsetY = [item getEndPos].y;
            lastIndex = index;
            break;
        }
        else if ([item getEndPos].y < offsetY || index == 0)
        {
            offsetY = [item getEndPos].y;
            lastIndex = index;
        }
    }
    NSLog(@"current list index = %d", lastIndex);
    return [allItemsColumn objectAtIndex:lastIndex];
}

- (void) updateVisibleListWhenScroll2Down
{
    if([imageDelegate  GetItemsCount]== 0)
        return;
    
    NSMutableArray* delArr = [[NSMutableArray alloc] initWithCapacity:3];
    for (int index = 0; index < allItemsColumn.count; index ++) 
    {
        ColumnItemsList* list = [allItemsColumn objectAtIndex:index];
        
        [list scrollDowntoPosY:self.contentOffset.y];
    }


}

- (void) updateVisibleListWhenScroll2Up
{

}


- (void) btPressed
{
    
}


@end
