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
@synthesize startIndex;
@synthesize endIndex;

- (id) init:(id) listDelegate withWidth:(int) columnWid offset:(int) posX
{
    self = [super init];
    itemsList = [[NSMutableArray alloc] init];
    startIndex = 0;
    endIndex = 0;
    delegate = listDelegate;
    columnWidth = columnWid;
    columnXPos = posX;
    return self;
}

- (void) initSubItem:(BlogDataItem*) dataItem withIndex:(int) index 
{
    if ([self isBottomCanAddItemInScreen:[delegate getBottomCacheOffset]])
    {

        ScrollImageItem* item = [delegate getSubImageItem];
        
        //CGSize size = [self GetSizeInView:[imageDelegate GetItemSize:itemIndex]];
        CGPoint pos = [self getEndPos];
        int columnHeight = [self getItemHeightInList:[dataItem getSize]];
        item.frame = CGRectMake(pos.x, pos.y, columnWidth, columnHeight);
        item.hidden = NO;
        
        NSString* url = [UtilsModel GetFullBlogUrlStr:dataItem.pic_pid withImgType:EImageThumb];
        [item config:url withIndex:index];
        
        ColumnItem* column = [[ColumnItem alloc] initWithFrame:item.frame withIndex:index];
        [column configItem:item];
        [itemsList addObject:column];
        endIndex = [itemsList count] - 1;
        [column release];
        
       // NSLog(@"visible item index = %d", index);
        
    }
    else
    {
        CGPoint pos = [self getEndPos];
        int columnHeight = [self getItemHeightInList:[dataItem getSize]];
        CGRect rect = CGRectMake(pos.x, pos.y, columnWidth, columnHeight);
        ColumnItem* column = [[ColumnItem alloc] initWithFrame:rect withIndex:index];        
        [itemsList addObject:column];
        [column release];
        
        //NSLog(@"not visible item index = %d", index);

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
                
                NSString* url = [UtilsModel GetFullBlogUrlStr:dataItem.pic_pid withImgType:EImageThumb];
                [imageItem config:url withIndex:itemIndex];
                
                [item configItem:imageItem];
                if (itemsList.count > endIndex + 1)
                {
                    endIndex ++;
                }                
            }
            break;
        }
    }
}

- (void) configNextItem:(BlogDataItem*) dataItem withIndex:(int) allListindex
{
    if(endIndex + 1 < itemsList.count)
    {
        CGPoint pos = [self getLastVisibleBLPos];
        endIndex++;
        ColumnItem* item = [itemsList objectAtIndex:endIndex];
        if ([item isNoItemView])
        {
            ScrollImageItem* imageItem = [delegate getSubImageItem];
            int columnHeight = [self getItemHeightInList:[dataItem getSize]];
            imageItem.frame = CGRectMake(pos.x, pos.y, columnWidth, columnHeight);
            
            NSString* url = [UtilsModel GetFullBlogUrlStr:dataItem.pic_pid withImgType:EImageThumb];
            [imageItem config:url withIndex:allListindex];
            [imageItem setBackgroundColor:[UIColor blueColor]];
            [item configItem:imageItem];
               
        }
    }
}

- (void) configPreItem:(BlogDataItem*) dataItem withIndex:(int) allListindex
{
    if(startIndex > 0)
    {
        CGPoint pos = [self getFirstVisibleTLPos];
        startIndex--;
        ColumnItem* item = [itemsList objectAtIndex:startIndex];
        if ([item isNoItemView])
        {
            ScrollImageItem* imageItem = [delegate getSubImageItem];
            int columnHeight = [self getItemHeightInList:[dataItem getSize]];
            imageItem.frame = CGRectMake(pos.x, pos.y - columnHeight, columnWidth, columnHeight);
            
            NSString* url = [UtilsModel GetFullBlogUrlStr:dataItem.pic_pid withImgType:EImageThumb];
            [imageItem config:url withIndex:allListindex];
            [imageItem setBackgroundColor:[UIColor blueColor]];
            [item configItem:imageItem];
            
        }
    }
}

//- (void) configItemBefore:(BlogDataItem*) dataItem withIndex:(int) itemIndex
//{
//    for (int index = 0; index < itemsList.count; index++)
//    {
//        ColumnItem* item = [itemsList objectAtIndex:index];
//        if (itemIndex == [item getItemIndex]) 
//        {
//            if ([item isNoItemView])
//            {
//                ScrollImageItem* imageItem = [delegate getSubImageItem];
//                
//                NSString* url = [UtilsModel GetFullBlogUrlStr:dataItem.pic_pid withImgType:EImageThumb];
//                [imageItem config:url withIndex:itemIndex];
//                
//                [item configItem:imageItem];
//                if (startIndex > 0)
//                {
//                    startIndex--;
//                }                
//            }
//            break;
//        }
//    }
//}

- (void) releaseItem:(int) itemIndex
{
    ColumnItem* item = [itemsList objectAtIndex:itemIndex];

    for (int index = 0; index < itemsList.count; index++)
    {
        if (itemIndex == [item getItemIndex])
        {
            [delegate releaseSubImageItem:item.itemView];
            [item releaseItem];
            if (startIndex > 0)
            {
                startIndex--;
            }
            break;
        }
    }
}

