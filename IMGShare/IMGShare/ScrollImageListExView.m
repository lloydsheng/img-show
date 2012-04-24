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

@interface ScrollImageListExView(Private)
- (void) confiyArr:(NSMutableArray*) array withLimit:(int) count;
- (CGSize) GetSizeInView:(CGSize) orgialSize;

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
    
    allItemsColumn = [[NSMutableArray alloc] initWithCapacity:column];
    for (int index = 0; index < column; index++)
    {
        [allItemsColumn addObject:[NSMutableArray arrayWithCapacity:10]];
    }
    
    preCachePosArr = [[NSMutableArray alloc] initWithCapacity:column];
    [self confiyArr:preCachePosArr withLimit:column];
    nextCachePosArr = [[NSMutableArray alloc] initWithCapacity:column];
    [self confiyArr:nextCachePosArr withLimit:column];
    
    reuseList = [[NSMutableArray alloc] initWithCapacity:10];
    
    hightPreCache = frame.size.height / 2;
    hightNextCache = frame.size.height / 2;
    
    eachItemWidGrap = 4;
    itemWidth = (self.bounds.size.width - itemCountEachRow * (eachItemWidGrap + 1)) / itemCountEachRow;
    
    return self;
    
}

- (void) config
{
//    for (int index = 0; index < [imageDelegate GetItemsCount]; index++)
//    {
//        ScrollImageItem* item = [[ScrollImageItem alloc] initWithFrame:CGRectZero
//                                                              delegate:self];
//        [self configImage:item withIndex:index];
//        [item release];
//        
//        if (nextPageItemPosArr.count >= countEachRow )
//        {
//            break;
//        }
//    }
//    
//    if (nextPageItemPosArr.count != 0 )
//    {
//        int offset =  [[nextPageItemPosArr objectAtIndex: nextPageItemPosArr.count - 1] CGPointValue].y  ;
//        self.contentSize = CGSizeMake(self.frame.size.width, offset);
//        
//    }
    for (int itemIndex = 0; itemIndex < [imageDelegate GetItemsCount]; itemIndex++) 
    {
        int colunmNum = -1;
        int offset = 0;
        NSMutableArray* list = [allItemsColumn objectAtIndex:index];
        for (int index = 0; index < itemCountEachRow; index++)
        {
            if (list.count == 0) 
            {
                ScrollImageItem* item = [[ScrollImageItem alloc] initWithFrame:CGRectZero
                                                                              delegate:self];
                CGPoint pos = CGPointMake(index * itemWidth + eachItemWidGrap * (index + 1), 0);
                [self configImage:item withIndex:index withPos: pos];
                [list addObject:[NSValue valueWithCGRect:item.frame]];
                [self addSubview:item];
                [item release];
                break;
            }
            
            CGRect rect = [[list objectAtIndex:list.count - 1] CGRectValue];
            int curItemY = rect.origin.y + rect.size.height;
            if(offset > curItemY) 
            {
                offset = curItemY;
                colunmNum = index;
            }
        }
        if (colunmNum != -1)
        {
            CGPoint pos = CGPointMake(colunmNum * itemWidth + eachItemWidGrap * (colunmNum + 1), 0);
            
            if (pos.y > self.contentOffset.y + self.frame.size.height + hightNextCache)
            {
                CGSize size = [self GetSizeInView:[imageDelegate GetItemSize:itemIndex]];
                [list addObject:[NSValue valueWithCGRect:CGRectMake(pos.x, pos.y, size.width, size.height)]];

            }
            else 
            {
                ScrollImageItem* item = [[ScrollImageItem alloc] initWithFrame:CGRectZero
                                                                      delegate:self];
                [self configImage:item withIndex:itemIndex withPos: pos];
                [list addObject:[NSValue valueWithCGRect:item.frame]];
                [self addSubview:item];
                [item release];
            }

        }
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) confiyArr:(NSMutableArray*) array withLimit:(int) count
{
    for (int index = 0; index < count; index++) {
        [array addObject:[NSNumber numberWithInt:0]];
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


@end
