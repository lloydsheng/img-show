//
//  ScrollImageListView.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageListView.h"
#import "ScrollImageItem.h"
#import "BlogDataItem.h"
#import "UtilsModel.h"

@interface ScrollImageListView (Priavte)

- (CGRect) getNextItemFrame:(CGSize) size;
- (CGRect) getProItemFrame:(CGSize) size;
//- (void) addPos:(CGRect) frame toTopList:(bool) isBottom withDirDown: (bool) downMove;
- (void) addPosItem2PrePage:(CGPoint) newPos toListHead:(bool) isStart;
- (void) addPosItem2NextPage:(CGPoint) newPos toListHead:(bool) isStart;
- (void) addImageItemTolist:(ScrollImageItem*) scrollItem withIndex:(int) itemIndex toListHeader:(bool) isHeader;
- (CGSize) GetSizeInView:(CGSize) orgialSize;
- (void) configImage:(ScrollImageItem*) item withIndex:(int) index;

@end

@implementation ScrollImageListView
@synthesize imageDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id) initWithFrame: (CGRect) frame withRowCount: (int) rowCount
{
    self = [self initWithFrame:frame];
    if (rowCount == 0) {
        countEachRow = 4;
    }
    else
    {
        countEachRow = rowCount;
    }
    
    allItemsPosArr = [[NSMutableArray alloc] initWithCapacity:20];
    visibleItemList = [[NSMutableArray alloc] initWithCapacity:rowCount];
    reuseItemList = [[NSMutableArray alloc] initWithCapacity:rowCount];
    nextPageItemPosArr = [[NSMutableArray alloc] initWithCapacity:rowCount];
    prePageItemPosArr = [[NSMutableArray alloc] initWithCapacity:rowCount];
    initPosInFirstRow = [[NSMutableArray alloc] initWithCapacity:rowCount];
    proPageCachePosHeight = frame.size.height / 2;
    nextPageCachePosHeight = proPageCachePosHeight;
    eachItemWidGrap = 4;

    itemWidth = (self.bounds.size.width - countEachRow * (eachItemWidGrap + 1)) / countEachRow;
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void) config
{
    for (int index = 0; index < [imageDelegate GetItemsCount]; index++)
    {
        ScrollImageItem* item = [[ScrollImageItem alloc] initWithFrame:CGRectZero
                                                              delegate:self];
        //[self addImageItemTolist: item withIndex: index toListHeader: NO];
        [self configImage:item withIndex:index];
        [item release];
        
        if (nextPageItemPosArr.count >= countEachRow )
        {
            break;
        }
    }
    
    if (nextPageItemPosArr.count != 0 )
    {
        int offset =  [[nextPageItemPosArr objectAtIndex: nextPageItemPosArr.count - 1] CGPointValue].y  ;
        self.contentSize = CGSizeMake(self.frame.size.width, offset);
        
    }
}

- (void) configImage:(ScrollImageItem*) scrollItem withIndex:(int) itemIndex
{
    if (imageDelegate && [imageDelegate respondsToSelector:@selector(GetImageItem:)])
    {
        BlogDataItem* itemData = (BlogDataItem*)[imageDelegate GetImageItem:itemIndex];
        if (itemData) 
        {
            
            NSString* url = [UtilsModel GetFullBlogUrlStr:itemData.pic_pid withImgType:EImageThumb];
            [scrollItem config:url withIndex:itemIndex];
            
            scrollItem.hidden = NO;

            [visibleItemList addObject:scrollItem];
        
            [self addSubview:scrollItem];
            
            CGRect frame = scrollItem.frame;
            if (itemIndex < countEachRow) 
            {
                [initPosInFirstRow addObject:[NSValue valueWithCGPoint:CGPointMake(frame.origin.x, frame.origin.y + frame.size.height)]];
            }
            int offsetY = frame.origin.y + frame.size.height;
            if (offsetY > self.frame.size.height + nextPageCachePosHeight)
            {
                [self addPosItem2NextPage:CGPointMake(frame.origin.x, offsetY) toListHead:NO];
            }
        }
    }
}

