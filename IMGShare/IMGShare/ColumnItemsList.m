//
//  ColumnItemsList.m
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColumnItemsList.h"
#import "ColumnItem.h"
#import "UtilsModel.h"

@implementation ColumnItemsList

- (id) init:(id) listDelegate withWidth:(int) columnWid
{
    self = [super init];
    itemsList = [[NSMutableArray alloc] init];
    startIndex = 0;
    endIndex = 0;
    delegate = listDelegate;
    columnWidth = columnWid;
    return self;
}

- (void) initSubItem:(BlogDataItem*) dataItem withIndex:(int) index
{
    if ([self isBottomCanAddItemInScreen:[delegate getBottomCacheOffset]])
    {
        ScrollImageItem* item = [delegate getSubImageItem];
       
        NSString* url = [UtilsModel GetFullBlogUrlStr:dataItem.pic_pid withImgType:EImageThumb];
        [item config:url withIndex:index];
        
        //CGSize size = [self GetSizeInView:[imageDelegate GetItemSize:itemIndex]];
        CGPoint pos = [self getLastPos];
        int columnHeight = [self getItemHeightInList:[dataItem getSize]];
        item.frame = CGRectMake(pos.x, pos.y, columnWidth, columnHeight);
        item.hidden = NO;
        
        ColumnItem* column = [[ColumnItem alloc] initWithFrame:item.frame withIndex:index];
        [column configItem:item];
        [itemsList addObject:column];
        [column release];
    }
    else
    {
        CGPoint pos = [self getLastPos];
        int columnHeight = [self getItemHeightInList:[dataItem getSize]];
        CGRect rect = CGRectMake(pos.x, pos.y, columnWidth, columnHeight);
        ColumnItem* column = [[ColumnItem alloc] initWithFrame:rect withIndex:index];        
        [itemsList addObject:column];
        [column release];
    }
}

- (void) configItem:(BlogDataItem*) dataItem withIndex:(int) itemIndex
{
    for (int index = 0; index < itemsList.count; index++)
    {
        ColumnItem* item = [itemsList objectAtIndex:index];
        if (itemIndex == [item getItemIndex]) 
        {
            if ([item isNoItemView])
            {
                ScrollImageItem* imageItem = [delegate getSubImageItem];
                [item configItem:imageItem];
            }
            break;
        }
    }
}

- (void) releaseItem:(int) itemIndex
{
    ColumnItem* item = [itemsList objectAtIndex:index];

    for (int index = 0; index < itemsList.count; index++)
    {
        if (itemIndex == [itemsList objectAtIndex:index])
        {
            [delegate releaseSubImageItem:item.itemView];
            [item releaseItem];
            break;
        }
    }
}

- (CGPoint) getFirstPos
{
    if (startIndex < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:startIndex];
        return item.topLeftPos;
    }
    else {
        return CGPointZero;
    }
}

- (CGPoint) getLastPos
{
    if (endIndex < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:endIndex];
        return item.bottomLeftPos;
    }
    else {
        return CGPointZero;
    }
}

- (bool) isTopCanAddItemInScreen:(int) topOffset
{
    if (itemsList.count == 0 || [self getFirstPos].y > topOffset)
    {
        return YES;
    }
    else {
        return NO;
    }
}

- (bool) isBottomCanAddItemInScreen:(int) bottomOffset
{
    if (itemsList.count > 0 && [self getLastPos].y < bottomOffset)
    {
        return YES;
    }
    else {
        return NO;
    }
}

- (int) getItemHeightInList:(CGSize) orgialSize
{
    int itemHeight = orgialSize.height * columnWidth / (orgialSize.width ? orgialSize.width : 300);
    return itemHeight;
}

@end