- (void) releaseFirstItem
{
    if (startIndex >= 0 && startIndex < itemsList.count)
    {
        ColumnItem* item = [itemsList objectAtIndex:startIndex];
        [delegate releaseSubImageItem:item.itemView];
        [item releaseItem];
        if (startIndex + 1 < itemsList.count) {
            startIndex ++;
        }
        else {
            startIndex = 0;
        }
    }
}

- (void) releaseLastItem
{
    if (endIndex >= 0 && endIndex < itemsList.count)
    {
        ColumnItem* item = [itemsList objectAtIndex:endIndex];
        [delegate releaseSubImageItem:item.itemView];
        [item releaseItem];
        if (endIndex > 0) {
            endIndex--;
        }
        else {
            endIndex = 0;
        }
    }
}

- (int) getItemsCount
{
    return itemsList.count;
}

- (CGPoint) getStartPos
{
    return CGPointMake(columnXPos, 0);
}

- (CGPoint) getFirstVisibleTLPos
{
    if (startIndex < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:startIndex];
        return item.topLeftPos;
    }
    else {
        return CGPointMake(columnXPos, 0);
    }
}

- (CGPoint) getFirstVisibleBLPos
{
    if (startIndex < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:startIndex];
        return item.bottomLeftPos;
    }
    else {
        return CGPointMake(columnXPos, 0);
    }
}

- (CGPoint) getLastVisibleBLPos
{
    if (endIndex < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:endIndex];
        return item.bottomLeftPos;
    }
    else {
        return CGPointMake(columnXPos, 0);
    }
}

- (CGPoint) getLastVisibleTLPos
{
    if (endIndex < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:endIndex];
        return item.topLeftPos;
    }
    else {
        return CGPointMake(columnXPos, 0);
    }
}

- (CGPoint) getEndPos
{
    if (itemsList.count > 0)
    {
        ColumnItem* item = [itemsList objectAtIndex:itemsList.count -1];
        return item.bottomLeftPos;
    }
    else 
    {
        return CGPointMake(columnXPos, 0);
    }
}

- (int) getBeforeFirstVisibleIndex
{
    if (startIndex - 1 < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:startIndex - 1];
        return item.itemIndex;
    }
    else {
        return -1;
    }
}

- (int) getAfterLastVisibleIndex
{
    if (endIndex + 1 < itemsList.count) {
        ColumnItem* item = [itemsList objectAtIndex:endIndex + 1];
        return item.itemIndex;
    }
    else {
        return -1;
    }
}

- (bool) isTopCanAddItemInScreen:(int) topOffset
{
    if (itemsList.count == 0 || [self getFirstVisibleTLPos].y > topOffset)
    {
        return YES;
    }
    else {
        return NO;
    }
}

- (bool) isBottomCanAddItemInScreen:(int) bottomOffset
{
    if (itemsList.count == 0 || [self getLastVisibleBLPos].y < bottomOffset)
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

- (void) scrollUptoPosY:(int) offsetY
{
    if (itemsList.count == 0)
    {
        return;
    }
    int preCacheHeight = [delegate getTopCacheOffset];
    for (int index = startIndex; startIndex>=0; index--)
    {
        if (offsetY - preCacheHeight < [self getFirstVisibleBLPos].y) 
        {
            int dataIndex = [self getBeforeFirstVisibleIndex];
            if (dataIndex == -1)
            {
                return;
            }
            
            BlogDataItem* data = [delegate getSubDataItem:dataIndex];
            //[self configItemBefore:data withIndex:dataIndex];
            [self configPreItem:data withIndex:dataIndex];
        }
        else {
            break;
        }
    }
    
    int botCacheHeight = [delegate getBottomCacheOffset];
    for (int index = endIndex; index < itemsList.count; index++)
    {
        if (offsetY + botCacheHeight < [self getLastVisibleTLPos].y) 
        {
//            int dataIndex = [self getLastVisibleIndex];
//            [self releaseItem:dataIndex];
            [self releaseLastItem];
        }
        else {
            break;
        }
    }
}

- (void) scrollDowntoPosY:(int) offsetY
{
    if (itemsList.count == 0)
    {
        return;
    }
    int botCacheHeight = [delegate getBottomCacheOffset];
    for (int index = endIndex; index < itemsList.count; index++)
    {
        if (offsetY + botCacheHeight > [self getLastVisibleTLPos].y) 
        {
            int dataIndex = [self getAfterLastVisibleIndex];
            if (dataIndex == -1) {
                return;
            }
            BlogDataItem* data = [delegate getSubDataItem:dataIndex];
//            [self configItem:data withIndex:dataIndex];
            [self configNextItem:data withIndex:dataIndex];
        }
        else {
            break;
        }
    }
    
    int preCacheHeight = [delegate getTopCacheOffset];
    for (int index = startIndex; startIndex>=0; index--)
    {
        if (offsetY - preCacheHeight > [self getFirstVisibleBLPos].y) 
        {
//            int dataIndex = [self getFirstVisibleIndex];
//            //BlogDataItem* data = [delegate getSubDataItem:dataIndex];
//            //[self configItemBefore:data withIndex:dataIndex];
//            [self releaseItem:dataIndex];
            [self releaseFirstItem];
        }
        else {
            break;
        }
    }
}

@end