- (ScrollImageItem*) getReuseItem
{
    if (reuseItemList.count == 0) {
        return nil; 
    }
    else
    {
        ScrollImageItem* item = (ScrollImageItem*)[reuseItemList objectAtIndex:0];
        [reuseItemList removeObject:item];//superview retain it
        return item;
    }
}

- (void) addImageItemTolist:(ScrollImageItem*) scrollItem withIndex:(int) itemIndex toListHeader:(bool) isHeader
{
    if (imageDelegate && [imageDelegate respondsToSelector:@selector(GetImageItem:)])
    {
        BlogDataItem* itemData = (BlogDataItem*)[ imageDelegate GetImageItem:itemIndex];
        if (itemData) 
        {
            
            if (isHeader) 
            {
                scrollItem.frame = [self getProItemFrame:CGSizeMake([itemData.pic_pwidth floatValue], [itemData.pic_pheight floatValue])];
                //[self addPos:scrollItem.frame toTopList:YES withDirDown:NO];   
                [self addPosItem2PrePage:scrollItem.frame.origin toListHead:YES];
            }
            else
            {
                scrollItem.frame = [self getNextItemFrame:CGSizeMake([itemData.pic_pwidth floatValue], [itemData.pic_pheight floatValue])];
                //[self addPos:scrollItem.frame toTopList:NO withDirDown:YES];   
                [self addPosItem2NextPage:CGPointMake(scrollItem.frame.origin.x, scrollItem.frame.origin.y + scrollItem.frame.size.height) toListHead:NO];
            }
            
            NSString* url = [UtilsModel GetFullBlogUrlStr:itemData.pic_pid withImgType:EImageThumb];
            [scrollItem config:url withIndex:itemIndex];

            scrollItem.hidden = NO;
            if (isHeader) 
            {
                [visibleItemList insertObject:scrollItem atIndex:0];
            }
            else
            {
                [visibleItemList addObject:scrollItem];
            }

            
            if (scrollItem.superview == nil) {
                [self addSubview:scrollItem];
            }
            
        }
    }
}

- (void) removeImageItemFromList:(ScrollImageItem*) scrollItem fromListHeader:(bool) fromHeader
{
    
    if (scrollItem) 
    {
        if (fromHeader) 
        {
            //[self addPos:scrollItem.frame toTopList:YES withDirDown:NO];  
            CGRect scrollRect = scrollItem.frame;
            CGPoint pos = CGPointMake(scrollRect.origin.x, scrollRect.origin.y + scrollRect.size.height);
            [self addPosItem2PrePage:pos toListHead:NO];
        }
        else
        {
            //[self addPos:scrollItem.frame toTopList:NO withDirDown:YES];   
            [self addPosItem2NextPage:scrollItem.frame.origin toListHead:YES];
            
        }
        
        [reuseItemList addObject:scrollItem];
        [visibleItemList removeObject:scrollItem];
        scrollItem.hidden = YES;
        scrollItem.imageView.image = nil;
        scrollItem.tag = 0;
        
    }
}

- (CGRect) getNextItemFrame:(CGSize) size
{
    CGPoint pos = CGPointZero;

    int prePageCount = nextPageItemPosArr.count;

    if (prePageCount == countEachRow) 
    {
        pos = [[nextPageItemPosArr objectAtIndex:0] CGPointValue];
    }
    else if(prePageCount >= 0)
    {
        pos = CGPointMake(prePageCount * itemWidth + eachItemWidGrap * (prePageCount + 1), 0);
    }
    int itemHeight = size.height * itemWidth / (size.width ? size.width : 300);
    return CGRectMake(pos.x, pos.y, itemWidth, itemHeight);

}

- (CGRect) getProItemFrame:(CGSize) size
{
    CGPoint pos = CGPointZero;
    
    int prePageCount = prePageItemPosArr.count;
    if (prePageCount == countEachRow) 
    {
        pos = [[prePageItemPosArr objectAtIndex:prePageCount - 1] CGPointValue];
    }
    else if(prePageCount >= 0)
    {
        //CGPoint lastItemPos  = [[prePageItemPosArr objectAtIndex:prePageItemPosArr.count - 1] CGPointValue];
        pos = CGPointMake(prePageCount * itemWidth + eachItemWidGrap * (prePageCount + 1), 0);
    }
    
    int itemHeight = size.height * itemWidth / (size.width ? size.width : 300);
    return CGRectMake(pos.x, pos.y - itemHeight, itemWidth, itemHeight);
}

