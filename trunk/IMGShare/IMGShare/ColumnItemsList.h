//
//  ColumnItemsList.h
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogDataItem.h"
#import "ScrollImageItem.h"

@protocol ColumnListDelegate <NSObject>

- (int) getTopCacheOffset;
- (int) getBottomCacheOffset;
- (ScrollImageItem*) getSubImageItem;
- (void) releaseSubImageItem:(ScrollImageItem*) imageItem;

@end

@interface ColumnItemsList : NSObject
{
    int     startIndex;
    int     endIndex;
    NSMutableArray*     itemsList;
    id<ColumnListDelegate> delegate;
    
    int     columnWidth;
}

- (id) init:(id) delegate withWidth:(int) columnWid;
- (void) initSubItem:(BlogDataItem*) dataItem withIndex:(int) index;
- (void) configItem:(BlogDataItem*) dataItem withIndex:(int) index;
- (void) releaseItem:(int) index;

- (CGPoint) getFirstPos;

- (CGPoint) getLastPos;

- (bool) isTopCanAddItemInScreen:(int) topOffset;

- (bool) isBottomCanAddItemInScreen:(int) bottomOffset;

@end