//- (void) addPos:(CGRect) frame toTopList:(bool) isBottom withDirDown: (bool) downMove
//{
//    if (isBottom) 
//    {
//        if (downMove) 
//        {
//            if (nextPageItemPosArr.count == countEachRow) 
//            {
//                [nextPageItemPosArr removeObjectAtIndex:0];
//            }
//            int index = 0;
//            int posY = frame.size.height + frame.origin.y;
//            for (; index < nextPageItemPosArr.count; index++) 
//            {
//                if (posY < [[nextPageItemPosArr objectAtIndex:index] CGPointValue].y) {
//                    [nextPageItemPosArr insertObject:[NSValue valueWithCGPoint:CGPointMake(frame.origin.x, posY)] atIndex:index];
//                    break;
//                }
//                
//            }
//            if (index == nextPageItemPosArr.count) 
//            {
//                //index = 0 or for运行到最后
//                [nextPageItemPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(frame.origin.x, posY) ]];   
//
//            }
//        }
//        else//up
//        {
//            if (nextPageItemPosArr.count == countEachRow) 
//            {
//                [nextPageItemPosArr removeObjectAtIndex:countEachRow - 1];
//            }
//            int index = nextPageItemPosArr.count -1;
//            int posY = frame.size.height + frame.origin.y;
//            for (; index >= 0; index--) 
//            {
//                if (posY > [[nextPageItemPosArr objectAtIndex:index] CGPointValue].y) 
//                {
//                    [nextPageItemPosArr insertObject:[NSValue valueWithCGPoint:CGPointMake(frame.origin.x, posY)] atIndex:index + 1];//越界应直接加在最后？？
//                    break;
//                }
//                
//            }
//            if (index == -1) 
//            {
//                [nextPageItemPosArr insertObject:[NSValue valueWithCGPoint:CGPointMake(frame.origin.x, posY) ] atIndex: 0];
//            }
//        }
//    }
//    else//top
//    {
//        if (downMove)
//        {
//            if (prePageItemPosArr.count == countEachRow)
//            {
//                [prePageItemPosArr removeObjectAtIndex:countEachRow - 1];
//            }
//            int index = 0;
//            for (; index < prePageItemPosArr.count; index++)
//            {
//                if (frame.origin.y > [[prePageItemPosArr objectAtIndex:index] CGPointValue].y)
//                {
//                    [prePageItemPosArr insertObject:[NSValue valueWithCGPoint:frame.origin] atIndex:index];
//                    break;
//                }
//            }
//            if (index == prePageItemPosArr.count) {
//                [prePageItemPosArr addObject:[NSValue valueWithCGPoint:frame.origin]];
//            }
//            
//        }
//        else
//        {
//            if (prePageItemPosArr.count == countEachRow) 
//            {
//                [prePageItemPosArr removeObjectAtIndex:0];
//            }
//            
//            int index = 0;
//            for (; index < prePageItemPosArr.count; index++)
//            {
//                if (frame.origin.y > [[prePageItemPosArr objectAtIndex:index] CGPointValue].y)
//                {
//                    [prePageItemPosArr insertObject:[NSValue valueWithCGPoint:frame.origin] atIndex:index];
//                    break;
//                }
//            }
//            if (index == prePageItemPosArr.count) {
//                [prePageItemPosArr addObject:[NSValue valueWithCGPoint:frame.origin]];
//            }
//            
//        }
//    }
//}

- (void) addPosItem2PrePage:(CGPoint) newPos toListHead:(bool) isStart
{
    if (isStart)
    {
        if (prePageItemPosArr.count == countEachRow)
        {
            [prePageItemPosArr removeObjectAtIndex:countEachRow - 1];
        }
        int index = 0;
        for (; index < prePageItemPosArr.count; index++)
        {
            if (newPos.y < [[prePageItemPosArr objectAtIndex:index] CGPointValue].y)
            {
                [prePageItemPosArr insertObject:[NSValue valueWithCGPoint:newPos] atIndex:index];
                break;
            }
        }
        if (index == prePageItemPosArr.count) {
            [prePageItemPosArr addObject:[NSValue valueWithCGPoint:newPos]];
        }
        
    }
    else
    {
        if (prePageItemPosArr.count == countEachRow) 
        {
            [prePageItemPosArr removeObjectAtIndex:0];
        }
        
        int index = prePageItemPosArr.count - 1;
        for (; index >= 0; index--)
        {
            if (newPos.y > [[prePageItemPosArr objectAtIndex:index] CGPointValue].y)
            {
                if (index == prePageItemPosArr.count - 1)
                {
                    [prePageItemPosArr addObject:[NSValue valueWithCGPoint:newPos]];
                }
                else 
                {
                    [prePageItemPosArr insertObject:[NSValue valueWithCGPoint:newPos] atIndex:index + 1];
                }     
                break;
            }
        }
        if (index == -1) {
            [prePageItemPosArr insertObject:[NSValue valueWithCGPoint:newPos] atIndex:0];
        }
        
    }

}

- (void) addPosItem2NextPage:(CGPoint) newPos toListHead:(bool) isStart
{
    if (!isStart) 
    {
        if (nextPageItemPosArr.count == countEachRow) 
        {
            [nextPageItemPosArr removeObjectAtIndex:0];
        }
        int index = nextPageItemPosArr.count -1;
        for (; index >= 0; index--) 
        {
            if (newPos.y > [[nextPageItemPosArr objectAtIndex:index] CGPointValue].y) 
            {
                [nextPageItemPosArr insertObject:[NSValue valueWithCGPoint:newPos] atIndex:index + 1];//越界应直接加在最后？？
                break;
            }
            
        }
        if (index == -1) 
        {
            [nextPageItemPosArr insertObject:[NSValue valueWithCGPoint:newPos ] atIndex: 0];
        }
        
    }
    else//up
    {
        if (nextPageItemPosArr.count == countEachRow) 
        {
            [nextPageItemPosArr removeObjectAtIndex:countEachRow - 1];
        }
        int index = 0;
        int posY = newPos.y;
        for (; index < nextPageItemPosArr.count; index++) 
        {
            if (posY < [[nextPageItemPosArr objectAtIndex:index] CGPointValue].y) {
                [nextPageItemPosArr insertObject:[NSValue valueWithCGPoint:newPos] atIndex:index];
                break;
            }
            
        }
        if (index == nextPageItemPosArr.count) 
        {
            //index = 0 or for运行到最后
            [nextPageItemPosArr addObject:[NSValue valueWithCGPoint:newPos ]];   
            
        }
    }

}

- (CGSize) GetSizeInView:(CGSize) orgialSize
{
    int itemHeight = orgialSize.height * itemWidth / (orgialSize.width ? orgialSize.width : 300);
    return CGSizeMake(itemWidth, itemHeight);
}

- (void) updateVisibleListWhenScroll2Up
{
    if(visibleItemList.count == 0)
        return;
    
    int visibleCount = 0;
    NSMutableArray* delArr = [[NSMutableArray alloc] initWithCapacity:3];
    for (int index = visibleItemList.count - 1; index >= 0; index --) 
    {
        ScrollImageItem* item = [visibleItemList objectAtIndex:index];
        if (item.frame.origin.y - self.contentOffset.y - self.frame.size.height - proPageCachePosHeight > 0 ) 
        {
            //[self removeImageItemFromList:item fromListHeader:YES];
            [delArr addObject:item];
        }
        else
        {
            ++visibleCount;
            if (visibleCount >= countEachRow) 
            {
                break;
            }
            
        }
    }
    for (int pos = 0; pos < delArr.count; pos++) 
    {
        [self removeImageItemFromList:[delArr objectAtIndex:pos] fromListHeader:NO];
    }
    [delArr removeAllObjects];
    [delArr release], delArr = nil;
    
    ScrollImageItem* firstItem = [visibleItemList objectAtIndex:0];
    int lastItemIndex = firstItem.tag;
    NSLog(@"index tag %d", lastItemIndex);

    
    for (int curIndex = lastItemIndex - 1 ; curIndex >= 0 && prePageItemPosArr.count > 0; curIndex--)
    {
        CGSize size;
        CGPoint pos;
        //第一行则用保存好的第一行位置，非第一行的item用prePageItemArr处理
        if (curIndex >= countEachRow) 
        {
            size = [imageDelegate GetItemSize:curIndex];
            size = [self GetSizeInView: size];
            pos = [[prePageItemPosArr objectAtIndex:prePageItemPosArr.count - 1] CGPointValue];
        }
        else if(curIndex < initPosInFirstRow.count)
        {
            //pos = [[initPosInFirstRow objectAtIndex:curIndex] CGPointValue];
            for (int indexInRow = 0; indexInRow < initPosInFirstRow.count; indexInRow++) 
            {
                CGPoint lbPos = [[initPosInFirstRow objectAtIndex:indexInRow] CGPointValue];
                //if (lbPos == firstItem.frame.origin) 
                {
                    
                }
            }
        }
        
        if (pos.y - self.contentOffset.y + proPageCachePosHeight > 0 ) 
        {
            CGRect rect = [self getProItemFrame:size];
            ScrollImageItem* item = [self getReuseItem];
            if (item == nil) 
            {
                item = [[[ScrollImageItem alloc] initWithFrame:rect delegate:self] autorelease];
            }
            else
            {
                [item setFrame:rect];
            }
            [item config:[imageDelegate GetItemUrlStr:curIndex] withIndex:curIndex];
            
            [self addImageItemTolist:item withIndex:curIndex toListHeader:YES];   
        }
        else
        {
            break;
        }
    }

}

- (void) updateVisibleListWhenScroll2Down
{
    if(visibleItemList.count == 0)
        return;
    
    int visibleCount = 0;
    NSMutableArray* delArr = [[NSMutableArray alloc] initWithCapacity:3];
    for (int index = 0; index < visibleItemList.count; index ++) 
    {
        ScrollImageItem* item = [visibleItemList objectAtIndex:index];
        if ( item.frame.origin.y + item.frame.size.height - self.contentOffset.y + proPageCachePosHeight < 0)
        {
            //[self removeImageItemFromList:item fromListHeader:YES];
            [delArr addObject:item];
        }
        else
        {
            ++visibleCount;
            if (visibleCount >= countEachRow) 
            {
                break;
            }
                
        }
    }
    for (int pos = 0; pos < delArr.count; pos++) 
    {
        [self removeImageItemFromList:[delArr objectAtIndex:pos] fromListHeader:YES];
    }
    [delArr removeAllObjects];
    [delArr release], delArr = nil;
    
    
    ///////////////////////////////////////////////////
    
    
    ScrollImageItem* lastItem = [visibleItemList objectAtIndex:visibleItemList.count -1];
    int lastItemIndex = lastItem.tag;
    NSLog(@"index tag %d", lastItemIndex);
    
    for (int curIndex = lastItemIndex + 1; curIndex < [imageDelegate GetItemsCount] && nextPageItemPosArr.count > 0; curIndex++)
    {
        CGSize size = [imageDelegate GetItemSize:curIndex];
        size = [self GetSizeInView: size];
        CGPoint pos = [[nextPageItemPosArr objectAtIndex:0] CGPointValue];

        if (pos.y - self.contentOffset.y - self.frame.size.height - proPageCachePosHeight < 0 ) 
        {
            CGRect rect = [self getNextItemFrame:size];
            ScrollImageItem* item = [self getReuseItem];
            if (item == nil) 
            {
                item = [[[ScrollImageItem alloc] initWithFrame:rect delegate:self] autorelease];
            }
            else
            {
                [item setFrame:rect];
            }
            [item config:[imageDelegate GetItemUrlStr:curIndex] withIndex:curIndex];
            
            [self addImageItemTolist:item withIndex:curIndex toListHeader:NO];   
        }
        else
        {
            break;
        }
    }
    
    if (nextPageItemPosArr.count > 0) 
    {
        int offset =  [[nextPageItemPosArr objectAtIndex: nextPageItemPosArr.count - 1] CGPointValue].y;
        self.contentSize = CGSizeMake(self.frame.size.width, offset);  
    }
    
}

- (void) btPressed
{
    
}

@end
